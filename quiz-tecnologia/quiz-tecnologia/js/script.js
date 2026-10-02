"use strict";

/* =========================================================
 * Configuração
 * ========================================================= */
const CONFIG = {
  SECONDS_PER_QUESTION: 50,
  WARNING_SECONDS: 10,
  MAX_POINTS_PER_QUESTION: 10,
  WRONG_ANSWER_POINTS: 1, // resposta errada vale 1 ponto; tempo esgotado vale 0
  QUESTIONS_PER_GAME: 10, // quantas perguntas sorteadas por partida (0 = todas)
  SHUFFLE_OPTIONS: true, // embaralha a ordem das alternativas
  RANKING_LIMIT: 10,
  OPTION_LABELS: ["A", "B", "C", "D", "E", "F"]
};

// Faixas de pontuação: tempo restante mínimo (segundos) => pontos.
// Abaixo da última faixa (e acima de 0) valem 3 pontos; tempo esgotado vale 0.
// Resposta errada vale CONFIG.WRONG_ANSWER_POINTS, independentemente do tempo.
const SCORE_TIERS = [
  { minSeconds: 40, points: 10 },
  { minSeconds: 35, points: 8 },
  { minSeconds: 25, points: 6 },
  { minSeconds: 15, points: 4 }
];
const LOWEST_POINTS = 3;

/* =========================================================
 * Estado da partida (sem referências ao DOM)
 * ========================================================= */
const state = {
  playerId: null, // futuramente: identificação do jogador
  playerName: "",
  questions: [],
  currentIndex: 0,
  totalScore: 0,
  results: [], // um registro por pergunta respondida/expirada
  selectedOption: null, // índice ORIGINAL da alternativa selecionada
  status: "idle", // idle | answering | answered | timeout
  startedAt: null
};

/* =========================================================
 * Serviços / dados (pontos de integração com o backend)
 * ========================================================= */
function shuffle(array) {
  const copy = [...array];
  for (let i = copy.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [copy[i], copy[j]] = [copy[j], copy[i]];
  }
  return copy;
}

// Sorteia as perguntas da partida e embaralha as alternativas.
// Cada alternativa guarda seu índice original, então embaralhar não afeta correctAnswer.
function prepareQuestions(rawQuestions) {
  const picked = shuffle(rawQuestions);
  const limited = CONFIG.QUESTIONS_PER_GAME ? picked.slice(0, CONFIG.QUESTIONS_PER_GAME) : picked;
  return limited.map((q) => {
    const options = q.options.map((text, originalIndex) => ({ text, originalIndex }));
    return { ...q, options: CONFIG.SHUFFLE_OPTIONS ? shuffle(options) : options };
  });
}

// Monta o payload enviado ao backend (POST /api/matches).
function buildMatchPayload() {
  return {
    playerId: state.playerId,
    playerName: state.playerName,
    startedAt: state.startedAt,
    finishedAt: new Date().toISOString(),
    totalScore: state.totalScore,
    summary: getSummary(),
    answers: state.results
  };
}

// Envia a partida ao backend. Sem API configurada, apenas registra no console.
async function saveMatch(payload) {
  if (!API_BASE_URL) {
    console.info("[quiz] Partida finalizada (sem API configurada):", payload);
    return;
  }
  const response = await fetch(`${API_BASE_URL}/api/matches`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload)
  });
  if (!response.ok) throw new Error(`HTTP ${response.status}`);
}

/*
 * Ranking da sessão (RQ04): guarda apenas { name, points } no sessionStorage.
 * A posição NÃO é salva, é calculada ao exibir. O ranking vale só para a sessão
 * do navegador (some ao fechar a aba).
 */
const ranking = {
  STORAGE_KEY: "techtrivia:ranking",

  list() {
    try {
      const parsed = JSON.parse(sessionStorage.getItem(this.STORAGE_KEY));
      return Array.isArray(parsed) ? parsed : [];
    } catch (err) {
      return [];
    }
  },

  // Adiciona a entrada e devolve a lista completa (a nova entrada é sempre a última).
  add(entry) {
    const all = this.list();
    all.push({ name: entry.name, points: entry.points });
    sessionStorage.setItem(this.STORAGE_KEY, JSON.stringify(all));
    return all;
  }
};

// Ordena por pontos (empates: quem jogou antes fica na frente) e calcula as posições.
function buildRankingView(all, currentIndex, limit = CONFIG.RANKING_LIMIT) {
  const sorted = all
    .map((entry, i) => ({ name: entry.name, points: entry.points, isYou: i === currentIndex }))
    .sort((a, b) => b.points - a.points)
    .map((entry, i) => ({ ...entry, position: i + 1 }));

  const rows = sorted.slice(0, limit);
  const you = sorted.find((entry) => entry.isYou);
  if (you && !rows.includes(you)) rows.push({ gap: true }, you);
  return rows;
}

/* =========================================================
 * Regras de negócio (funções puras)
 * ========================================================= */
function calculatePoints(secondsLeft) {
  if (secondsLeft <= 0) return 0;
  const tier = SCORE_TIERS.find((t) => secondsLeft >= t.minSeconds);
  return tier ? tier.points : LOWEST_POINTS;
}

function isCorrect(question, selectedOriginalIndex) {
  return selectedOriginalIndex === question.correctAnswer;
}

function getSummary() {
  const correct = state.results.filter((r) => r.status === "correct").length;
  const wrong = state.results.filter((r) => r.status === "incorrect").length;
  const timeouts = state.results.filter((r) => r.status === "timeout").length;
  return {
    totalQuestions: state.questions.length,
    correct,
    wrong,
    answered: correct + wrong,
    timeouts,
    maxScore: state.questions.length * CONFIG.MAX_POINTS_PER_QUESTION
  };
}

function getEndMessage(summary, name) {
  const ratio = summary.totalQuestions ? summary.correct / summary.totalQuestions : 0;
  if (ratio >= 0.8) return `Mandou muito bem, ${name}! Será que você consegue superar essa pontuação?`;
  if (ratio >= 0.5) return `Bom trabalho, ${name}! Que tal jogar de novo e subir no ranking?`;
  return `Boa, ${name}! Toda partida revela algo novo. Jogue de novo e veja quanto você evolui!`;
}

/* =========================================================
 * Cronômetro (independente do DOM)
 * ========================================================= */
const timer = {
  intervalId: null,
  deadline: 0,

  start(seconds, onTick, onExpire) {
    this.stop();
    this.deadline = Date.now() + seconds * 1000;
    const tick = () => {
      const remaining = Math.max(0, (this.deadline - Date.now()) / 1000);
      onTick(remaining);
      if (remaining <= 0) {
        this.stop();
        onExpire();
      }
    };
    tick();
    this.intervalId = setInterval(tick, 100);
  },

  stop() {
    clearInterval(this.intervalId);
    this.intervalId = null;
  },

  // Segundos restantes neste instante
  remaining() {
    return Math.max(0, (this.deadline - Date.now()) / 1000);
  }
};

/* =========================================================
 * Interface (única camada que toca o DOM)
 * ========================================================= */
const $ = (id) => document.getElementById(id);
const ui = {
  screens: {
    start: $("screen-start"),
    loading: $("screen-loading"),
    error: $("screen-error"),
    quiz: $("screen-quiz"),
    result: $("screen-result")
  },
  playerName: $("player-name"),
  nameHint: $("name-hint"),
  startBtn: $("start-btn"),
  errorMessage: $("error-message"),
  retryBtn: $("retry-btn"),
  progressText: $("progress-text"),
  progress: $("progress"),
  progressBar: $("progress-bar"),
  totalScore: $("total-score"),
  timer: $("timer"),
  timerValue: $("timer-value"),
  timerPoints: $("timer-points"),
  timerBar: $("timer-bar"),
  category: $("category"),
  questionText: $("question-text"),
  options: $("options"),
  feedback: $("feedback"),
  feedbackTitle: $("feedback-title"),
  feedbackAnswer: $("feedback-answer"),
  feedbackExplanation: $("feedback-explanation"),
  feedbackText: $("feedback-text"),
  source: $("source"),
  sourceLink: $("source-link"),
  questionPoints: $("question-points"),
  actionBtn: $("action-btn"),
  resultTitle: $("result-title"),
  rankingList: $("ranking-list"),
  restartBtn: $("restart-btn")
};

function showScreen(name) {
  Object.entries(ui.screens).forEach(([key, el]) => {
    el.hidden = key !== name;
  });
}

function pluralPoints(points) {
  return `${points} ${points === 1 ? "ponto" : "pontos"}`;
}

function renderProgress(index, total) {
  ui.progressText.textContent = `Pergunta ${index + 1} de ${total}`;
  ui.progressBar.style.width = `${((index + 1) / total) * 100}%`;
  ui.progress.setAttribute("aria-valuemax", total);
  ui.progress.setAttribute("aria-valuenow", index + 1);
}

function renderQuestion(question, index, total) {
  renderProgress(index, total);
  ui.totalScore.textContent = state.totalScore;
  ui.category.textContent = question.category || "Tecnologia";
  ui.category.hidden = false;
  ui.questionText.textContent = question.question;
  ui.questionPoints.textContent = "–";
  ui.feedback.hidden = true;
  ui.feedback.className = "feedback";
  ui.actionBtn.textContent = "Confirmar resposta";
  ui.actionBtn.disabled = true;

  ui.options.replaceChildren();
  question.options.forEach((opt, position) => {
    const btn = document.createElement("button");
    btn.type = "button";
    btn.className = "option";
    btn.dataset.index = opt.originalIndex;
    btn.setAttribute("aria-pressed", "false");

    const label = document.createElement("span");
    label.className = "option-label";
    label.setAttribute("aria-hidden", "true");
    label.textContent = CONFIG.OPTION_LABELS[position] || position + 1;

    const text = document.createElement("span");
    text.className = "option-text";
    text.textContent = opt.text;

    btn.append(label, text);
    ui.options.appendChild(btn);
  });

  ui.questionText.focus({ preventScroll: true }); // leitor de tela anuncia a nova pergunta
}

function renderTimer(secondsLeft) {
  ui.timerValue.textContent = Math.ceil(secondsLeft);
  ui.timerPoints.textContent = calculatePoints(secondsLeft);
  ui.timerBar.style.width = `${(secondsLeft / CONFIG.SECONDS_PER_QUESTION) * 100}%`;
  ui.timer.classList.toggle("is-warning", secondsLeft > 0 && secondsLeft <= CONFIG.WARNING_SECONDS);
}

function renderSelection(originalIndex) {
  ui.options.querySelectorAll(".option").forEach((btn) => {
    const selected = Number(btn.dataset.index) === originalIndex;
    btn.classList.toggle("is-selected", selected);
    btn.setAttribute("aria-pressed", String(selected));
  });
  ui.actionBtn.disabled = false;
}

function renderSource(question) {
  const url = question.sourceUrl || question.source;
  if (!url) {
    ui.source.hidden = true;
    return;
  }
  let label = question.sourceName || url;
  if (!question.sourceName) {
    try {
      label = new URL(url).hostname.replace(/^www\./, "");
    } catch (err) {
      // URL inválida: mostra o texto original
    }
  }
  ui.sourceLink.href = url;
  ui.sourceLink.textContent = label;
  ui.source.hidden = false;
}

function renderAnswerResult(question, selectedIndex, status, points) {
  ui.options.querySelectorAll(".option").forEach((btn) => {
    const idx = Number(btn.dataset.index);
    btn.disabled = true;
    btn.classList.remove("is-selected");
    btn.setAttribute("aria-pressed", String(idx === selectedIndex));
    if (idx === question.correctAnswer) btn.classList.add("is-correct");
    else if (idx === selectedIndex) btn.classList.add("is-incorrect");
  });

  const correctText = question.options.find((o) => o.originalIndex === question.correctAnswer).text;
  const titles = {
    correct: `✓ Resposta correta! +${pluralPoints(points)}`,
    incorrect: `✗ Resposta incorreta. +${pluralPoints(points)} por tentar!`,
    timeout: "⏰ Tempo esgotado! 0 pontos"
  };
  const classes = { correct: "is-correct", incorrect: "is-incorrect", timeout: "is-timeout" };

  ui.feedbackTitle.textContent = titles[status];
  ui.feedbackAnswer.textContent = `A resposta certa é: ${correctText}.`;
  ui.feedbackAnswer.hidden = status === "correct";
  ui.feedbackText.textContent = question.explanation || "";
  ui.feedbackExplanation.hidden = !question.explanation;
  renderSource(question);
  ui.feedback.className = `feedback ${classes[status]}`;
  ui.feedback.hidden = false;

  ui.questionPoints.textContent = points;
  ui.totalScore.textContent = state.totalScore;

  const isLast = state.currentIndex === state.questions.length - 1;
  ui.actionBtn.textContent = isLast ? "Ver resultado" : "Próxima pergunta";
  ui.actionBtn.disabled = false;
  ui.actionBtn.focus({ preventScroll: true }); // as alternativas foram desabilitadas; mantém o foco no fluxo
}

function renderRanking(rows) {
  ui.rankingList.replaceChildren();
  rows.forEach((row) => {
    const li = document.createElement("li");
    if (row.gap) {
      li.className = "rank-gap";
      li.textContent = "...";
    } else {
      const pos = document.createElement("span");
      pos.className = "rank-pos";
      pos.textContent = `${String(row.position).padStart(2, "0")}.`;

      const name = document.createElement("span");
      name.className = "rank-name";
      name.textContent = row.name;
      if (row.isYou) {
        const you = document.createElement("span");
        you.className = "rank-you";
        you.textContent = "(você)";
        name.appendChild(you);
        li.classList.add("is-you");
      }

      const points = document.createElement("span");
      points.className = "rank-points";
      points.textContent = `${row.points} pts`;

      li.append(pos, name, points);
    }
    ui.rankingList.appendChild(li);
  });
}

function renderResult(summary) {
  $("result-message").textContent = getEndMessage(summary, state.playerName);
  $("result-score").textContent = state.totalScore;
  $("result-max").textContent = summary.maxScore;
  $("result-correct").textContent = summary.correct;
  $("result-wrong").textContent = summary.wrong;
  $("result-answered").textContent = summary.answered;
  $("result-timeouts").textContent = summary.timeouts;
}

/* =========================================================
 * Controlador do quiz
 * ========================================================= */
function currentQuestion() {
  return state.questions[state.currentIndex];
}

function loadQuestion() {
  const question = currentQuestion();
  state.status = "answering";
  state.selectedOption = null;
  renderQuestion(question, state.currentIndex, state.questions.length);
  timer.start(CONFIG.SECONDS_PER_QUESTION, renderTimer, handleTimeout);
}

function recordResult(question, selectedAnswer, status, points, secondsLeft) {
  state.totalScore += points;
  state.results.push({
    questionId: question.id,
    selectedAnswer, // índice na lista original de alternativas (ou null)
    status, // correct | incorrect | timeout
    points,
    timeSpent: Number((CONFIG.SECONDS_PER_QUESTION - secondsLeft).toFixed(2)),
    answeredAt: new Date().toISOString()
  });
}

// RQ06: a alternativa pode ser trocada quantas vezes o jogador quiser até confirmar.
function selectOption(originalIndex) {
  if (state.status !== "answering") return;
  state.selectedOption = originalIndex;
  renderSelection(originalIndex);
}

function confirmAnswer() {
  if (state.status !== "answering" || state.selectedOption === null) return;

  timer.stop();
  const secondsLeft = timer.remaining();
  const question = currentQuestion();
  const correct = isCorrect(question, state.selectedOption);
  const points = correct ? calculatePoints(secondsLeft) : CONFIG.WRONG_ANSWER_POINTS;
  const status = correct ? "correct" : "incorrect";

  state.status = "answered";
  recordResult(question, state.selectedOption, status, points, secondsLeft);
  renderAnswerResult(question, state.selectedOption, status, points);
}

function handleTimeout() {
  if (state.status !== "answering") return;

  const question = currentQuestion();
  state.status = "timeout";
  recordResult(question, null, "timeout", 0, 0);
  renderAnswerResult(question, null, "timeout", 0);
}

function nextQuestion() {
  if (state.currentIndex < state.questions.length - 1) {
    state.currentIndex++;
    loadQuestion();
  } else {
    finishQuiz();
  }
}

function finishQuiz() {
  timer.stop();
  state.status = "idle";
  renderResult(getSummary());
  showRanking();
  showScreen("result");
  ui.resultTitle.focus({ preventScroll: true });
  saveMatch(buildMatchPayload()).catch((err) => console.warn("[quiz] Não foi possível salvar a partida:", err));
}

function showRanking() {
  const entry = { name: state.playerName, points: state.totalScore };
  let all;
  try {
    all = ranking.add(entry);
  } catch (err) {
    console.error("[quiz] Falha ao salvar no ranking:", err);
    all = [entry]; // mostra ao menos a pontuação desta partida
  }
  renderRanking(buildRankingView(all, all.length - 1));
}

function handleActionClick() {
  if (state.status === "answering") confirmAnswer();
  else if (state.status === "answered" || state.status === "timeout") nextQuestion();
}

function resetState() {
  state.currentIndex = 0;
  state.totalScore = 0;
  state.results = [];
  state.selectedOption = null;
  state.status = "idle";
  state.startedAt = new Date().toISOString();
}

async function startQuiz() {
  timer.stop();
  showScreen("loading");
  try {
    const raw = await loadQuestions(CONFIG.QUESTIONS_PER_GAME);
    if (!Array.isArray(raw) || raw.length === 0) throw new Error("Nenhuma pergunta disponível.");
    state.questions = prepareQuestions(raw);
    resetState();
    showScreen("quiz");
    loadQuestion();
  } catch (err) {
    console.error("[quiz] Erro ao iniciar:", err);
    ui.errorMessage.textContent = err.message || "Tente novamente em instantes.";
    showScreen("error");
  }
}

// RQ01: o jogador informa o nome antes de iniciar.
function updateStartButton() {
  const hasName = ui.playerName.value.trim() !== "";
  ui.startBtn.disabled = !hasName;
  ui.nameHint.hidden = hasName;
}

function handleStart() {
  const name = ui.playerName.value.trim();
  if (!name) return;
  state.playerName = name;
  startQuiz();
}

/* =========================================================
 * Eventos
 * ========================================================= */
ui.playerName.addEventListener("input", updateStartButton);
ui.playerName.addEventListener("keydown", (event) => {
  if (event.key === "Enter") handleStart();
});
ui.startBtn.addEventListener("click", handleStart);
ui.options.addEventListener("click", (event) => {
  const btn = event.target.closest(".option");
  if (btn && !btn.disabled) selectOption(Number(btn.dataset.index));
});
ui.actionBtn.addEventListener("click", handleActionClick);
ui.restartBtn.addEventListener("click", startQuiz);
ui.retryBtn.addEventListener("click", startQuiz);

// O quiz só começa quando o jogador informa o nome e clica em "Começar".
updateStartButton();
