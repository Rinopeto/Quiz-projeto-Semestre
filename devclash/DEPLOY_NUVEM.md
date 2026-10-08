# DevClash: banco de dados na nuvem

Arquitetura final (tudo com plano gratuito):

```
GitHub Pages (front HTML/CSS/JS)  ──►  Render (API Node.js)  ──►  Supabase (PostgreSQL)
```

O navegador **nunca** fala direto com o banco: só a API tem a senha. Por isso a senha fica em variável de ambiente no Render e nunca vai para o GitHub.

## 1. Banco: Supabase

1. Crie uma conta em supabase.com e um **New project**. Anote a **Database Password** (evite `@ : / ?` na senha, ou terá de codificá-los na URL).
2. Com o projeto criado, clique em **Connect** e copie a string de conexão do **Session pooler** (formato `postgresql://postgres.SEU_REF:[YOUR-PASSWORD]@aws-0-REGIAO.pooler.supabase.com:5432/postgres`). Troque `[YOUR-PASSWORD]` pela senha. Use o *pooler* porque a conexão direta (`db.xxx.supabase.co`) costuma ser só IPv6 e pode falhar em hospedagens IPv4.
3. Crie as tabelas e carregue as 45 perguntas. Escolha **uma** das formas:
   - **Sem instalar nada:** no Supabase abra **SQL Editor**, cole o conteúdo de `backend/schema.sql` e clique em *Run*; depois faça o mesmo com `backend/seed.sql`.
   - **Pelo terminal:** `cd backend && cp .env.example .env`, ponha a string do passo 2 em `DATABASE_URL`, defina `DATABASE_SSL=true`, depois `npm install && npm run db:init`.
4. Confira em **Table Editor**: `categories`, `questions` (45 linhas), `options`, `matches`, `match_answers`.

Os scripts são idempotentes: pode rodar de novo sem duplicar perguntas. O `schema.sql` já liga o **RLS** (segurança de linha) nas tabelas, para a API pública do Supabase não expor os dados.

## 2. API: Render

1. Suba o projeto no GitHub (o `.gitignore` já protege `.env` e `node_modules`).
2. No render.com: **New + > Web Service**, escolha o repositório e configure:
   - **Root Directory:** `backend`
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`
   - **Instance type:** Free

   (Ou use **New + > Blueprint**, que lê o `backend/render.yaml`.)
3. Em **Environment**, crie:

   | Variável | Valor |
   | --- | --- |
   | `DATABASE_URL` | string do Supabase (passo 1.2) |
   | `DATABASE_SSL` | `true` |
   | `CORS_ORIGIN` | `https://SEU_USUARIO.github.io` (sem barra no final e sem o nome do repositório) |

4. Após o deploy, abra `https://SEU-APP.onrender.com/api/health`: deve responder `{"status":"ok"}`. Teste também `/api/questions?limit=3` e `/api/ranking`.

> No plano gratuito o Render "dorme" após ~15 min sem uso, e a primeira chamada leva até ~1 min. O front espera até 45 s antes de cair para as perguntas locais. Antes da apresentação, abra o `/api/health` uma vez para acordar a API.

## 3. Front: GitHub Pages

1. Em `js/config.js`, coloque a URL da API (sem barra no final):

   ```js
   const API_BASE_URL = "https://SEU-APP.onrender.com";
   ```
2. Faça commit e envie. No GitHub: **Settings > Pages > Deploy from a branch** (`main`, pasta `/ (root)`). O `index.html` precisa estar na raiz publicada.
3. Abra o site e jogue uma partida. A tela final deve mostrar **"Ranking geral"**; no Supabase, a partida aparece em `matches` e `match_answers`.

## O que mudou no código

| Arquivo | Mudança |
| --- | --- |
| `backend/schema.sql` | `matches.total_time` (desempate), índice do ranking, RLS |
| `backend/src/app.js` | nova rota `GET /api/ranking`; `POST /api/matches` grava o tempo total |
| `js/script.js` | salva a partida e exibe o **ranking geral** do banco; se a API falhar, usa o ranking da sessão e avisa o jogador |
| `js/questions.js` | tempo limite da API de 8 s para 45 s (cold start do Render) |
| `index.html` | título e linha de status do ranking |
| `backend/render.yaml` | blueprint do deploy (opcional) |

## Trechos do documento de requisitos para atualizar

- **Escopo, "O que o sistema NÃO FAZ":** remover "Não persiste dados em um banco de dados relacional remoto…".
- **Escopo, "O que o sistema FAZ":** trocar a persistência por `localStorage` por: "Persiste partidas e ranking geral em um banco PostgreSQL na nuvem, acessado por uma API".
- **RNF02:** "Os dados de partidas e o ranking devem ser armazenados em PostgreSQL na nuvem (Supabase) e acessados por API REST (Node.js/Express); se a API estiver indisponível, o sistema deve continuar funcionando com ranking local da sessão."
- **Novo RF:** "O sistema deve gravar cada partida finalizada (jogador, pontuação, tempo total e respostas) no banco e exibir o ranking geral com todos os jogadores."
- **Novo RNF:** "A senha do banco não deve ser exposta no front-end; somente a API acessa o banco."
