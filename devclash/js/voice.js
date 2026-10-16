"use strict";

/*
 * Voz do Claudinho.
 *
 * Usa a síntese de voz do próprio navegador (Web Speech API), em português do Brasil, com tom
 * agudo e um "bipe" curto de robô antes de cada fala. Não há arquivos de áudio nem biblioteca.
 *
 * Limites a conhecer:
 *  - A voz depende do navegador e do sistema (Edge e Chrome no Windows costumam ter boas vozes
 *    pt-BR; algumas vozes ignoram o tom). Ajuste SETTINGS e PREFERRED abaixo para testar outras.
 *  - Os navegadores só liberam o som depois do primeiro clique na página. Antes disso (a
 *    saudação do início) o Claudinho fala só no balão.
 *  - Quem decide quando falar é js/mascot.js; este arquivo só fala e cancela.
 */
const claudinhoVoice = (() => {
  const synth = window.speechSynthesis;
  const supported = Boolean(synth) && typeof window.SpeechSynthesisUtterance !== "undefined";
  const STORAGE_KEY = "devclash:voice"; // "off" quando o jogador desliga

  // Ajustes da voz: tom vai de 0 a 2 (1 = normal), velocidade de 0.1 a 10 (1 = normal).
  const SETTINGS = { lang: "pt-BR", pitch: 1.6, rate: 1.05, volume: 1 };
  // Vozes femininas conhecidas de pt-BR, em ordem de preferência. Sem nenhuma delas, usa a primeira pt-BR.
  const PREFERRED = /francisca|maria|luciana|thalita|vit[oó]ria|google portugu[eê]s do brasil/i;

  // Como ler no ar o que aparece escrito no balão (símbolos e termos de SQL).
  const SPOKEN = [
    [/\*/g, " estrela "],
    [/;/g, ""],
    [/\bCOMMIT\b/gi, "comite"],
    [/\bROLLBACK\b/gi, "rôl béque"],
    [/\bEXPLAIN\b/gi, "ex plêin"]
  ];

  let enabled = true;
  try {
    enabled = localStorage.getItem(STORAGE_KEY) !== "off";
  } catch (err) {
    // sem localStorage: a voz fica ligada nesta visita
  }

  let voice = null;
  let audioCtx = null;
  let currentId = 0; // identifica a fala atual; callbacks de falas canceladas são ignorados

  function chooseVoice() {
    const portuguese = synth.getVoices().filter((v) => /^pt([-_]|$)/i.test(v.lang));
    const brazilian = portuguese.filter((v) => /^pt[-_]br/i.test(v.lang));
    const pool = brazilian.length ? brazilian : portuguese;
    voice = pool.find((v) => PREFERRED.test(v.name)) || pool[0] || null;
  }

  if (supported) {
    chooseVoice();
    // Muitos navegadores só carregam a lista de vozes depois de iniciar.
    synth.addEventListener("voiceschanged", chooseVoice);
  }

  function toSpoken(text) {
    return SPOKEN.reduce((result, [pattern, replacement]) => result.replace(pattern, replacement), text);
  }

  // Bipe curto e agudo, no estilo "robô ligando". Falha em silêncio se o navegador bloquear o áudio.
  function chirp() {
    try {
      audioCtx = audioCtx || new (window.AudioContext || window.webkitAudioContext)();
      if (audioCtx.state === "suspended") audioCtx.resume();
      const t = audioCtx.currentTime;
      const osc = audioCtx.createOscillator();
      const gain = audioCtx.createGain();
      osc.type = "square";
      osc.frequency.setValueAtTime(520, t);
      osc.frequency.exponentialRampToValueAtTime(1040, t + 0.09);
      gain.gain.setValueAtTime(0.03, t);
      gain.gain.exponentialRampToValueAtTime(0.0001, t + 0.12);
      osc.connect(gain).connect(audioCtx.destination);
      osc.start(t);
      osc.stop(t + 0.13);
    } catch (err) {
      // sem áudio: segue só com a fala
    }
  }

  function cancel() {
    currentId++;
    if (supported) synth.cancel();
  }

  /*
   * Fala o texto. handlers: onStart (a voz começou), onEnd (terminou normalmente) e
   * onError (o navegador recusou, por exemplo antes do primeiro clique).
   * Devolve false se a voz está desligada ou sem suporte.
   */
  function speak(text, handlers = {}) {
    cancel();
    if (!supported || !enabled) return false;
    const id = ++currentId;
    const utterance = new window.SpeechSynthesisUtterance(toSpoken(text));
    utterance.lang = SETTINGS.lang;
    utterance.pitch = SETTINGS.pitch;
    utterance.rate = SETTINGS.rate;
    utterance.volume = SETTINGS.volume;
    if (voice) utterance.voice = voice;
    utterance.onstart = () => {
      if (id === currentId && handlers.onStart) handlers.onStart();
    };
    utterance.onend = () => {
      if (id === currentId && handlers.onEnd) handlers.onEnd();
    };
    utterance.onerror = () => {
      if (id === currentId && handlers.onError) handlers.onError();
    };
    chirp();
    synth.speak(utterance);
    return true;
  }

  function setEnabled(value) {
    enabled = Boolean(value);
    if (!enabled) cancel();
    try {
      localStorage.setItem(STORAGE_KEY, enabled ? "on" : "off");
    } catch (err) {
      // a escolha só vale até fechar a página
    }
  }

  return { supported, speak, cancel, setEnabled, isEnabled: () => enabled };
})();
