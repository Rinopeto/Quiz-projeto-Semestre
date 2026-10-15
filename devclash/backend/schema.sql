-- Esquema normalizado do DevClash (PostgreSQL)
-- Modelo para banco novo. As tabelas categories, sources, questions, options,
-- players, matches e match_answers separam entidades e evitam repetição de dados.

CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE sources (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  url TEXT NOT NULL UNIQUE
);

CREATE TABLE questions (
  id SERIAL PRIMARY KEY,
  category_id INTEGER NOT NULL REFERENCES categories(id),
  source_id INTEGER NOT NULL REFERENCES sources(id),
  statement TEXT NOT NULL,
  explanation TEXT NOT NULL,
  difficulty TEXT NOT NULL DEFAULT 'medio'
    CHECK (difficulty IN ('facil', 'medio', 'dificil')),
  is_bonus BOOLEAN NOT NULL DEFAULT FALSE,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE options (
  id SERIAL PRIMARY KEY,
  question_id INTEGER NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  position SMALLINT NOT NULL CHECK (position >= 0),
  text TEXT NOT NULL,
  is_correct BOOLEAN NOT NULL DEFAULT FALSE,
  UNIQUE (question_id, position)
);

CREATE UNIQUE INDEX options_one_correct_per_question
  ON options(question_id) WHERE is_correct;

-- Jogadores são separados das partidas para evitar repetir o nome em cada partida.
CREATE TABLE players (
  id SERIAL PRIMARY KEY,
  nickname TEXT NOT NULL UNIQUE
    CHECK (char_length(nickname) BETWEEN 1 AND 20),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE matches (
  id SERIAL PRIMARY KEY,
  player_id INTEGER NOT NULL REFERENCES players(id),
  total_score INTEGER NOT NULL DEFAULT 0 CHECK (total_score >= 0),
  started_at TIMESTAMPTZ,
  finished_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE match_answers (
  id SERIAL PRIMARY KEY,
  match_id INTEGER NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
  question_id INTEGER NOT NULL REFERENCES questions(id),
  selected_position SMALLINT,
  status TEXT NOT NULL CHECK (status IN ('correct', 'incorrect', 'timeout')),
  points SMALLINT NOT NULL CHECK (points BETWEEN 0 AND 10),
  time_spent NUMERIC(5,2) NOT NULL CHECK (time_spent >= 0),
  UNIQUE (match_id, question_id),
  FOREIGN KEY (question_id, selected_position)
    REFERENCES options(question_id, position)
);

CREATE INDEX questions_category_idx ON questions(category_id);
CREATE INDEX questions_source_idx ON questions(source_id);
CREATE INDEX matches_player_idx ON matches(player_id);
CREATE INDEX match_answers_match_idx ON match_answers(match_id);
CREATE INDEX match_answers_question_idx ON match_answers(question_id);
