"use strict";

/*
 * Claudinho Robô, o mascote do DevClash.
 *
 * Fica no canto da tela (veja css/mascot.css), pisca de tempos em tempos, "fala" num balão
 * e reage ao que acontece no quiz. Esta é a única parte que mexe no mascote: script.js só
 * chama os cinco métodos devolvidos no fim do arquivo.
 *
 * O desenho (SVG) está em index.html. Aqui trocamos os atributos do <svg id="claudinho">:
 *   data-eyes   open | happy | sad | wow          (data-blink acende o olho piscando)
 *   data-mouth  smile | s | m | l | big-smile | sad | wow
 *   data-arm    down | up (acenando)
 * Os frames seguem a folha de sprites: 1 parado, 2-4 fala, 5 piscando, 6 feliz, 7 triste, 8 surpreso.
 *
 * O desenho e o balão são decorativos (aria-hidden): quem usa leitor de tela continua recebendo
 * o resultado de cada pergunta pela área de feedback do quiz, sem anúncio duplicado.
 *
 * A voz (js/voice.js) é opcional: sem ela, ou com o botão de som desligado, ele só mexe a boca e
 * mostra o balão. O botão de som (#claudinho-voice) também é ligado aqui.
 */
const claudinho = (() => {
  const root = document.getElementById("claudinho");
  const bubble = document.getElementById("claudinho-bubble");

  // Sem o desenho na página, o quiz segue normal e as chamadas viram "não faz nada".
  if (!root || !bubble) {
    const noop = () => {};
    return { onScreen: noop, onQuestion: noop, onTimeWarning: noop, onAnswer: noop, onResult: noop };
  }

  const FACES = {
    idle: { eyes: "open", mouth: "smile" },
    happy: { eyes: "happy", mouth: "big-smile" },
    sad: { eyes: "sad", mouth: "sad" },
    wow: { eyes: "wow", mouth: "wow" }
  };
  const TALK_MOUTHS = ["s", "m", "l"];
  const GESTURES = ["is-jump", "is-pop", "is-shake"];

  // Falas. Listas sorteiam uma por vez (sem repetir a anterior).
  const MESSAGES = {
    greeting: "Olá! Eu sou o Claudinho! Pronto pro desafio de SQL?",
    welcomeBack: ["De volta? Bora subir no ranking!", "Mais uma rodada? Eu topo!"],
    slowLoad: "Só mais um instante, estou buscando as perguntas.",
    loadError: "Ops! Não consegui buscar as perguntas.",
    lastQuestion: "Última pergunta! Capricha.",
    hardQuestion: ["Essa é difícil! Respira e pensa.", "Pergunta difícil. Calma, você consegue!"],
    bonus: "Pergunta bônus! Olho aberto.",
    timeWarning: ["O tempo está acabando!", "Corre! Falta pouco tempo."],
    correctFast: ["Rápido e certeiro!", "Nem precisou de EXPLAIN!"],
    correct: ["Isso aí! Mandou bem.", "SELECT * FROM acertos;", "COMMIT! Resposta certa."],
    correctSlow: ["Na hora certa! Acertou.", "Devagar e sempre: acertou!"],
    streak3: "Três acertos seguidos!",
    streak5: "Cinco seguidas! Que sequência!",
    incorrect: ["Quase! Confira a explicação.", "ROLLBACK! Mas agora você sabe.", "Errar faz parte. Bora pra próxima!"],
    timeout: ["O tempo acabou!", "Ih, estourou o tempo!"],
    resultGreat: "Mandou muito bem! Bora bater esse recorde?",
    resultGood: "Bom trabalho! Dá pra subir no ranking.",
    resultTry: "Cada partida ensina algo. Bora de novo?",
    voiceOn: "Voz ligada! Agora eu falo com você.",
    voiceOff: "Voz desligada. Continuo por aqui!"
  };

  const lastPicked = {};
  function pick(key) {
    const value = MESSAGES[key];
    if (!Array.isArray(value)) return value;
    const options = value.length > 1 ? value.filter((text) => text !== lastPicked[key]) : value;
    lastPicked[key] = options[Math.floor(Math.random() * options.length)];
    return lastPicked[key];
  }

  // Voz opcional. Sem voice.js carregado, vira um objeto que não fala.
  const voice = typeof claudinhoVoice !== "undefined"
    ? claudinhoVoice
    : { supported: false, speak: () => false, cancel() {}, setEnabled() {}, isEnabled: () => false };

  const reduceMotion = () => window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  /* ---------- Rosto ---------- */
  let mood = "idle";
  let talkTimer = null;
  let talkEnd = null;
  let lastMouth = null;

  function stopTalking() {
    clearInterval(talkTimer);
    clearTimeout(talkEnd);
    talkTimer = talkEnd = null;
    root.dataset.mouth = FACES[mood].mouth;
  }

  function setMood(next) {
    mood = next;
    root.dataset.eyes = FACES[mood].eyes;
    stopTalking();
  }

  // Abre e fecha a boca (frames 2 a 4) por um tempo, depois volta à boca do humor atual.
  function startTalking(ms) {
    stopTalking();
    if (reduceMotion()) return;
    const step = () => {
      const options = TALK_MOUTHS.filter((m) => m !== lastMouth);
      lastMouth = options[Math.floor(Math.random() * options.length)];
      root.dataset.mouth = lastMouth;
    };
    step();
    talkTimer = setInterval(step, 120);
    talkEnd = setTimeout(stopTalking, ms);
  }

  // Pisca de vez em quando, e às vezes duas vezes seguidas. Só pisca com os olhos abertos.
  function blinkOnce(again) {
    root.dataset.blink = "";
    setTimeout(() => {
      delete root.dataset.blink;
      if (again) setTimeout(() => blinkOnce(false), 140);
    }, 130);
  }

  function scheduleBlink() {
    setTimeout(() => {
      if (!reduceMotion() && root.dataset.eyes === "open") blinkOnce(Math.random() < 0.25);
      scheduleBlink();
    }, 2200 + Math.random() * 3600);
  }

  /* ---------- Balão, braço e pulinhos ---------- */
  let bubbleTimer = null;
  let armTimer = null;

  function hideBubble() {
    clearTimeout(bubbleTimer);
    bubble.classList.remove("is-visible");
  }

  function say(text) {
    bubble.textContent = text; // textContent: o nome do jogador nunca vira HTML
    bubble.classList.add("is-visible");
    // Sem voz (ou se o navegador a recusar), a boca e o balão seguem por tempo fixo.
    clearTimeout(bubbleTimer);
    bubbleTimer = setTimeout(hideBubble, Math.min(6500, 2800 + text.length * 45));
    startTalking(Math.min(3500, 500 + text.length * 60));
    // Com voz, a boca e o balão acompanham a fala de verdade (com um limite de segurança).
    voice.speak(text, {
      onStart() {
        startTalking(15000);
        clearTimeout(bubbleTimer);
        bubbleTimer = setTimeout(hideBubble, 15000);
      },
      onEnd() {
        stopTalking();
        clearTimeout(bubbleTimer);
        bubbleTimer = setTimeout(hideBubble, 1500);
      }
    });
  }

  function lowerArm() {
    clearTimeout(armTimer);
    root.dataset.arm = "down";
  }

  function wave(ms) {
    clearTimeout(armTimer);
    root.dataset.arm = "up";
    armTimer = setTimeout(lowerArm, ms);
  }

  function play(gesture) {
    root.classList.remove(...GESTURES);
    root.getBoundingClientRect(); // força o navegador a reiniciar a animação
    root.classList.add(gesture);
  }
  root.addEventListener("animationend", (event) => {
    if (event.target.classList.contains("cl-react")) root.classList.remove(...GESTURES);
  });

  // Junta humor + fala + gesto. Cada reação substitui a anterior.
  function react({ mood: next, text, gesture, waveMs }) {
    voice.cancel(); // a reação nova interrompe a fala anterior
    setMood(next);
    if (waveMs) wave(waveMs);
    else lowerArm();
    if (gesture) play(gesture);
    if (text) say(text);
    else hideBubble();
  }

  /* ---------- Eventos do quiz (chamados por script.js) ---------- */
  let player = "";
  let greeted = false;
  let streak = 0; // acertos seguidos
  let warned = false; // já avisou que o tempo está acabando nesta pergunta
  let loadingTimer = null;

  function onScreen(name, playerName) {
    clearTimeout(loadingTimer);
    if (name === "start") {
      streak = 0;
      react({ mood: "idle", text: greeted ? pick("welcomeBack") : pick("greeting"), waveMs: 2200 });
      greeted = true;
    } else if (name === "loading") {
      player = playerName || "";
      streak = 0;
      react({ mood: "idle" });
      // Se carregar rápido, nem aparece. Se demorar (ex.: servidor acordando), o Claudinho avisa.
      loadingTimer = setTimeout(() => react({ mood: "idle", text: pick("slowLoad") }), 1500);
    } else if (name === "error") {
      react({ mood: "sad", text: pick("loadError"), gesture: "is-shake" });
    }
  }

  function onQuestion(question, index, total) {
    clearTimeout(loadingTimer);
    warned = false;
    let next = "idle";
    let text = null;
    if (index === 0) {
      text = `Vamos lá${player ? ", " + player : ""}! Boa sorte.`;
    } else if (index === total - 1) {
      text = pick("lastQuestion");
    } else if (question.difficulty === "dificil") {
      next = "wow";
      text = pick("hardQuestion");
    } else if (question.bonus) {
      next = "happy";
      text = pick("bonus");
    }
    react({ mood: next, text, waveMs: index === 0 ? 1600 : 0 });
  }

  function onTimeWarning() {
    if (warned) return;
    warned = true;
    react({ mood: "wow", text: pick("timeWarning"), gesture: "is-pop" });
  }

  function onAnswer(status, points) {
    if (status === "correct") {
      streak++;
      let key = points >= 8 ? "correctFast" : points <= 4 ? "correctSlow" : "correct";
      if (streak === 3) key = "streak3";
      else if (streak === 5) key = "streak5";
      react({ mood: "happy", text: pick(key), gesture: "is-jump", waveMs: 1600 });
    } else if (status === "incorrect") {
      streak = 0;
      react({ mood: "sad", text: pick("incorrect"), gesture: "is-shake" });
    } else {
      streak = 0;
      react({ mood: "wow", text: pick("timeout"), gesture: "is-pop" });
    }
  }

  function onResult(summary) {
    const ratio = summary.totalQuestions ? summary.correct / summary.totalQuestions : 0;
    if (ratio >= 0.8) react({ mood: "happy", text: pick("resultGreat"), gesture: "is-jump", waveMs: 2400 });
    else if (ratio >= 0.5) react({ mood: "happy", text: pick("resultGood"), gesture: "is-jump" });
    else react({ mood: "idle", text: pick("resultTry") });
  }

  /* ---------- Botão de som ---------- */
  const voiceBtn = document.getElementById("claudinho-voice");

  function renderVoiceButton() {
    const on = voice.isEnabled();
    voiceBtn.setAttribute("aria-pressed", String(on));
    voiceBtn.title = on ? "Desligar a voz do Claudinho" : "Ligar a voz do Claudinho";
    voiceBtn.classList.toggle("is-off", !on);
  }

  if (voiceBtn) {
    if (!voice.supported) {
      voiceBtn.hidden = true; // navegador sem síntese de voz
    } else {
      renderVoiceButton();
      voiceBtn.addEventListener("click", () => {
        voice.setEnabled(!voice.isEnabled());
        renderVoiceButton();
        if (voice.isEnabled()) react({ mood: "happy", text: pick("voiceOn"), gesture: "is-pop" });
        else react({ mood: "idle", text: pick("voiceOff") });
      });
    }
  }

  /* ---------- Acompanha o mouse quando ele se aproxima (somente desktop) ---------- */
  // A distância é medida a partir da posição fixa do mascote, para evitar
  // oscilações enquanto o SVG se desloca. Não altera as reações nem os cliques.
  const wrapper = document.getElementById("claudinho-wrap");
  if (wrapper && window.matchMedia("(hover: hover) and (pointer: fine)").matches) {
    const FOLLOW_RADIUS = 350; // distância máxima para começar a acompanhar
    const MAX_SHIFT = 55; // deslocamento máximo, em pixels

    function resetFollow() {
      root.style.setProperty("--cl-follow-x", "0px");
      root.style.setProperty("--cl-follow-y", "0px");
    }

    document.addEventListener("pointermove", (event) => {
      if (reduceMotion() || event.pointerType === "touch") {
        resetFollow();
        return;
      }

      // O wrapper permanece imóvel, mesmo enquanto o desenho se desloca.
      const rect = wrapper.getBoundingClientRect();
      const dx = event.clientX - (rect.left + rect.width / 2);
      const dy = event.clientY - (rect.top + rect.height / 2);
      const distance = Math.hypot(dx, dy);

      if (distance >= FOLLOW_RADIUS) {
        resetFollow();
        return;
      }

      // Reduz o movimento gradualmente perto da borda do raio de ativação.
      const fade = Math.min(1, (FOLLOW_RADIUS - distance) / 90);
      const shiftX = Math.max(-MAX_SHIFT, Math.min(MAX_SHIFT, dx * 0.32)) * fade;
      const shiftY = Math.max(-MAX_SHIFT, Math.min(MAX_SHIFT, dy * 0.32)) * fade;
      root.style.setProperty("--cl-follow-x", `${shiftX.toFixed(1)}px`);
      root.style.setProperty("--cl-follow-y", `${shiftY.toFixed(1)}px`);
    }, { passive: true });

    document.addEventListener("pointerleave", resetFollow);
    window.addEventListener("blur", resetFollow);
  }

  setMood("idle");
  scheduleBlink();

  return { onScreen, onQuestion, onTimeWarning, onAnswer, onResult };
})();

