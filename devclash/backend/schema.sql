-- Esquema do DevClash (PostgreSQL / Supabase), com os nomes em português usados no banco:
--   categorias_perguntas, fontes, questao_quiz, opcoes_perguntas,
--   jogadores, dados_partidas e registro_perguntas.
-- Pode ser executado mais de uma vez (IF NOT EXISTS). Em um banco que já tem as tabelas, não altera nada.

CREATE TABLE IF NOT EXISTS categorias_perguntas (
  id   SERIAL PRIMARY KEY,
  nome TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS fontes (
  id   SERIAL PRIMARY KEY,
  nome TEXT NOT NULL,
  url  TEXT NOT NULL
);

-- nome_fonte e url_fonte repetem os dados de "fontes" (fonte_id); a API prefere os de "fontes".
CREATE TABLE IF NOT EXISTS questao_quiz (
  id                   SERIAL PRIMARY KEY,
  categoria_id         INTEGER NOT NULL REFERENCES categorias_perguntas (id),
  pergunta             TEXT NOT NULL,
  explicacao           TEXT NOT NULL,
  nome_fonte           TEXT NOT NULL,
  url_fonte            TEXT NOT NULL,
  dificuldade_pergunta TEXT NOT NULL DEFAULT 'medio' CHECK (dificuldade_pergunta IN ('facil', 'medio', 'dificil')),
  pergunta_bonus       BOOLEAN NOT NULL DEFAULT FALSE,
  ativo                BOOLEAN NOT NULL DEFAULT TRUE,
  criado_em            TIMESTAMPTZ NOT NULL DEFAULT now(),
  fonte_id             INTEGER NOT NULL REFERENCES fontes (id)
);

-- "posicao_pergunta" é o índice da alternativa (0, 1, 2...) e é o que o front usa em correctAnswer.
CREATE TABLE IF NOT EXISTS opcoes_perguntas (
  id               SERIAL PRIMARY KEY,
  id_pergunta      INTEGER NOT NULL REFERENCES questao_quiz (id) ON DELETE CASCADE,
  posicao_pergunta SMALLINT NOT NULL CHECK (posicao_pergunta >= 0),
  alternativas     TEXT NOT NULL,
  esta_correto     BOOLEAN NOT NULL DEFAULT FALSE,
  UNIQUE (id_pergunta, posicao_pergunta)
);

-- Garante no máximo uma alternativa correta por pergunta (RQ02).
CREATE UNIQUE INDEX IF NOT EXISTS opcoes_uma_correta_por_pergunta
  ON opcoes_perguntas (id_pergunta) WHERE esta_correto;

-- Jogadores ficam separados das partidas para não repetir o cadastro a cada partida.
CREATE TABLE IF NOT EXISTS jogadores (
  id        SERIAL PRIMARY KEY,
  nome      TEXT NOT NULL UNIQUE CHECK (char_length(nome) BETWEEN 1 AND 20),
  criado_em TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS dados_partidas (
  id              SERIAL PRIMARY KEY,
  nome_jogador    TEXT NOT NULL CHECK (char_length(nome_jogador) BETWEEN 1 AND 20),
  jogador_id      INTEGER NOT NULL REFERENCES jogadores (id),
  pontuacao_total INTEGER NOT NULL DEFAULT 0 CHECK (pontuacao_total >= 0),
  tempo_total     NUMERIC NOT NULL DEFAULT 0 CHECK (tempo_total >= 0),
  comeco_em       TIMESTAMPTZ,
  terminou_em     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS registro_perguntas (
  id                  SERIAL PRIMARY KEY,
  id_partida          INTEGER NOT NULL REFERENCES dados_partidas (id) ON DELETE CASCADE,
  pergunta_id         INTEGER NOT NULL REFERENCES questao_quiz (id),
  posicao_selecionada SMALLINT,
  status              TEXT NOT NULL CHECK (status IN ('correct', 'incorrect', 'timeout')),
  pontos              SMALLINT NOT NULL CHECK (pontos BETWEEN 0 AND 10),
  tempo_gasto         NUMERIC(5, 2) NOT NULL CHECK (tempo_gasto >= 0),
  UNIQUE (id_partida, pergunta_id),
  FOREIGN KEY (pergunta_id, posicao_selecionada)
    REFERENCES opcoes_perguntas (id_pergunta, posicao_pergunta)
);

CREATE INDEX IF NOT EXISTS questao_quiz_categoria_idx ON questao_quiz (categoria_id);
CREATE INDEX IF NOT EXISTS questao_quiz_fonte_idx ON questao_quiz (fonte_id);
CREATE INDEX IF NOT EXISTS dados_partidas_jogador_idx ON dados_partidas (jogador_id);
CREATE INDEX IF NOT EXISTS registro_perguntas_partida_idx ON registro_perguntas (id_partida);
CREATE INDEX IF NOT EXISTS registro_perguntas_pergunta_idx ON registro_perguntas (pergunta_id);
