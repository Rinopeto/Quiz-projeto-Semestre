
const express = require("express");
const cors = require("cors");
const { pool } = require("./db");

const NAME_MAX = 20;
const MAX_ANSWERS = 100;
const MAX_POINTS = 10;
const STATUSES = new Set(["correct", "incorrect", "timeout"]);

/* ---------- Perguntas ---------- */

const QUESTIONS_SQL = `
  SELECT q.id,
         c.nome AS category,
         q.pergunta AS question,
         q.explicacao AS explanation,
         COALESCE(f.nome, q.nome_fonte) AS "sourceName",
         COALESCE(f.url, q.url_fonte) AS "sourceUrl",
         q.dificuldade_pergunta AS difficulty,
         q.pergunta_bonus AS bonus,
         array_agg(o.alternativas ORDER BY o.posicao_pergunta) AS options,
         MIN(o.posicao_pergunta) FILTER (WHERE o.esta_correto) AS "correctAnswer"
  FROM (
    SELECT *
    FROM questao_quiz
    WHERE ativo
    ORDER BY random()
    LIMIT $1
  ) q
  JOIN categorias_perguntas c ON c.id = q.categoria_id
  LEFT JOIN fontes f ON f.id = q.fonte_id
  JOIN opcoes_perguntas o ON o.id_pergunta = q.id
  GROUP BY
  q.id,
  c.nome,
  f.nome,
  f.url,
  q.pergunta,
  q.explicacao,
  q.nome_fonte,
  q.url_fonte,
  q.dificuldade_pergunta,
  q.pergunta_bonus
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

function validateMatch(body) {
  if (!body || typeof body !== "object") {
    return { error: "Corpo da requisição inválido." };
  }

  const playerName = typeof body.playerName === "string"
    ? body.playerName.trim()
    : "";

  if (playerName.length < 1 || playerName.length > NAME_MAX) {
    return { error: `playerName deve ter de 1 a ${NAME_MAX} caracteres.` };
  }

  if (!Array.isArray(body.answers) ||
      body.answers.length < 1 ||
      body.answers.length > MAX_ANSWERS) {
    return { error: `answers deve ser uma lista com 1 a ${MAX_ANSWERS} itens.` };
  }

  const answers = [];
  const seen = new Set();

  for (const a of body.answers) {
    if (!a || typeof a !== "object") {
      return { error: "Resposta inválida em answers." };
    }

    const selected =
      a.selectedAnswer === null || a.selectedAnswer === undefined
        ? null
        : a.selectedAnswer;

    const valid =
      isInt(a.questionId, 1, 2147483647) &&
      (selected === null || isInt(selected, 0, 9)) &&
      STATUSES.has(a.status) &&
      isInt(a.points, 0, MAX_POINTS) &&
      typeof a.timeSpent === "number" &&
      Number.isFinite(a.timeSpent) &&
      a.timeSpent >= 0 &&
      a.timeSpent <= 999;

    if (!valid) {
      return { error: "Há campos inválidos em answers." };
    }

    if (seen.has(a.questionId)) {
      return { error: "Pergunta repetida na mesma partida." };
    }

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

  if (body.totalScore !== sum) {
    return { error: "totalScore não confere com a soma dos pontos." };
  }

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
  let transactionStarted = false;

  try {
    const ids = value.answers.map(a => a.questionId);

    const { rows } = await client.query(
      `SELECT id_pergunta, posicao_pergunta
       FROM opcoes_perguntas
       WHERE esta_correto
       AND id_pergunta = ANY($1::int[])`,
      [ids]
    );

    const correctBy = new Map(
      rows.map(r => [r.id_pergunta, r.posicao_pergunta])
    );

    for (const a of value.answers) {
      if (!correctBy.has(a.questionId)) {
        return res.status(400).json({ error: "Pergunta inexistente." });
      }

      const hit =
        a.selectedAnswer !== null &&
        a.selectedAnswer === correctBy.get(a.questionId);

      const consistent =
        (a.status === "correct" && hit) ||
        (a.status === "incorrect" && a.selectedAnswer !== null && !hit) ||
        (a.status === "timeout" &&
          a.selectedAnswer === null &&
          a.points === 0);

      if (!consistent) {
        return res.status(400).json({
          error: "Resposta inconsistente com o gabarito."
        });
      }
    }

    const totalTime = Number(
      value.answers
        .reduce((total, a) => total + a.timeSpent, 0)
        .toFixed(2)
    );

    await client.query("BEGIN");
    transactionStarted = true;

    await client.query(
      `INSERT INTO jogadores (nome)
       SELECT $1
       WHERE NOT EXISTS (
         SELECT 1 FROM jogadores WHERE nome = $1
       )`,
      [value.playerName]
    );

    const player = await client.query(
      `SELECT id
       FROM jogadores
       WHERE nome = $1
       ORDER BY id
       LIMIT 1`,
      [value.playerName]
    );

    const match = await client.query(
      `INSERT INTO dados_partidas
        (nome_jogador, jogador_id, pontuacao_total,
         tempo_total, comeco_em, terminou_em)
       VALUES ($1, $2, $3, $4, $5, COALESCE($6, now()))
       RETURNING id`,
      [
        value.playerName,
        player.rows[0].id,
        value.totalScore,
        totalTime,
        value.startedAt,
        value.finishedAt
      ]
    );

    const matchId = match.rows[0].id;

    for (const a of value.answers) {
      await client.query(
        `INSERT INTO registro_perguntas
          (id_partida, pergunta_id, posicao_selecionada,
           status, pontos, tempo_gasto)
         VALUES ($1, $2, $3, $4, $5, $6)`,
        [
          matchId,
          a.questionId,
          a.selectedAnswer,
          a.status,
          a.points,
          a.timeSpent
        ]
      );
    }

    await client.query("COMMIT");
    transactionStarted = false;

    return res.status(201).json({ id: matchId });
  } catch (err) {
    if (transactionStarted) {
      await client.query("ROLLBACK").catch(() => {});
    }

    throw err;
  } finally {
    client.release();
  }
}

/* ---------- App ---------- */

const wrap = (fn) =>
  (req, res, next) =>
    Promise.resolve(fn(req, res, next)).catch(next);

function createApp() {
  const app = express();

  const origins = (process.env.CORS_ORIGIN || "")
    .split(",")
    .map(s => s.trim())
    .filter(Boolean);

  app.use(cors({
    origin: origins.length ? origins : true,
    methods: ["GET", "POST"]
  }));

  app.use(express.json({ limit: "50kb" }));

  app.get("/api/health", wrap(async (req, res) => {
    try {
      await pool.query("SELECT 1");
      res.json({ status: "ok" });
    } catch (err) {
      console.error("Health check falhou:", err.message);
      res.status(503).json({ status: "error" });
    }
  }));

  app.get("/api/questions", wrap(getQuestions));
  app.post("/api/matches", wrap(postMatch));

  app.use((req, res) =>
    res.status(404).json({ error: "Rota não encontrada." })
  );

  app.use((err, req, res, next) => {
    if (err.type === "entity.parse.failed") {
      return res.status(400).json({ error: "JSON inválido." });
    }

    if (err.type === "entity.too.large") {
      return res.status(413).json({ error: "Corpo grande demais." });
    }

    console.error(err);
    res.status(500).json({ error: "Erro interno do servidor." });
  });

  return app;
}

module.exports = { createApp, validateMatch };
