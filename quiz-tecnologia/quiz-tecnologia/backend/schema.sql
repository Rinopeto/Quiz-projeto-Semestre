-- Esquema do banco do Tech Trivia (PostgreSQL)

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
  active      BOOLEAN NOT NULL DEFAULT TRUE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

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
