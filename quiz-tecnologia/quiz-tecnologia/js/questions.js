"use strict";

/*
 * Perguntas locais (usadas quando API_BASE_URL está vazio ou a API não responde).
 * correctAnswer é o índice da alternativa correta dentro de "options".
 * Esta estrutura é a mesma devolvida pela API (GET /api/questions).
 */
const LOCAL_QUESTIONS = [
  {
    id: 1,
    category: "História da tecnologia",
    question: "Qual máquina é amplamente considerada o primeiro computador digital eletrônico de propósito geral e em qual década ela foi operacionalizada?",
    options: ["ENIAC", "Colossus", "Z3", "ABC"],
    correctAnswer: 0,
    explanation: "O ENIAC foi construído durante a Segunda Guerra Mundial e apresentado ao público em fevereiro de 1946, na Universidade da Pensilvânia, ou seja, entrou em operação na década de 1940. Projetado por John Mauchly e J. Presper Eckert, é considerado o primeiro computador digital eletrônico de propósito geral.",
    sourceName: "Penn Today",
    sourceUrl: "https://penntoday.upenn.edu/news/worlds-first-general-purpose-computer-turns-75"
  },
  {
    id: 2,
    category: "História da tecnologia",
    question: "Quem inventou a World Wide Web (WWW) no laboratório do CERN em 1989?",
    options: ["Tim Berners-Lee", "Linus Torvalds", "Marc Andreessen", "Richard Stallman"],
    correctAnswer: 0,
    explanation: "Tim Berners-Lee escreveu a primeira proposta da Web em março de 1989, quando trabalhava no CERN, e no fim de 1990 já tinha o primeiro servidor e navegador funcionando. Linus Torvalds criou o Linux, Marc Andreessen foi um dos criadores do navegador Mosaic e Richard Stallman fundou o projeto GNU.",
    sourceName: "CERN",
    sourceUrl: "https://home.cern/science/computing/the-birth-of-the-web/short-history-web/"
  },
  {
    id: 3,
    category: "História da tecnologia",
    question: "Qual opção Tim Berners-Lee não criou?",
    options: ["CSS", "HTTP", "HTML", "URL"],
    correctAnswer: 0,
    explanation: "Tim Berners-Lee criou o HTML, o protocolo HTTP e o sistema de endereços (URL). O CSS veio depois: foi proposto em 1994 por Håkon Wium Lie, que trabalhava com ele no CERN, para separar o conteúdo da página da sua aparência.",
    sourceName: "InfoEscola",
    sourceUrl: "https://www.infoescola.com/informatica/cascading-style-sheets-css/"
  },
  {
    id: 4,
    category: "História da tecnologia",
    question: "O termo \"bug\" na computação se popularizou quando Grace Hopper documentou uma lagartixa real presa em um relé do computador Harvard Mark II. Essa afirmação é verdadeira ou falsa?",
    options: ["Falsa", "Verdadeira"],
    correctAnswer: 0,
    explanation: "Falsa. O inseto encontrado em 9 de setembro de 1947 no Harvard Mark II era uma mariposa, e não uma lagartixa. Ela foi colada no diário de operações da equipe. O termo \"bug\" já era usado para falhas técnicas antes disso; o episódio ficou famoso e Grace Hopper ajudou a divulgar a história.",
    sourceName: "Educa Mais Brasil",
    sourceUrl: "https://www.educamaisbrasil.com.br/educacao/dicas/o-que-e-bug-qual-a-origem-da-expressao"
  },
  {
    id: 5,
    category: "História da tecnologia",
    question: "Qual o primeiro vírus de computador da história geral da tecnologia?",
    options: ["Creeper", "Brain", "ILOVEYOU", "WannaCry"],
    correctAnswer: 0,
    explanation: "O Creeper foi criado em 1971 por Bob Thomas, como um experimento: um programa que passava de computador em computador na ARPANET exibindo uma mensagem provocativa. Depois surgiu o Reaper, feito para removê-lo. O Brain, de 1986, é considerado o primeiro vírus para PCs.",
    sourceName: "CyberSec Brasil",
    sourceUrl: "https://www.cybersecbrazil.com.br/post/o-creeper-o-primeiro-v%C3%ADrus-de-computador-da-hist%C3%B3ria"
  }
];

function cloneLocalQuestions() {
  return LOCAL_QUESTIONS.map((q) => ({ ...q, options: [...q.options] }));
}

function isValidQuestion(q) {
  return (
    q &&
    typeof q.question === "string" &&
    Array.isArray(q.options) &&
    q.options.length >= 2 &&
    Number.isInteger(q.correctAnswer) &&
    q.correctAnswer >= 0 &&
    q.correctAnswer < q.options.length
  );
}

/*
 * Camada de acesso aos dados.
 * Com API_BASE_URL configurada, busca as perguntas no backend (GET /api/questions).
 * Se a API estiver fora do ar ou devolver dados inválidos, usa as perguntas locais,
 * assim o quiz continua funcionando (por exemplo, no GitHub Pages sem backend).
 */
async function loadQuestions(limit) {
  if (!API_BASE_URL) return cloneLocalQuestions();

  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), 8000);
  try {
    const query = limit ? `?limit=${encodeURIComponent(limit)}` : "";
    const response = await fetch(`${API_BASE_URL}/api/questions${query}`, { signal: controller.signal });
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    const data = await response.json();
    if (!Array.isArray(data) || data.length === 0 || !data.every(isValidQuestion)) {
      throw new Error("Resposta inválida da API");
    }
    return data;
  } catch (err) {
    console.warn("[quiz] API indisponível, usando perguntas locais:", err);
    return cloneLocalQuestions();
  } finally {
    clearTimeout(timeoutId);
  }
}
