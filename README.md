# DevClash

Quiz de SQL e bancos de dados (com algumas perguntas bônus de história da tecnologia) em HTML, CSS e JavaScript puro (sem frameworks), pensado para o GitHub Pages, com um backend opcional em Node.js + PostgreSQL. As cores seguem o tema claro do pgAdmin e a fonte é a JetBrains Mono, carregada do Google Fonts (sem internet, o navegador usa uma fonte monoespaçada do sistema).

## Como executar

**Só o front-end (perguntas locais):** abra `index.html` no navegador, ou rode `python -m http.server 8000` na pasta e acesse http://localhost:8000.

**Com backend e banco:** veja [backend/README.md](backend/README.md) e depois defina `API_BASE_URL` em `js/config.js`.

## Estrutura

```text
devclash/
├── index.html
├── css/
│   ├── style.css            # tema atual (paleta do pgAdmin)
│   ├── mascot.css           # posição, balão e animações do Claudinho
│   └── theme-terminal.css   # tema terminal antigo, guardado como backup
├── js/
│   ├── config.js            # URL da API
│   ├── questions.js         # perguntas locais + loadQuestions()
│   ├── mascot.js            # Claudinho: humores, fala, piscadas e reações
│   ├── voice.js             # voz do Claudinho (síntese de voz do navegador)
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
- Ao final, a pontuação e o ranking são exibidos (RQ04) e o jogador pode jogar de novo (RQ05). Com o backend no ar, a partida é salva e a tela troca o ranking da sessão pelo **ranking geral**: a melhor pontuação de cada jogador, vinda do banco (top 10 e, se ficou de fora, a linha do jogador). Se a API estiver fora do ar ou falhar, vale o ranking da sessão, que guarda só `{ name, points }` no `sessionStorage` e calcula a posição ao exibir. Partidas sem nenhuma resposta não são salvas.
- O banco de perguntas tem 45 perguntas (30 de SQL e bancos de dados, 10 de aquecimento e 5 bônus de história da tecnologia). Por partida são sorteadas até `CONFIG.QUESTIONS_PER_GAME` perguntas (10).
- As perguntas bônus (`bonus: true`) aparecem com o selo "★ Bônus". Elas valem os mesmos pontos das demais.

## Claudinho, o mascote

O Claudinho Robô fica no canto inferior direito da tela. Ele pisca, acena ao dar boas-vindas, fala num balão e reage ao jogo: feliz ao acertar (com falas diferentes para acerto rápido, lento e sequências), triste ao errar, surpreso quando o tempo está acabando, na pergunta difícil e no tempo esgotado, e comemora ou incentiva no resultado final.

- O desenho é um SVG inline em `index.html`; `js/mascot.js` troca os atributos `data-eyes`, `data-mouth` e `data-arm`, e `css/mascot.css` mostra só o estado atual. Os frames seguem a folha de sprites original.
- `script.js` só chama `mascot.onScreen`, `onQuestion`, `onTimeWarning`, `onAnswer` e `onResult`. Sem `mascot.js`, o quiz funciona normalmente.
- Para editar as falas, veja `MESSAGES` em `js/mascot.js`. Para mudar de canto, troque `right` por `left` em `css/mascot.css`.
- O desenho e o balão são decorativos (`aria-hidden`) e o mascote não captura cliques; só o botão de som, à esquerda dele, é clicável. Com `prefers-reduced-motion`, ele fica parado (o rosto ainda muda de expressão).

### Voz do Claudinho

`js/voice.js` faz o Claudinho falar as mesmas frases do balão, em pt-BR, com tom agudo e um bipe curto de robô antes de cada fala; a boca e o balão acompanham a fala. O botão redondo ao lado dele liga e desliga a voz (a escolha fica salva no navegador).

- É a voz de síntese do próprio navegador, então o timbre muda conforme o navegador e o sistema (Edge e Chrome no Windows costumam ter boas vozes pt-BR; algumas vozes ignoram o tom). Para ajustar, veja `SETTINGS` (tom e velocidade) e `PREFERRED` (nomes de voz) em `js/voice.js`.
- O navegador só libera o som depois do primeiro clique na página; por isso a saudação do início aparece só no balão.
- Símbolos e termos de SQL têm leitura própria em `SPOKEN` (por exemplo, `*` vira "estrela").

## Acessibilidade

Tudo é operável por teclado (Tab, Enter e Espaço), o foco fica visível e é movido a cada etapa, e acerto, erro, seleção, dificuldade e posição no ranking sempre aparecem também em texto ou símbolo, nunca só por cor.

## Adicionar perguntas

Local: inclua objetos em `LOCAL_QUESTIONS`, em `js/questions.js`, com `question`, `options`, `correctAnswer` (índice), `difficulty` (`facil`, `medio` ou `dificil`), `bonus` (opcional, `true` nas bônus), `category`, `explanation`, `sourceName` e `sourceUrl`. Trechos entre crases viram código. Com backend: edite `backend/seed.sql` e rode `npm run db:init`.
