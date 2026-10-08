# DevClash

Quiz de SQL e bancos de dados (com algumas perguntas bônus de história da tecnologia) em HTML, CSS e JavaScript puro (sem frameworks), pensado para o GitHub Pages, com um backend opcional em Node.js + PostgreSQL. As cores seguem o tema claro do pgAdmin e a fonte é a JetBrains Mono, carregada do Google Fonts (sem internet, o navegador usa uma fonte monoespaçada do sistema).

## Como executar

**Só o front-end (perguntas locais):** abra `index.html` no navegador, ou rode `python -m http.server 8000` na pasta e acesse http://localhost:8000.

**Com backend e banco na nuvem:** veja [DEPLOY_NUVEM.md](DEPLOY_NUVEM.md) (local: [backend/README.md](backend/README.md)) e depois defina `API_BASE_URL` em `js/config.js`.

## Estrutura

```text
devclash/
├── index.html
├── css/
│   ├── style.css            # tema atual (paleta do pgAdmin)
│   └── theme-terminal.css   # tema terminal antigo, guardado como backup
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
- Cada pergunta mostra a dificuldade, sempre visível: **verde = fácil, laranja = médio, vermelho = difícil**. A cor vem acompanhada do texto e de pontinhos (●○○, ●●○, ●●●). Na partida, as perguntas vão do fácil ao difícil (`CONFIG.SORT_BY_DIFFICULTY`).
- Cada pergunta tem 50 segundos. Acerto vale de 3 a 10 pontos conforme o tempo restante; resposta errada vale 1 ponto; tempo esgotado vale 0 (RQ03):

| Tempo restante | Pontos |
| --- | ---: |
| 50 a 40 s | 10 |
| < 40 a 35 s | 8 |
| < 35 a 25 s | 6 |
| < 25 a 15 s | 4 |
| < 15 a 1 s | 3 |

- Depois de responder, aparece a explicação com o link da **fonte** de onde a pergunta veio (RQ07).
- Ao final, a pontuação e o ranking são exibidos (RQ04): com a API configurada é o **ranking geral do banco na nuvem** (pontos desc, desempate pelo menor tempo total, linha do jogador destacada); sem API, ou se ela falhar, é o ranking da sessão e o jogador pode jogar de novo (RQ05). O ranking guarda só `{ name, points }` no `sessionStorage`; a posição é calculada ao exibir.
- O banco de perguntas tem 45 perguntas (30 de SQL e bancos de dados, 10 de aquecimento e 5 bônus de história da tecnologia). Por partida são sorteadas até `CONFIG.QUESTIONS_PER_GAME` perguntas (10).
- As perguntas bônus (`bonus: true`) aparecem com o selo "★ Bônus". Elas valem os mesmos pontos das demais.

## Acessibilidade

Acessibilidade

Leitura em voz alta (baixa visão): no topo da página, o botão "Leitura em voz alta" liga a leitura automática de cada pergunta (com a dificuldade e as alternativas), da alternativa selecionada, da resposta com a explicação e a fonte, e do resultado final. "Ler novamente" repete a tela atual (e vira "Parar leitura" enquanto fala), a tecla Esc interrompe e a velocidade pode ser lenta, normal ou rápida. A preferência fica salva no navegador. Usa a voz em português do próprio navegador (Web Speech API), sem biblioteca e sem internet; a qualidade da voz depende do navegador e do sistema. Quem já usa um leitor de tela (NVDA, VoiceOver) pode deixar essa opção desligada para não ouvir duas vozes.

Tudo é operável por teclado (Tab, Enter e Espaço), o foco fica visível e é movido a cada etapa, e acerto, erro, seleção, dificuldade e posição no ranking sempre aparecem também em texto ou símbolo, nunca só por cor.
## Adicionar perguntas

Local: inclua objetos em `LOCAL_QUESTIONS`, em `js/questions.js`, com `question`, `options`, `correctAnswer` (índice), `difficulty` (`facil`, `medio` ou `dificil`), `bonus` (opcional, `true` nas bônus), `category`, `explanation`, `sourceName` e `sourceUrl`. Trechos entre crases viram código. Com backend: edite `backend/seed.sql` e rode `npm run db:init`.
