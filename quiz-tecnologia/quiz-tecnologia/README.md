# DevClash

Quiz de tecnologia em HTML, CSS e JavaScript puro (sem frameworks), pensado para o GitHub Pages, com um backend opcional em Node.js + PostgreSQL.

## Como executar

**Só o front-end (perguntas locais):** abra `index.html` no navegador, ou rode `python -m http.server 8000` na pasta e acesse http://localhost:8000.

**Com backend e banco:** veja [backend/README.md](backend/README.md) e depois defina `API_BASE_URL` em `js/config.js`.

## Estrutura

```text
quiz-tecnologia/
├── index.html
├── css/
│   ├── style.css            # identidade visual do protótipo (tema ativo)
│   └── theme-terminal.css   # tema terminal anterior, guardado como backup
├── js/
│   ├── config.js            # URL da API
│   ├── questions.js         # perguntas locais + loadQuestions()
│   └── script.js            # lógica do quiz, ranking e interface
├── backend/                 # API Node.js + PostgreSQL
└── README.md
```

## Como o jogo funciona

- O jogador informa o nome e clica em "Começar" (RQ01).
- Uma pergunta por vez, com uma única alternativa correta (RQ02). A alternativa pode ser trocada à vontade até clicar em "Confirmar resposta" (RQ06).
- Cada pergunta tem 50 segundos. Acerto vale de 3 a 10 pontos conforme o tempo restante; resposta errada vale 1 ponto; tempo esgotado vale 0 (RQ03):

| Tempo restante | Pontos |
| --- | ---: |
| 50 a 40 s | 10 |
| < 40 a 35 s | 8 |
| < 35 a 25 s | 6 |
| < 25 a 15 s | 4 |
| < 15 a 1 s | 3 |

- Depois de responder, aparece a explicação da resposta com o link da fonte (RQ07).
- Ao final, a pontuação e o ranking da sessão são exibidos (RQ04) e o jogador pode jogar de novo (RQ05). O ranking guarda só `{ name, points }` no `sessionStorage`; a posição é calculada ao exibir.
- Por partida são sorteadas até `CONFIG.QUESTIONS_PER_GAME` perguntas (10). Com as 5 perguntas atuais, todas entram.

## Acessibilidade

Tudo é operável por teclado (Tab, Enter e Espaço), o foco fica visível e é movido a cada etapa, e acerto, erro, seleção e posição no ranking sempre aparecem também em texto ou símbolo, nunca só por cor.

## Adicionar perguntas

Local: inclua objetos em `LOCAL_QUESTIONS`, em `js/questions.js`, com `question`, `options`, `correctAnswer` (índice), `explanation`, `sourceName` e `sourceUrl`. Com backend: insira no banco (veja `backend/seed.sql`).
