# API do Tech Trivia (Node.js + PostgreSQL)

Backend do quiz. Entrega as perguntas (com explicação e fonte) e recebe as partidas finalizadas.

## Requisitos

- Node.js 18 ou superior
- PostgreSQL

## Como rodar localmente

1. Crie o banco (exemplo com `psql`):

   ```sql
   CREATE USER quiz WITH PASSWORD 'quiz';
   CREATE DATABASE quiz_tecnologia OWNER quiz;
   ```

2. Configure o ambiente:

   ```bash
   cd backend
   cp .env.example .env     # ajuste DATABASE_URL se necessário
   npm install
   ```

3. Crie as tabelas e carregue as perguntas iniciais (pode rodar de novo sem duplicar):

   ```bash
   npm run db:init
   ```

4. Inicie a API:

   ```bash
   npm start                # http://localhost:3000
   ```

5. No front, edite `js/config.js` e defina `const API_BASE_URL = "http://localhost:3000";`.

## Endpoints

| Método | Rota | Descrição |
| --- | --- | --- |
| GET | `/api/health` | Verifica se a API e o banco estão no ar |
| GET | `/api/questions?limit=10` | Sorteia perguntas ativas (1 a 50). Formato igual ao de `js/questions.js` |
| POST | `/api/matches` | Salva uma partida finalizada |

Exemplo de corpo do `POST /api/matches`:

```json
{
  "playerName": "Rino",
  "totalScore": 11,
  "startedAt": "2026-10-02T10:00:00Z",
  "finishedAt": "2026-10-02T10:05:00Z",
  "answers": [
    { "questionId": 1, "selectedAnswer": 0, "status": "correct", "points": 10, "timeSpent": 4.2 },
    { "questionId": 2, "selectedAnswer": 1, "status": "incorrect", "points": 1, "timeSpent": 12 }
  ]
}
```

O servidor valida o corpo, confere cada resposta com o gabarito do banco (`status` precisa bater com `selectedAnswer`) e exige que `totalScore` seja a soma dos pontos. Os pontos de cada pergunta são calculados pelo front e aceitos entre 0 e 10, então isto **não é proteção contra trapaça**, apenas contra dados malformados.

## Modelo de dados

`categories` → `questions` → `options` (uma alternativa correta por pergunta, garantido por índice único parcial) e `matches` → `match_answers`. Veja `schema.sql`. Para adicionar perguntas, insira linhas em `questions` e `options` (a posição das alternativas começa em 0) ou edite `seed.sql`.

## Publicação

O GitHub Pages hospeda só o front-end estático. A API precisa de outro serviço que rode Node.js (por exemplo Render, Railway ou Fly.io) e de um Postgres gerenciado (Neon, Supabase ou o do próprio provedor). Ao publicar:

1. Defina no serviço as variáveis `DATABASE_URL`, `DATABASE_SSL=true` (se o banco exigir SSL) e `CORS_ORIGIN=https://SEU_USUARIO.github.io`.
2. Rode `npm run db:init` uma vez contra o banco de produção.
3. Em `js/config.js`, coloque a URL pública da API em `API_BASE_URL` e publique o front.

Se a API estiver fora do ar, o front usa as perguntas locais de `js/questions.js` e continua funcionando; só a gravação da partida é perdida.
