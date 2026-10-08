const express = require("express");
const cors = require("cors");
const { pool } = require("./db");

const NAME_MAX = 20;
const MAX_ANSWERS = 100;
const MAX_POINTS = 10;
const STATUSES = new Set(["correct", "incorrect", "timeout"]);

/* ---------- Perguntas ---------- */

// Mesmo formato usado pelo front (js/questions.js): options em ordem e correctAnswer = índice.
const QUESTIONS_SQL = `
  SELECT q.id,
         c.name AS category,
         q.statement AS question,
         q.explanation,
         q.source_name AS "sourceName",
         q.source_url AS "sourceUrl",
         q.difficulty,
         q.is_bonus AS bonus,
         array_agg(o.text ORDER BY o.position) AS options,
         MIN(o.position) FILTER (WHERE o.is_correct) AS "correctAnswer"
  FROM (SELECT * FROM questions WHERE active ORDER BY random() LIMIT $1) q
  JOIN categories c ON c.id = q.category_id
  JOIN options o ON o.question_id = q.id
  GROUP BY q.id, c.name, q.statement, q.explanation, q.source_name, q.source_url, q.difficulty, q.is_bonus
`;

async function getQuestions(req, res) {
  const requested = Number.parseInt(req.query.limit, 10);
  const limit = Math.min(Math.max(Number.isNaN(requested) ? 10 : requested, 1), 50);
  const { rows } = await pool.query(QUESTIONS_SQL, [limit]);
  res.json(rows);
}

/* ---------- Partidas ---------- */

function isInt(value, min, max) {
  return Number.isInteger(value) && value >= min && value <= max;
}

function parseDate(value) {
  if (typeof value !== "string") return null;
  const date = new Date(value);
  return Number.isNaN(date.getTime()) ? null : date.toISOString();
}

// Valida o corpo de POST /api/matches. Devolve { error } ou { value }.
function validateMatch(body) {
  if (!body || typeof body !== "object") return { error: "Corpo da requisição inválido." };

  const playerName = typeof body.playerName === "string" ? body.playerName.trim() : "";
  if (playerName.length < 1 || playerName.length > NAME_MAX) {
    return { error: `playerName deve ter de 1 a ${NAME_MAX} caracteres.` };
  }

  if (!Array.isArray(body.answers) || body.answers.length < 1 || body.answers.length > MAX_ANSWERS) {
    return { error: `answers deve ser uma lista com 1 a ${MAX_ANSWERS} itens.` };
  }

  const answers = [];
  const seen = new Set();
  for (const a of body.answers) {
    if (!a || typeof a !== "object") return { error: "Resposta inválida em answers." };
    const selected = a.selectedAnswer === null || a.selectedAnswer === undefined ? null : a.selectedAnswer;
    const valid =
      isInt(a.questionId, 1, 2147483647) &&
      (selected === null || isInt(selected, 0, 9)) &&
      STATUSES.has(a.status) &&
      isInt(a.points, 0, MAX_POINTS) &&
      typeof a.timeSpent === "number" &&
      Number.isFinite(a.timeSpent) &&
      a.timeSpent >= 0 &&
      a.timeSpent <= 999;
    if (!valid) return { error: "Há campos inválidos em answers." };
    if (seen.has(a.questionId)) return { error: "Pergunta repetida na mesma partida." };
    seen.add(a.questionId);
    answers.push({
      questionId: a.questionId,
      selectedAnswer: selected,
      status: a.status,
      points: a.points,
      timeSpent: a.timeSpent
    });
  }

  const sum = answers.reduce((total, a) => total + a.points, 0);
  if (body.totalScore !== sum) return { error: "totalScore não confere com a soma dos pontos." };

  return {
    value: {
      playerName,
      totalScore: sum,
      startedAt: parseDate(body.startedAt),
      finishedAt: parseDate(body.finishedAt),
      answers
    }
  };
}

async function postMatch(req, res) {
  const { error, value } = validateMatch(req.body);
  if (error) return res.status(400).json({ error });

  const client = await pool.connect();
  try {
    // Confere cada resposta com o gabarito do banco.
    const ids = value.answers.map((a) => a.questionId);
    const { rows } = await client.query(
      "SELECT question_id, position FROM options WHERE is_correct AND question_id = ANY($1::int[])",
      [ids]
    );
    const correctBy = new Map(rows.map((r) => [r.question_id, r.position]));

    for (const a of value.answers) {
      if (!correctBy.has(a.questionId)) return res.status(400).json({ error: "Pergunta inexistente." });
      const hit = a.selectedAnswer !== null && a.selectedAnswer === correctBy.get(a.questionId);
      const consistent =
        (a.status === "correct" && hit) ||
        (a.status === "incorrect" && a.selectedAnswer !== null && !hit) ||
        (a.status === "timeout" && a.selectedAnswer === null && a.points === 0);
      if (!consistent) return res.status(400).json({ error: "Resposta inconsistente com o gabarito." });
    }

    const totalTime = Number(value.answers.reduce((total, a) => total + a.timeSpent, 0).toFixed(2));

    await client.query("BEGIN");
    const match = await client.query(
      "INSERT INTO matches (player_name, total_score, total_time, started_at, finished_at) VALUES ($1, $2, $3, $4, COALESCE($5, now())) RETURNING id",
      [value.playerName, value.totalScore, totalTime, value.startedAt, value.finishedAt]
    );
    const matchId = match.rows[0].id;
    for (const a of value.answers) {
      await client.query(
        "INSERT INTO match_answers (match_id, question_id, selected_position, status, points, time_spent) VALUES ($1, $2, $3, $4, $5, $6)",
        [matchId, a.questionId, a.selectedAnswer, a.status, a.points, a.timeSpent]
      );
    }
    await client.query("COMMIT");
    res.status(201).json({ id: matchId });
  } catch (err) {
    await client.query("ROLLBACK").catch(() => {});
    throw err;
  } finally {
    client.release();
  }
}

/* ---------- Ranking geral ---------- */

// Ordem: maior pontuação; empate = menor tempo total; novo empate = quem jogou primeiro.
// Devolve o top N e, se informado ?matchId=, também a linha dessa partida (marcada com isYou).
const RANKING_SQL = `
  SELECT id, name, points, "totalTime", position, (id = $2::int) AS "isYou"
  FROM (
    SELECT id,
           player_name AS name,
           total_score AS points,
           total_time::float8 AS "totalTime",
           (ROW_NUMBER() OVER (ORDER BY total_score DESC, total_time ASC, id ASC))::int AS position
    FROM matches
  ) ranked
  WHERE position <= $1 OR id = $2::int
  ORDER BY position
`;

async function getRanking(req, res) {
  const requested = Number.parseInt(req.query.limit, 10);
  const limit = Math.min(Math.max(Number.isNaN(requested) ? 10 : requested, 1), 100);
  const matchId = Number.parseInt(req.query.matchId, 10);
  const { rows } = await pool.query(RANKING_SQL, [limit, Number.isNaN(matchId) ? null : matchId]);
  res.json(rows);
}

/* ---------- App ---------- */

// Encaminha erros de handlers async para o middleware de erro.
const wrap = (fn) => (req, res, next) => Promise.resolve(fn(req, res, next)).catch(next);

function createApp() {
  const app = express();

  // CORS_ORIGIN: origens permitidas separadas por vírgula (ex.: https://usuario.github.io).
  // Vazio = qualquer origem (apenas para desenvolvimento).
  const origins = (process.env.CORS_ORIGIN || "").split(",").map((s) => s.trim()).filter(Boolean);
  app.use(cors({ origin: origins.length ? origins : true, methods: ["GET", "POST"] }));
  app.use(express.json({ limit: "50kb" }));

  app.get("/api/health", wrap(async (req, res) => {
    try {
      await pool.query("SELECT 1");
      res.json({ status: "ok" });
    } catch (err) {
      res.status(503).json({ status: "error" });
    }
  }));
  app.get("/api/questions", wrap(getQuestions));
  app.get("/api/ranking", wrap(getRanking));
  app.post("/api/matches", wrap(postMatch));

  app.use((req, res) => res.status(404).json({ error: "Rota não encontrada." }));

  // eslint-disable-next-line no-unused-vars
  app.use((err, req, res, next) => {
    if (err.type === "entity.parse.failed") return res.status(400).json({ error: "JSON inválido." });
    if (err.type === "entity.too.large") return res.status(413).json({ error: "Corpo grande demais." });
    console.error(err);
    res.status(500).json({ error: "Erro interno do servidor." });
  });

  return app;
}

module.exports = { createApp, validateMatch };
