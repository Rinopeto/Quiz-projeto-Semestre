"use strict";

/*
 * Voz do Claudinho.
 *
 * As amostras foram extraídas do áudio fornecido para o projeto e ficam em audio/voz_claudinho/.
 * São sons robóticos não verbais: as frases continuam legíveis no balão do mascote.
 *
 * A interface é a mesma usada por js/mascot.js (speak, cancel, setEnabled,
 * isEnabled e supported), sem alterações nos eventos ou na lógica do quiz.
 * Por segurança, o navegador pode bloquear a saudação sonora antes do primeiro clique.
 */
const claudinhoVoice = (() => {
  const STORAGE_KEY = "devclash:voice";
  const supported = typeof window.Audio === "function"
    && Boolean(new window.Audio().canPlayType("audio/mpeg"));

  // Quantidade de trechos separados por duração. Arquivos locais, sem serviço externo.
  const CLIP_COUNTS = { short: 18, medium: 35, long: 16 };
  const lastClip = { short: 0, medium: 0, long: 0 };

  let enabled = true;
  try {
    enabled = localStorage.getItem(STORAGE_KEY) !== "off";
  } catch (err) {
    // Sem localStorage, a preferência vale somente nesta visita.
  }

  let currentAudio = null;
  let currentId = 0; // ignora callbacks de falas anteriores que foram interrompidas

  function chooseClip(text) {
    // Frases curtas usam sons curtos; frases longas usam balbucios mais compridos.
    const type = text.length <= 15 ? "short" : text.length <= 35 ? "medium" : "long";
    const total = CLIP_COUNTS[type];
    let number = 1 + Math.floor(Math.random() * total);
    // Evita repetir a mesma amostra em duas falas seguidas da mesma duração.
    if (total > 1 && number === lastClip[type]) number = (number % total) + 1;
    lastClip[type] = number;
    return `audio/voz_claudinho/${type}-${String(number).padStart(2, "0")}.mp3`;  }

  function cancel() {
    currentId++;
    if (!currentAudio) return;
    // Cancelar nunca deve disparar o callback onEnd da fala interrompida.
    currentAudio.onplaying = null;
    currentAudio.onended = null;
    currentAudio.onerror = null;
    currentAudio.pause();
    currentAudio = null;
  }

  /*
   * Mantém o contrato usado pelo mascote: onStart, onEnd e onError.
   * O texto permanece no balão;
   */
  function speak(text, handlers = {}) {
    cancel();
    if (!supported || !enabled) return false;

    const id = ++currentId;
    const audio = new window.Audio(chooseClip(String(text)));
    currentAudio = audio;
    audio.volume = 0.75;
    audio.preload = "auto";

    let errorHandled = false;
    const onError = () => {
      if (id !== currentId || errorHandled) return;
      errorHandled = true;
      currentAudio = null;
      if (handlers.onError) handlers.onError();
    };

    audio.onplaying = () => {
      if (id === currentId && handlers.onStart) handlers.onStart();
    };
    audio.onended = () => {
      if (id !== currentId) return;
      currentAudio = null;
      if (handlers.onEnd) handlers.onEnd();
    };
    audio.onerror = onError;

    try {
      const playback = audio.play();
      if (playback && typeof playback.catch === "function") playback.catch(onError);
    } catch (err) {
      onError();
      return false;
    }
    return true;
  }

  function setEnabled(value) {
    enabled = Boolean(value);
    if (!enabled) cancel();
    try {
      localStorage.setItem(STORAGE_KEY, enabled ? "on" : "off");
    } catch (err) {
      // Sem localStorage, a preferência vale somente nesta visita.
    }
  }

  return { supported, speak, cancel, setEnabled, isEnabled: () => enabled };
})();
