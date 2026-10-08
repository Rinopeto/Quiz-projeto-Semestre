-- Esquema do banco do DevClash (PostgreSQL)

CREATE TABLE IF NOT EXISTS categories (
  id   SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS questions (
  id          SERIAL PRIMARY KEY,
  category_id INTEGER NOT NULL REFERENCES categories (id),
  statement   TEXT NOT NULL,
  explanation TEXT NOT NULL,
  source_name TEXT NOT NULL,
  source_url  TEXT NOT NULL,
  difficulty  TEXT NOT NULL DEFAULT 'medio' CHECK (difficulty IN ('facil', 'medio', 'dificil')),
  is_bonus    BOOLEAN NOT NULL DEFAULT FALSE,
  active      BOOLEAN NOT NULL DEFAULT TRUE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Para bancos criados antes do campo de dificuldade (no-op nos demais).
ALTER TABLE questions
  ADD COLUMN IF NOT EXISTS difficulty TEXT NOT NULL DEFAULT 'medio' CHECK (difficulty IN ('facil', 'medio', 'dificil'));

ALTER TABLE questions ADD COLUMN IF NOT EXISTS is_bonus BOOLEAN NOT NULL DEFAULT FALSE;

-- "position" é o índice da alternativa (0, 1, 2...) e é o que o front usa em correctAnswer.
CREATE TABLE IF NOT EXISTS options (
  id          SERIAL PRIMARY KEY,
  question_id INTEGER NOT NULL REFERENCES questions (id) ON DELETE CASCADE,
  position    SMALLINT NOT NULL CHECK (position >= 0),
  text        TEXT NOT NULL,
  is_correct  BOOLEAN NOT NULL DEFAULT FALSE,
  UNIQUE (question_id, position)
);

-- Garante no máximo uma alternativa correta por pergunta (RQ02).
CREATE UNIQUE INDEX IF NOT EXISTS options_one_correct_per_question
  ON options (question_id) WHERE is_correct;

CREATE TABLE IF NOT EXISTS matches (
  id           SERIAL PRIMARY KEY,
  player_name  TEXT NOT NULL CHECK (char_length(player_name) BETWEEN 1 AND 20),
  total_score  INTEGER NOT NULL CHECK (total_score >= 0),
  total_time   NUMERIC(8, 2) NOT NULL DEFAULT 0 CHECK (total_time >= 0),
  started_at   TIMESTAMPTZ,
  finished_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS match_answers (
  id                SERIAL PRIMARY KEY,
  match_id          INTEGER NOT NULL REFERENCES matches (id) ON DELETE CASCADE,
  question_id       INTEGER NOT NULL REFERENCES questions (id),
  selected_position SMALLINT,
  status            TEXT NOT NULL CHECK (status IN ('correct', 'incorrect', 'timeout')),
  points            SMALLINT NOT NULL CHECK (points BETWEEN 0 AND 10),
  time_spent        NUMERIC(5, 2) NOT NULL CHECK (time_spent >= 0)
);

CREATE INDEX IF NOT EXISTS match_answers_match_idx ON match_answers (match_id);

-- Tempo total de resposta da partida (desempate do ranking). No-op em bancos já criados com o campo.
ALTER TABLE matches ADD COLUMN IF NOT EXISTS total_time NUMERIC(8, 2) NOT NULL DEFAULT 0 CHECK (total_time >= 0);

-- Ranking geral: maior pontuação primeiro; empate = menor tempo total.
CREATE INDEX IF NOT EXISTS matches_ranking_idx ON matches (total_score DESC, total_time ASC, id ASC);

-- Segurança em bancos gerenciados (Supabase): com RLS ligado e sem políticas, a API pública
-- do Supabase (chave "anon") não lê nem grava nada. A nossa API Node conecta com o usuário
-- dono das tabelas e não é afetada.
ALTER TABLE categories     ENABLE ROW LEVEL SECURITY;
ALTER TABLE questions      ENABLE ROW LEVEL SECURITY;
ALTER TABLE options        ENABLE ROW LEVEL SECURITY;
ALTER TABLE matches        ENABLE ROW LEVEL SECURITY;
ALTER TABLE match_answers  ENABLE ROW LEVEL SECURITY;
