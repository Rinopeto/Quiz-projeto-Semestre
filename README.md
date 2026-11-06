# DevClash — Quiz de SQL e História da Tecnologia

**DevClash** é um quiz educacional desenvolvido em HTML5, CSS3 e JavaScript puro para exercitar conhecimentos de SQL, modelagem e administração de bancos de dados PostgreSQL. Conta com o mascote animado **Claudinho**, perguntas com explicações e referências, sistema de pontos e ranking. O visual utiliza referências do pgAdmin e a fonte JetBrains Mono (com fallback monoespaçado).

## Conteúdo e regras atuais

- **50 questões cadastradas:** 40 sobre SQL, PostgreSQL, modelagem e ferramentas; **10 bônus de história da tecnologia**.
- **50 questões por partida**, quando as 50 estiverem disponíveis na fonte de dados. O total efetivo depende das questões retornadas pela API ou do conjunto local; a constante `CONFIG.QUESTIONS_PER_GAME` em `devclash/js/script.js` define o limite.
- Perguntas normais organizadas por dificuldade (fácil, média e difícil), seguidas das questões bônus; alternativas embaralhadas por partida.
- **50 segundos por pergunta**. O jogador pode mudar a alternativa selecionada até confirmar.
- Acertos rendem de **3 a 10 pontos** segundo o tempo restante; erro confirmado rende **1 ponto**; tempo esgotado rende **0**.
- Após cada resposta, o jogo informa o resultado, explica a alternativa correta e disponibiliza o link da fonte. As questões bônus possuem identificação visual, mas seguem a mesma regra de pontuação.

| Tempo restante no acerto | Pontos |
| --- | ---: |
| 40 a 50 segundos | 10 |
| 35 a menos de 40 segundos | 8 |
| 25 a menos de 35 segundos | 6 |
| 15 a menos de 25 segundos | 4 |
| Mais de 0 a menos de 15 segundos | 3 |
| Resposta incorreta | 1 |
| Tempo esgotado | 0 |

## Como executar

O site do quiz está em **`devclash/index.html`**, e não na raiz do repositório.

1. Para executar apenas o front-end, abra `devclash/index.html` em um navegador moderno ou, preferencialmente, inicie um servidor local dentro de `devclash`:
   ```bash
   cd devclash
   python -m http.server 8000
   ```
   Depois acesse `http://localhost:8000`.
2. O arquivo `devclash/js/config.js` define `API_BASE_URL`, atualmente apontando para uma API hospedada no Render. O jogo tenta carregar perguntas e ranking pela API; se não conseguir obter as perguntas, usa as perguntas locais.
3. Para configurar um backend próprio, consulte [`devclash/backend/README.md`](devclash/backend/README.md), configure o PostgreSQL e altere `API_BASE_URL` para o endereço da API. Para executar só com dados locais, defina `API_BASE_URL = ""`.
4. Ao publicar no GitHub Pages, configure a publicação para servir a pasta `devclash` (ou disponibilize o conteúdo dessa pasta como raiz publicada).

## Ranking e persistência

Quando a API e o PostgreSQL estão disponíveis, uma partida concluída com respostas é enviada a `POST /api/matches`. O ranking geral vem de `GET /api/ranking` e mostra as melhores pontuações por jogador, com desempate por menor tempo total e critérios adicionais da API. A interface mostra os 10 primeiros e pode incluir a posição do jogador atual fora desse grupo.

Na ausência do serviço de ranking, é exibido o **ranking da sessão**, guardado em `sessionStorage` (não em `localStorage` permanente). Assim, ele vale para a sessão atual do navegador. A preferência de voz do Claudinho é armazenada separadamente em `localStorage`.

## Claudinho: animações e voz do navegador

Claudinho é um mascote SVG que aparece na interface, reage a acertos, erros, dificuldade, tempo acabando e ao resultado da partida, além de piscar e movimentar o braço. Em dispositivos com mouse, **a parte verde dos olhos acompanha o ponteiro quando ele está próximo**, sem mover todo o personagem. As animações respeitam a preferência por movimento reduzido do sistema.

A fala utiliza o **leitor de texto nativo do navegador** (`SpeechSynthesisUtterance` / Web Speech API), configurado em `devclash/js/voice.js` para priorizar uma voz em **português do Brasil**. **Não há necessidade dos antigos arquivos MP3** em `devclash/audio/voz_claudinho/`.

- O botão de som próximo ao Claudinho permite ativar/desativar a voz; a preferência é lembrada no navegador.
- Uma fala nova cancela a anterior, e os eventos de início/fim são usados para coordenar as reações visuais.
- A voz disponível, a pronúncia e a liberação de reprodução variam entre navegadores, dispositivos e sistemas operacionais.
- Os parâmetros em `devclash/js/voice.js` são `utterance.lang`, `utterance.rate`, `utterance.pitch` e `utterance.volume`. **O volume vai de `0` a `1`**: `1.0` é o máximo permitido pela API. A configuração presente nesta versão do código é `0.85` (85%).
- Para alterar os textos do mascote, edite `MESSAGES` em `devclash/js/mascot.js`.

## Organização do repositório

```text
Quiz-projeto-Semestre-main/
├── README.md                     # visão geral e instalação
├── doc_date                      # contexto, minimundo e requisitos
├── Artigo_documenta...txt        # material de apoio do projeto
├── devclashlogo.png              # logo
└── devclash/
    ├── index.html                # interface do quiz e SVG do Claudinho
    ├── css/
    │   ├── style.css             # estilo principal
    │   ├── mascot.css            # aparência e animações do mascote
    │   └── theme-terminal.css    # tema alternativo/legado
    ├── js/
    │   ├── config.js             # endereço da API
    │   ├── questions.js          # 50 perguntas locais e carregamento da API
    │   ├── script.js             # fluxo da partida, tempo, pontos e ranking
    │   ├── mascot.js             # reações, expressões e mensagens
    │   └── voice.js              # síntese de voz nativa do navegador
    └── backend/
        ├── README.md             # instruções específicas da API
        ├── src/                  # servidor Express, rotas e conexão com banco
        ├── schema.sql            # estrutura relacional PostgreSQL
        ├── seed.sql              # carga de perguntas
        └── select.sql            # consultas SQL do projeto
```

## Banco de dados e API

O backend é implementado em **Node.js + Express + PostgreSQL**. O `schema.sql` utiliza as tabelas `categorias_perguntas`, `fontes`, `questao_quiz`, `opcoes_perguntas`, `jogadores`, `dados_partidas` e `registro_perguntas`, relacionadas por chaves primárias e estrangeiras.

| Método | Rota | Finalidade |
| --- | --- | --- |
| GET | `/api/health` | Verificar serviço e banco |
| GET | `/api/questions?limit=50` | Buscar perguntas disponíveis |
| POST | `/api/matches` | Registrar partida e respostas |
| GET | `/api/ranking?limit=10&player=NOME` | Consultar classificação geral e posição do jogador |

Para editar perguntas locais, altere `LOCAL_QUESTIONS` em `devclash/js/questions.js`. Para atualizar também as perguntas persistidas no banco, mantenha `devclash/backend/seed.sql` sincronizado e execute a inicialização indicada no README do backend.

## Acessibilidade

O quiz oferece navegação por teclado, indicação textual da dificuldade e feedback de respostas sem depender exclusivamente de cores. A voz do Claudinho é opcional, e a partida permanece utilizável sem ela.
