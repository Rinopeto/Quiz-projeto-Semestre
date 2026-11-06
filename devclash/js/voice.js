"use strict";

/*
 * Voz do Claudinho usando o leitor de texto nativo do navegador (Web Speech API).
 * Preserva a interface esperada por mascot.js: speak, cancel, setEnabled,
 * isEnabled e supported. Nenhum arquivo de áudio externo é necessário.
 */
const claudinhoVoice = (() => {
  const STORAGE_KEY = "devclash:voice";
  const supported = "speechSynthesis" in window && "SpeechSynthesisUtterance" in window;

  let enabled = true;
  try {
    enabled = localStorage.getItem(STORAGE_KEY) !== "off";
  } catch (err) {
    // Sem localStorage, a preferência vale somente nesta visita.
  }

  let currentId = 0;
  let currentUtterance = null;
  function chooseVoice() {
    const voices = window.speechSynthesis.getVoices();
    return voices.find((voice) => voice.lang.toLowerCase() === "pt-br")
      || voices.find((voice) => voice.lang.toLowerCase().startsWith("pt"))
      || null;
  }

  function cancel() {
    currentId++;
    if (!supported) return;
    if (currentUtterance) {
      currentUtterance.onstart = null;
      currentUtterance.onend = null;
      currentUtterance.onerror = null;
      currentUtterance = null;
    }
    window.speechSynthesis.cancel();
  }

  function speak(text, handlers = {}) {
    cancel();
    if (!supported || !enabled || !String(text).trim()) return false;

    const id = ++currentId;
    const utterance = new SpeechSynthesisUtterance(String(text));
    utterance.lang = "pt-BR";
    utterance.rate = 1;
    utterance.pitch = 1;
    utterance.volume = 1.0;
    const chosenVoice = chooseVoice();
    if (chosenVoice) utterance.voice = chosenVoice;
    currentUtterance = utterance;

    utterance.onstart = () => {
      if (id === currentId && handlers.onStart) handlers.onStart();
    };
    utterance.onend = () => {
      if (id !== currentId) return;
      currentUtterance = null;
      if (handlers.onEnd) handlers.onEnd();
    };
    utterance.onerror = (event) => {
      if (id !== currentId) return;
      currentUtterance = null;
      if (handlers.onError) handlers.onError(event);
    };

    try {
      window.speechSynthesis.speak(utterance);
    } catch (err) {
      currentUtterance = null;
      if (handlers.onError) handlers.onError(err);
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
