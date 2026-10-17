-- Dados iniciais (gerados a partir de js/questions.js). Pode ser executado mais de uma vez, mesmo com
-- partidas já salvas: atualiza as perguntas e as alternativas de mesmo id, sem apagar as que já existem.

INSERT INTO categorias_perguntas (nome)
SELECT v.nome
FROM (VALUES
  ('Modelagem e DDL'),
  ('Ferramentas'),
  ('Consultas SQL'),
  ('PostgreSQL'),
  ('Transações'),
  ('Desempenho'),
  ('Fundamentos de SQL'),
  ('História da tecnologia')
) AS v(nome)
WHERE NOT EXISTS (SELECT 1 FROM categorias_perguntas c WHERE c.nome = v.nome);

INSERT INTO fontes (nome, url)
SELECT v.nome, v.url
FROM (VALUES
  ('Documentação do PostgreSQL: Constraints', 'https://www.postgresql.org/docs/current/ddl-constraints.html'),
  ('Documentação do PostgreSQL: Table Basics', 'https://www.postgresql.org/docs/current/ddl-basics.html'),
  ('pgAdmin', 'https://www.pgadmin.org/'),
  ('Documentação do PostgreSQL: Aggregate Functions (tutorial)', 'https://www.postgresql.org/docs/current/tutorial-agg.html'),
  ('Documentação do PostgreSQL: Joins Between Tables', 'https://www.postgresql.org/docs/current/tutorial-join.html'),
  ('Documentação do PostgreSQL: Comparison Functions and Operators', 'https://www.postgresql.org/docs/current/functions-comparison.html'),
  ('Documentação do PostgreSQL: Index Types', 'https://www.postgresql.org/docs/current/indexes-types.html'),
  ('Documentação do PostgreSQL: SET TRANSACTION', 'https://www.postgresql.org/docs/current/sql-set-transaction.html'),
  ('Documentação do PostgreSQL: Using EXPLAIN', 'https://www.postgresql.org/docs/current/using-explain.html'),
  ('Documentação do PostgreSQL: Routine Vacuuming', 'https://www.postgresql.org/docs/current/routine-vacuuming.html'),
  ('Wikipédia: SQL', 'https://pt.wikipedia.org/wiki/SQL'),
  ('Documentação do PostgreSQL: Inserting Data', 'https://www.postgresql.org/docs/current/dml-insert.html'),
  ('Documentação do PostgreSQL: Sorting Rows', 'https://www.postgresql.org/docs/current/queries-order.html'),
  ('Documentação do PostgreSQL: Updating Data', 'https://www.postgresql.org/docs/current/dml-update.html'),
  ('Documentação do PostgreSQL: Aggregate Functions', 'https://www.postgresql.org/docs/current/functions-aggregate.html'),
  ('Documentação do PostgreSQL: Select Lists', 'https://www.postgresql.org/docs/current/queries-select-lists.html'),
  ('Documentação do pgAdmin: Query Tool', 'https://www.pgadmin.org/docs/pgadmin4/latest/query_tool.html'),
  ('Documentação do PostgreSQL: Connections and Authentication', 'https://www.postgresql.org/docs/current/runtime-config-connection.html'),
  ('Documentação do PostgreSQL: Combining Queries', 'https://www.postgresql.org/docs/current/queries-union.html'),
  ('Documentação do PostgreSQL: Conditional Expressions', 'https://www.postgresql.org/docs/current/functions-conditional.html'),
  ('Documentação do PostgreSQL: WITH Queries', 'https://www.postgresql.org/docs/current/queries-with.html'),
  ('Documentação do PostgreSQL: Window Functions', 'https://www.postgresql.org/docs/current/functions-window.html'),
  ('Documentação do PostgreSQL: TRUNCATE', 'https://www.postgresql.org/docs/current/sql-truncate.html'),
  ('Documentação do PostgreSQL: CREATE VIEW', 'https://www.postgresql.org/docs/current/sql-createview.html'),
  ('Wikipedia: First normal form', 'https://en.wikipedia.org/wiki/First_normal_form'),
  ('Wikipedia: ACID', 'https://en.wikipedia.org/wiki/ACID'),
  ('Documentação do pgAdmin: ERD Tool', 'https://www.pgadmin.org/docs/pgadmin4/latest/erd_tool.html'),
  ('Documentação do PostgreSQL: SAVEPOINT', 'https://www.postgresql.org/docs/current/sql-savepoint.html'),
  ('Documentação do PostgreSQL: JSON Types', 'https://www.postgresql.org/docs/current/datatype-json.html'),
  ('Documentação do PostgreSQL: Pattern Matching', 'https://www.postgresql.org/docs/current/functions-matching.html'),
  ('Documentação do PostgreSQL: Introduction (MVCC)', 'https://www.postgresql.org/docs/current/mvcc-intro.html'),
  ('Documentação do PostgreSQL: Transaction Isolation', 'https://www.postgresql.org/docs/current/transaction-iso.html'),
  ('Documentação do PostgreSQL: Explicit Locking', 'https://www.postgresql.org/docs/current/explicit-locking.html'),
  ('Documentação do PostgreSQL: Partial Indexes', 'https://www.postgresql.org/docs/current/indexes-partial.html'),
  ('Documentação do PostgreSQL: Index-Only Scans and Covering Indexes', 'https://www.postgresql.org/docs/current/indexes-index-only-scans.html'),
  ('Documentação do PostgreSQL: Write-Ahead Logging (WAL)', 'https://www.postgresql.org/docs/current/wal-intro.html'),
  ('Documentação do PostgreSQL: pg_dump', 'https://www.postgresql.org/docs/current/app-pgdump.html'),
  ('Penn Today', 'https://penntoday.upenn.edu/news/worlds-first-general-purpose-computer-turns-75'),
  ('CERN', 'https://home.cern/science/computing/the-birth-of-the-web/short-history-web/'),
  ('InfoEscola', 'https://www.infoescola.com/informatica/cascading-style-sheets-css/'),
  ('Educa Mais Brasil', 'https://www.educamaisbrasil.com.br/educacao/dicas/o-que-e-bug-qual-a-origem-da-expressao'),
  ('CyberSec Brasil', 'https://www.cybersecbrazil.com.br/post/o-creeper-o-primeiro-v%C3%ADrus-de-computador-da-hist%C3%B3ria')
) AS v(nome, url)
WHERE NOT EXISTS (SELECT 1 FROM fontes f WHERE f.url = v.url);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  1,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Modelagem e DDL'),
  'Qual restrição (constraint) garante que cada linha da tabela seja identificada de forma única e não aceita valores nulos?',
  'A `PRIMARY KEY` é a combinação de `UNIQUE` com `NOT NULL`: os valores não podem se repetir nem ser nulos. Uma tabela pode ter no máximo uma chave primária, formada por uma ou mais colunas. Já a `FOREIGN KEY` referencia outra tabela, a `CHECK` valida uma condição e a `DEFAULT` define um valor padrão.',
  'Documentação do PostgreSQL: Constraints',
  'https://www.postgresql.org/docs/current/ddl-constraints.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/ddl-constraints.html' ORDER BY id LIMIT 1),
  'facil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 1 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`PRIMARY KEY`', true),
    (1, '`FOREIGN KEY`', false),
    (2, '`CHECK`', false),
    (3, '`DEFAULT`', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 1 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 1, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 1 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 1 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  2,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Modelagem e DDL'),
  'Qual comando SQL remove uma tabela inteira, incluindo sua estrutura e todos os dados?',
  '`DROP TABLE` apaga a tabela e a sua definição. O `TRUNCATE` esvazia a tabela e o `DELETE` remove linhas, mas os dois mantêm a estrutura. O `ALTER TABLE` só modifica a estrutura, sem apagar a tabela.',
  'Documentação do PostgreSQL: Table Basics',
  'https://www.postgresql.org/docs/current/ddl-basics.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/ddl-basics.html' ORDER BY id LIMIT 1),
  'facil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 2 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`DROP TABLE`', true),
    (1, '`TRUNCATE`', false),
    (2, '`DELETE`', false),
    (3, '`ALTER TABLE`', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 2 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 2, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 2 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 2 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  3,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Ferramentas'),
  'Qual ferramenta é a plataforma open source de administração e desenvolvimento mais usada com o PostgreSQL?',
  'O pgAdmin permite navegar pelos objetos do banco, executar consultas e administrar servidores PostgreSQL. O phpMyAdmin é voltado ao MySQL e ao MariaDB, o SQL Server Management Studio ao SQL Server e o MongoDB Compass ao MongoDB. As cores deste quiz vêm do tema do pgAdmin.',
  'pgAdmin',
  'https://www.pgadmin.org/',
  (SELECT id FROM fontes WHERE url = 'https://www.pgadmin.org/' ORDER BY id LIMIT 1),
  'facil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 3 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'pgAdmin', true),
    (1, 'phpMyAdmin', false),
    (2, 'SQL Server Management Studio', false),
    (3, 'MongoDB Compass', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 3 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 3, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 3 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 3 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  4,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL'),
  'Qual cláusula filtra os grupos formados por `GROUP BY` com base no resultado de uma função de agregação, como `COUNT(*)`?',
  'O `WHERE` filtra as linhas antes do agrupamento e não aceita funções de agregação. O `HAVING` filtra os grupos depois que as agregações são calculadas. Exemplo: `GROUP BY cidade HAVING COUNT(*) > 10`.',
  'Documentação do PostgreSQL: Aggregate Functions (tutorial)',
  'https://www.postgresql.org/docs/current/tutorial-agg.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/tutorial-agg.html' ORDER BY id LIMIT 1),
  'medio',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 4 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`HAVING`', true),
    (1, '`WHERE`', false),
    (2, '`ORDER BY`', false),
    (3, '`LIMIT`', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 4 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 4, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 4 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 4 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  5,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL'),
  'Qual tipo de junção retorna todas as linhas da tabela da esquerda, mesmo quando não há correspondência na tabela da direita?',
  'No `LEFT JOIN` (ou `LEFT OUTER JOIN`) toda linha da tabela da esquerda aparece no resultado; quando não há correspondência na direita, as colunas dela vêm como `NULL`. O `INNER JOIN` devolve só as linhas com correspondência nas duas tabelas, o `RIGHT JOIN` faz o inverso e o `CROSS JOIN` gera o produto cartesiano.',
  'Documentação do PostgreSQL: Joins Between Tables',
  'https://www.postgresql.org/docs/current/tutorial-join.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/tutorial-join.html' ORDER BY id LIMIT 1),
  'medio',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 5 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`LEFT JOIN`', true),
    (1, '`INNER JOIN`', false),
    (2, '`RIGHT JOIN`', false),
    (3, '`CROSS JOIN`', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 5 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 5, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 5 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 5 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  6,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL'),
  'Em SQL, qual é o resultado da expressão `NULL = NULL`?',
  '`NULL` representa um valor desconhecido, e comparar dois desconhecidos com `=` também dá um resultado desconhecido, ou seja, `NULL`. Por isso os nulos são testados com `IS NULL` e `IS NOT NULL`.',
  'Documentação do PostgreSQL: Comparison Functions and Operators',
  'https://www.postgresql.org/docs/current/functions-comparison.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/functions-comparison.html' ORDER BY id LIMIT 1),
  'medio',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 6 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`NULL`', true),
    (1, '`TRUE`', false),
    (2, '`FALSE`', false),
    (3, 'Erro de sintaxe', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 6 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 6, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 6 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 6 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  7,
  (SELECT id FROM categorias_perguntas WHERE nome = 'PostgreSQL'),
  'Que tipo de índice o PostgreSQL cria quando você usa `CREATE INDEX` sem informar o método?',
  'Sem a cláusula `USING`, o PostgreSQL cria um índice B-tree, adequado a comparações como `=`, `<`, `>` e `BETWEEN` e também à ordenação. Hash, GiST e GIN são tipos especializados e precisam ser pedidos explicitamente.',
  'Documentação do PostgreSQL: Index Types',
  'https://www.postgresql.org/docs/current/indexes-types.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/indexes-types.html' ORDER BY id LIMIT 1),
  'medio',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 7 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'B-tree', true),
    (1, 'Hash', false),
    (2, 'GiST', false),
    (3, 'GIN', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 7 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 7, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 7 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 7 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  8,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Transações'),
  'Qual é o nível de isolamento de transação padrão do PostgreSQL?',
  'O padrão é `READ COMMITTED`: cada comando enxerga apenas os dados confirmados (commit) antes de ele começar. O padrão SQL define `SERIALIZABLE` como nível padrão, mas no PostgreSQL o normal é `READ COMMITTED`, e isso pode ser alterado. Curiosidade: no PostgreSQL, `READ UNCOMMITTED` se comporta como `READ COMMITTED`.',
  'Documentação do PostgreSQL: SET TRANSACTION',
  'https://www.postgresql.org/docs/current/sql-set-transaction.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/sql-set-transaction.html' ORDER BY id LIMIT 1),
  'dificil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 8 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`READ COMMITTED`', true),
    (1, '`READ UNCOMMITTED`', false),
    (2, '`REPEATABLE READ`', false),
    (3, '`SERIALIZABLE`', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 8 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 8, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 8 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 8 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  9,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Desempenho'),
  'Qual comando mostra o plano de execução de uma consulta e também a executa de verdade, exibindo os tempos reais?',
  'O `EXPLAIN` sozinho mostra apenas o plano estimado pelo otimizador. Com `EXPLAIN ANALYZE` a consulta é executada, e o resultado inclui tempos e contagens de linhas reais. Atenção: um `INSERT`, `UPDATE` ou `DELETE` analisado assim altera os dados de verdade.',
  'Documentação do PostgreSQL: Using EXPLAIN',
  'https://www.postgresql.org/docs/current/using-explain.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/using-explain.html' ORDER BY id LIMIT 1),
  'dificil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 9 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`EXPLAIN ANALYZE`', true),
    (1, '`EXPLAIN`', false),
    (2, '`DESCRIBE`', false),
    (3, '`SHOW PLAN`', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 9 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 9, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 9 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 9 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  10,
  (SELECT id FROM categorias_perguntas WHERE nome = 'PostgreSQL'),
  'No PostgreSQL, qual comando de manutenção recupera o espaço ocupado por linhas mortas, as versões antigas que sobram depois de um `UPDATE` ou `DELETE`?',
  'Por causa do MVCC, um `UPDATE` ou `DELETE` não apaga a linha antiga na hora: ela vira uma linha morta. O `VACUUM` libera esse espaço para reutilização (o autovacuum faz isso automaticamente). O `TRUNCATE` esvazia a tabela inteira, o `REINDEX` reconstrói índices e o `ANALYZE` atualiza as estatísticas usadas pelo planejador.',
  'Documentação do PostgreSQL: Routine Vacuuming',
  'https://www.postgresql.org/docs/current/routine-vacuuming.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/routine-vacuuming.html' ORDER BY id LIMIT 1),
  'dificil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 10 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`VACUUM`', true),
    (1, '`TRUNCATE`', false),
    (2, '`REINDEX`', false),
    (3, '`ANALYZE`', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 10 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 10, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 10 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 10 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  11,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Fundamentos de SQL'),
  'O que significa a sigla SQL?',
  'SQL vem de Structured Query Language (linguagem de consulta estruturada). É a linguagem padrão para criar, consultar e modificar dados em bancos de dados relacionais, como PostgreSQL, MySQL e SQL Server.',
  'Wikipédia: SQL',
  'https://pt.wikipedia.org/wiki/SQL',
  (SELECT id FROM fontes WHERE url = 'https://pt.wikipedia.org/wiki/SQL' ORDER BY id LIMIT 1),
  'facil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 11 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'Standard Question Language', false),
    (1, 'Simple Query Logic', false),
    (2, 'Structured Query Language', true),
    (3, 'Sequential Query Layer', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 11 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 11, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 11 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 11 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  12,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Fundamentos de SQL'),
  'Qual comando SQL insere uma nova linha em uma tabela?',
  '`INSERT INTO` adiciona novas linhas a uma tabela, por exemplo `INSERT INTO clientes (nome) VALUES (''Ana'')`. Para alterar linhas que já existem usa-se o `UPDATE`.',
  'Documentação do PostgreSQL: Inserting Data',
  'https://www.postgresql.org/docs/current/dml-insert.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/dml-insert.html' ORDER BY id LIMIT 1),
  'facil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 12 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`ADD ROW`', false),
    (1, '`INSERT INTO`', true),
    (2, '`APPEND`', false),
    (3, '`CREATE ROW`', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 12 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 12, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 12 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 12 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  13,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL'),
  'Qual cláusula ordena as linhas do resultado de uma consulta?',
  '`ORDER BY` ordena o resultado por uma ou mais colunas, em ordem crescente (`ASC`, o padrão) ou decrescente (`DESC`). O `GROUP BY` serve para agrupar linhas, não para ordená-las.',
  'Documentação do PostgreSQL: Sorting Rows',
  'https://www.postgresql.org/docs/current/queries-order.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/queries-order.html' ORDER BY id LIMIT 1),
  'facil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 13 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`GROUP BY`', false),
    (1, '`SORT BY`', false),
    (2, '`ORDER BY`', true),
    (3, '`ARRANGE BY`', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 13 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 13, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 13 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 13 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  14,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Fundamentos de SQL'),
  'Qual comando altera os valores de linhas que já existem em uma tabela?',
  '`UPDATE` modifica valores de linhas existentes e normalmente vem com `WHERE` para escolher quais linhas mudar. Sem `WHERE`, todas as linhas da tabela são alteradas. O `ALTER` muda a estrutura (como colunas), não os dados.',
  'Documentação do PostgreSQL: Updating Data',
  'https://www.postgresql.org/docs/current/dml-update.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/dml-update.html' ORDER BY id LIMIT 1),
  'facil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 14 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`MODIFY`', false),
    (1, '`CHANGE`', false),
    (2, '`UPDATE`', true),
    (3, '`ALTER`', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 14 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 14, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 14 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 14 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  15,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL'),
  'Qual função de agregação conta o número de linhas de um resultado?',
  '`COUNT` conta linhas (ou valores). `SUM` soma valores numéricos, e `LEN` e `TOTAL` não são funções de contagem no PostgreSQL.',
  'Documentação do PostgreSQL: Aggregate Functions',
  'https://www.postgresql.org/docs/current/functions-aggregate.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/functions-aggregate.html' ORDER BY id LIMIT 1),
  'facil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 15 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`COUNT`', true),
    (1, '`SUM`', false),
    (2, '`TOTAL`', false),
    (3, '`LEN`', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 15 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 15, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 15 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 15 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  16,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL'),
  'Qual palavra-chave remove linhas duplicadas do resultado de um `SELECT`?',
  '`SELECT DISTINCT` elimina as linhas repetidas do resultado. O `LIMIT` apenas restringe quantas linhas são devolvidas, sem tratar duplicatas.',
  'Documentação do PostgreSQL: Select Lists',
  'https://www.postgresql.org/docs/current/queries-select-lists.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/queries-select-lists.html' ORDER BY id LIMIT 1),
  'facil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 16 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`SINGLE`', false),
    (1, '`NOREPEAT`', false),
    (2, '`DISTINCT`', true),
    (3, '`LIMIT`', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 16 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 16, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 16 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 16 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  17,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Ferramentas'),
  'No pgAdmin, qual ferramenta permite escrever e executar comandos SQL em um banco de dados?',
  'O Query Tool é o editor SQL do pgAdmin: você escreve as consultas, executa e vê os resultados em uma grade, além de poder ver o plano de execução. O ERD Tool desenha diagramas, o Grant Wizard gerencia permissões e o Schema Diff compara esquemas.',
  'Documentação do pgAdmin: Query Tool',
  'https://www.pgadmin.org/docs/pgadmin4/latest/query_tool.html',
  (SELECT id FROM fontes WHERE url = 'https://www.pgadmin.org/docs/pgadmin4/latest/query_tool.html' ORDER BY id LIMIT 1),
  'facil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 17 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'ERD Tool', false),
    (1, 'Grant Wizard', false),
    (2, 'Schema Diff', false),
    (3, 'Query Tool', true)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 17 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 17, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 17 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 17 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  18,
  (SELECT id FROM categorias_perguntas WHERE nome = 'PostgreSQL'),
  'Qual é a porta TCP padrão em que o servidor PostgreSQL aceita conexões?',
  'A porta padrão do PostgreSQL é a 5432 (parâmetro `port`). A 3306 é a do MySQL, a 1433 do SQL Server e a 27017 do MongoDB.',
  'Documentação do PostgreSQL: Connections and Authentication',
  'https://www.postgresql.org/docs/current/runtime-config-connection.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/runtime-config-connection.html' ORDER BY id LIMIT 1),
  'facil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 18 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '3306', false),
    (1, '1433', false),
    (2, '5432', true),
    (3, '27017', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 18 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 18, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 18 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 18 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  19,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL'),
  'Qual operador combina o resultado de duas consultas mantendo as linhas duplicadas?',
  '`UNION` junta os resultados e remove as duplicatas; `UNION ALL` mantém todas as linhas e, por isso, costuma ser mais rápido. `INTERSECT` devolve só as linhas presentes nos dois resultados e `EXCEPT` as que estão no primeiro e não no segundo.',
  'Documentação do PostgreSQL: Combining Queries',
  'https://www.postgresql.org/docs/current/queries-union.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/queries-union.html' ORDER BY id LIMIT 1),
  'medio',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 19 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`UNION`', false),
    (1, '`INTERSECT`', false),
    (2, '`EXCEPT`', false),
    (3, '`UNION ALL`', true)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 19 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 19, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 19 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 19 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  20,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL'),
  'O que a função `COALESCE(a, b, c)` devolve?',
  '`COALESCE` percorre os argumentos da esquerda para a direita e devolve o primeiro que não é `NULL` (ou `NULL`, se todos forem). É muito usada para trocar nulos por um valor padrão, como `COALESCE(telefone, ''sem telefone'')`.',
  'Documentação do PostgreSQL: Conditional Expressions',
  'https://www.postgresql.org/docs/current/functions-conditional.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/functions-conditional.html' ORDER BY id LIMIT 1),
  'medio',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 20 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'O primeiro argumento que não for `NULL`', true),
    (1, 'O maior valor entre os argumentos', false),
    (2, 'A concatenação de todos os argumentos', false),
    (3, 'A quantidade de argumentos nulos', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 20 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 20, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 20 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 20 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  21,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL'),
  'Qual cláusula define uma consulta nomeada e temporária (CTE) que pode ser usada dentro de outra consulta?',
  'A cláusula `WITH` cria CTEs (Common Table Expressions), consultas auxiliares com nome que deixam consultas complexas mais legíveis. Com `WITH RECURSIVE` também é possível percorrer estruturas hierárquicas, como árvores de categorias.',
  'Documentação do PostgreSQL: WITH Queries',
  'https://www.postgresql.org/docs/current/queries-with.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/queries-with.html' ORDER BY id LIMIT 1),
  'medio',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 21 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`TEMP`', false),
    (1, '`WITH`', true),
    (2, '`DEFINE`', false),
    (3, '`USING`', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 21 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 21, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 21 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 21 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  22,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL'),
  'Qual função de janela numera as linhas de forma sequencial (1, 2, 3...) dentro de cada partição?',
  '`ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)` numera as linhas de cada partição em sequência, sem repetir números. `LAG()` acessa o valor da linha anterior, e `SUM()` e `COUNT()` são agregações que também podem virar funções de janela, mas não numeram linhas.',
  'Documentação do PostgreSQL: Window Functions',
  'https://www.postgresql.org/docs/current/functions-window.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/functions-window.html' ORDER BY id LIMIT 1),
  'medio',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 22 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`LAG()`', false),
    (1, '`SUM()`', false),
    (2, '`COUNT()`', false),
    (3, '`ROW_NUMBER()`', true)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 22 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 22, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 22 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 22 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  23,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Modelagem e DDL'),
  'Qual restrição impede valores repetidos em uma coluna, mas, diferente da chave primária, aceita valores nulos?',
  '`UNIQUE` garante que os valores não se repitam, mas não exige preenchimento. No PostgreSQL, valores nulos não são considerados iguais entre si, então a coluna pode ter vários `NULL`. Já a `PRIMARY KEY` exige valores únicos e não nulos.',
  'Documentação do PostgreSQL: Constraints',
  'https://www.postgresql.org/docs/current/ddl-constraints.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/ddl-constraints.html' ORDER BY id LIMIT 1),
  'medio',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 23 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`PRIMARY KEY`', false),
    (1, '`NOT NULL`', false),
    (2, '`UNIQUE`', true),
    (3, '`CHECK`', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 23 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 23, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 23 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 23 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  24,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Modelagem e DDL'),
  'Em uma chave estrangeira, o que faz a opção `ON DELETE CASCADE`?',
  'Com `ON DELETE CASCADE`, ao excluir a linha referenciada, as linhas que dependem dela são excluídas junto. O comportamento padrão (`NO ACTION`) rejeita a exclusão, e o `SET NULL` apenas zera a coluna filha.',
  'Documentação do PostgreSQL: Constraints',
  'https://www.postgresql.org/docs/current/ddl-constraints.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/ddl-constraints.html' ORDER BY id LIMIT 1),
  'medio',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 24 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'Impede a exclusão da linha referenciada', false),
    (1, 'Define as colunas filhas como `NULL`', false),
    (2, 'Apaga automaticamente as linhas que referenciam a linha excluída', true),
    (3, 'Copia a linha excluída para uma tabela de histórico', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 24 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 24, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 24 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 24 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  25,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Modelagem e DDL'),
  'Qual comando esvazia uma tabela inteira de forma rápida, sem aceitar cláusula `WHERE`?',
  '`TRUNCATE` remove todas as linhas de uma vez, sem percorrê-las uma a uma, e por isso é bem mais rápido que um `DELETE` sem `WHERE` em tabelas grandes. A estrutura da tabela é mantida. O `DELETE` aceita `WHERE`, e o `DROP TABLE` apaga a tabela inteira.',
  'Documentação do PostgreSQL: TRUNCATE',
  'https://www.postgresql.org/docs/current/sql-truncate.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/sql-truncate.html' ORDER BY id LIMIT 1),
  'medio',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 25 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`TRUNCATE`', true),
    (1, '`DROP TABLE`', false),
    (2, '`DELETE`', false),
    (3, '`VACUUM`', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 25 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 25, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 25 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 25 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  26,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Modelagem e DDL'),
  'O que é uma `VIEW` em um banco de dados relacional?',
  'Uma `VIEW` guarda uma consulta com um nome e permite usá-la como uma tabela virtual. Os dados continuam nas tabelas originais, e a consulta é executada toda vez que a view é lida. Já a `MATERIALIZED VIEW` guarda o resultado da consulta.',
  'Documentação do PostgreSQL: CREATE VIEW',
  'https://www.postgresql.org/docs/current/sql-createview.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/sql-createview.html' ORDER BY id LIMIT 1),
  'medio',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 26 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'Uma cópia física de uma tabela', false),
    (1, 'Um tipo especial de índice', false),
    (2, 'Um backup agendado', false),
    (3, 'Uma consulta salva com nome, usada como se fosse uma tabela', true)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 26 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 26, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 26 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 26 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  27,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Modelagem e DDL'),
  'Segundo a Primeira Forma Normal (1FN), o que cada coluna de uma tabela deve conter?',
  'A 1FN exige valores atômicos (indivisíveis) em cada célula: nada de listas de valores na mesma coluna nem colunas repetidas, como `telefone1`, `telefone2` e `telefone3`. É o primeiro passo da normalização, que reduz a redundância dos dados.',
  'Wikipedia: First normal form',
  'https://en.wikipedia.org/wiki/First_normal_form',
  (SELECT id FROM fontes WHERE url = 'https://en.wikipedia.org/wiki/First_normal_form' ORDER BY id LIMIT 1),
  'medio',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 27 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'Apenas valores numéricos', false),
    (1, 'Valores atômicos, sem listas nem grupos repetidos', true),
    (2, 'Referências a outras tabelas', false),
    (3, 'Valores calculados a partir de outras colunas', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 27 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 27, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 27 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 27 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  28,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Transações'),
  'Na sigla ACID, qual propriedade garante que, depois do `COMMIT`, os dados continuam gravados mesmo que o sistema falhe?',
  'A Durabilidade garante que uma transação confirmada não seja perdida, mesmo após queda de energia ou travamento. As outras: Atomicidade (tudo ou nada), Consistência (as regras do banco continuam válidas) e Isolamento (transações simultâneas não interferem entre si).',
  'Wikipedia: ACID',
  'https://en.wikipedia.org/wiki/ACID',
  (SELECT id FROM fontes WHERE url = 'https://en.wikipedia.org/wiki/ACID' ORDER BY id LIMIT 1),
  'medio',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 28 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'Atomicidade', false),
    (1, 'Durabilidade', true),
    (2, 'Consistência', false),
    (3, 'Isolamento', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 28 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 28, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 28 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 28 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  29,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Ferramentas'),
  'No pgAdmin, qual ferramenta permite desenhar e visualizar o diagrama entidade-relacionamento (ERD) de um banco de dados?',
  'O ERD Tool do pgAdmin desenha diagramas entidade-relacionamento: dá para criar tabelas visualmente ou gerar o diagrama a partir de um banco existente, e até gerar o SQL do desenho. O Schema Diff compara esquemas, o Debugger depura funções e o Grant Wizard concede permissões em lote.',
  'Documentação do pgAdmin: ERD Tool',
  'https://www.pgadmin.org/docs/pgadmin4/latest/erd_tool.html',
  (SELECT id FROM fontes WHERE url = 'https://www.pgadmin.org/docs/pgadmin4/latest/erd_tool.html' ORDER BY id LIMIT 1),
  'medio',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 29 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'Schema Diff', false),
    (1, 'ERD Tool', true),
    (2, 'Debugger', false),
    (3, 'Grant Wizard', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 29 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 29, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 29 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 29 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  30,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Transações'),
  'Para que serve o comando `SAVEPOINT` dentro de uma transação?',
  '`SAVEPOINT` marca um ponto dentro da transação. Com `ROLLBACK TO SAVEPOINT` desfazem-se apenas os comandos executados depois dele, e o que veio antes continua valendo até o `COMMIT` ou o `ROLLBACK` final.',
  'Documentação do PostgreSQL: SAVEPOINT',
  'https://www.postgresql.org/docs/current/sql-savepoint.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/sql-savepoint.html' ORDER BY id LIMIT 1),
  'medio',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 30 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'Confirmar a transação definitivamente', false),
    (1, 'Criar uma cópia de segurança do banco', false),
    (2, 'Bloquear a tabela para outros usuários', false),
    (3, 'Marcar um ponto ao qual é possível voltar sem desfazer a transação inteira', true)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 30 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 30, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 30 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 30 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  31,
  (SELECT id FROM categorias_perguntas WHERE nome = 'PostgreSQL'),
  'Qual tipo o PostgreSQL recomenda, na maioria dos casos, para guardar dados JSON com suporte a índices e consultas mais rápidas?',
  'O `jsonb` guarda o JSON em formato binário decomposto: a gravação é um pouco mais lenta, mas as consultas são bem mais rápidas e ele aceita índices (como o GIN). O `json` guarda o texto exato, preservando espaços e a ordem das chaves.',
  'Documentação do PostgreSQL: JSON Types',
  'https://www.postgresql.org/docs/current/datatype-json.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/datatype-json.html' ORDER BY id LIMIT 1),
  'medio',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 31 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`json`', false),
    (1, '`text`', false),
    (2, '`jsonb`', true),
    (3, '`xml`', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 31 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 31, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 31 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 31 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  32,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL'),
  'Qual operador do PostgreSQL faz busca por padrão ignorando a diferença entre maiúsculas e minúsculas?',
  '`ILIKE` funciona como o `LIKE`, mas sem diferenciar maiúsculas de minúsculas, por exemplo `nome ILIKE ''ana%''`. É uma extensão do PostgreSQL. O `LIKE` diferencia maiúsculas de minúsculas.',
  'Documentação do PostgreSQL: Pattern Matching',
  'https://www.postgresql.org/docs/current/functions-matching.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/functions-matching.html' ORDER BY id LIMIT 1),
  'medio',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 32 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`LIKE`', false),
    (1, '`ILIKE`', true),
    (2, '`SIMILAR`', false),
    (3, '`MATCHES`', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 32 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 32, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 32 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 32 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  33,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Desempenho'),
  'Qual tipo de índice do PostgreSQL é indicado para colunas `jsonb` e arrays, em buscas do tipo ''contém''?',
  'O GIN (Generalized Inverted Index) indexa valores compostos, como arrays e `jsonb`, e atende bem a operadores como `@>` (contém). O B-tree é o padrão para comparações simples, o Hash serve para igualdade e o BRIN para tabelas enormes com dados em ordem física.',
  'Documentação do PostgreSQL: Index Types',
  'https://www.postgresql.org/docs/current/indexes-types.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/indexes-types.html' ORDER BY id LIMIT 1),
  'dificil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 33 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'B-tree', false),
    (1, 'Hash', false),
    (2, 'BRIN', false),
    (3, 'GIN', true)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 33 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 33, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 33 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 33 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  34,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Transações'),
  'Qual mecanismo permite que, no PostgreSQL, leitores e escritores não se bloqueiem, mantendo várias versões das mesmas linhas?',
  'No MVCC (Multiversion Concurrency Control), cada transação enxerga um instantâneo (snapshot) dos dados, e as alterações criam novas versões das linhas. Por isso leituras não bloqueiam escritas, e escritas não bloqueiam leituras. As versões antigas são limpas depois pelo `VACUUM`.',
  'Documentação do PostgreSQL: Introduction (MVCC)',
  'https://www.postgresql.org/docs/current/mvcc-intro.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/mvcc-intro.html' ORDER BY id LIMIT 1),
  'dificil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 34 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'Sharding', false),
    (1, 'MVCC', true),
    (2, 'Two-phase locking', false),
    (3, 'Write-through cache', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 34 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 34, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 34 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 34 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  35,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Transações'),
  'Qual é o menor nível de isolamento do PostgreSQL em que repetir uma consulta na mesma transação sempre devolve os mesmos dados?',
  'No `REPEATABLE READ`, a transação usa o snapshot tirado no início da primeira consulta, então repetições enxergam os mesmos dados. No `READ COMMITTED` cada comando tira um novo snapshot, e o `READ UNCOMMITTED` se comporta como `READ COMMITTED`. O `SERIALIZABLE` também garante isso, mas é um nível acima.',
  'Documentação do PostgreSQL: Transaction Isolation',
  'https://www.postgresql.org/docs/current/transaction-iso.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/transaction-iso.html' ORDER BY id LIMIT 1),
  'dificil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 35 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`READ COMMITTED`', false),
    (1, '`READ UNCOMMITTED`', false),
    (2, '`SERIALIZABLE`', false),
    (3, '`REPEATABLE READ`', true)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 35 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 35, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 35 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 35 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  36,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Transações'),
  'Como se chama a situação em que duas transações esperam uma pela outra, cada uma segurando um bloqueio de que a outra precisa?',
  'Isso é um deadlock (impasse). O PostgreSQL detecta a situação automaticamente e cancela uma das transações para as outras poderem continuar. A boa prática é acessar tabelas e linhas sempre na mesma ordem, o que reduz a chance de deadlocks.',
  'Documentação do PostgreSQL: Explicit Locking',
  'https://www.postgresql.org/docs/current/explicit-locking.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/explicit-locking.html' ORDER BY id LIMIT 1),
  'dificil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 36 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'Livelock', false),
    (1, 'Dirty read', false),
    (2, 'Phantom read', false),
    (3, 'Deadlock', true)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 36 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 36, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 36 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 36 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  37,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Desempenho'),
  'O que é um índice parcial (`partial index`) no PostgreSQL?',
  'Um índice parcial é criado com uma cláusula `WHERE` e indexa apenas as linhas que atendem a ela, por exemplo `CREATE INDEX ON pedidos (cliente_id) WHERE status = ''aberto''`. Ele fica menor e mais barato de manter, e é útil quando as consultas olham sempre para o mesmo subconjunto dos dados.',
  'Documentação do PostgreSQL: Partial Indexes',
  'https://www.postgresql.org/docs/current/indexes-partial.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/indexes-partial.html' ORDER BY id LIMIT 1),
  'dificil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 37 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'Um índice que cobre apenas a primeira coluna de uma chave composta', false),
    (1, 'Um índice criado só sobre as linhas que satisfazem uma condição `WHERE`', true),
    (2, 'Um índice reconstruído aos poucos em segundo plano', false),
    (3, 'Um índice que guarda só parte do valor de cada coluna', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 37 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 37, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 37 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 37 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  38,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Desempenho'),
  'Qual cláusula do `CREATE INDEX` permite guardar colunas extras no índice, ajudando a evitar o acesso à tabela (index-only scan)?',
  'Com `INCLUDE` (PostgreSQL 11 ou superior), colunas adicionais ficam armazenadas no índice, mas não fazem parte da chave de busca. Assim, uma consulta pode ser respondida só com o índice (index-only scan), no chamado índice de cobertura.',
  'Documentação do PostgreSQL: Index-Only Scans and Covering Indexes',
  'https://www.postgresql.org/docs/current/indexes-index-only-scans.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/indexes-index-only-scans.html' ORDER BY id LIMIT 1),
  'dificil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 38 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`WITH`', false),
    (1, '`COVER`', false),
    (2, '`EXTEND`', false),
    (3, '`INCLUDE`', true)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 38 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 38, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 38 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 38 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  39,
  (SELECT id FROM categorias_perguntas WHERE nome = 'PostgreSQL'),
  'Qual é a principal função do WAL (Write-Ahead Log) no PostgreSQL?',
  'No WAL (log de escrita antecipada), toda alteração é registrada em um log antes de ser aplicada aos arquivos de dados. Se o servidor cair, o PostgreSQL refaz o que estava no log e volta a um estado consistente. O WAL também é a base da replicação e do backup contínuo.',
  'Documentação do PostgreSQL: Write-Ahead Logging (WAL)',
  'https://www.postgresql.org/docs/current/wal-intro.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/wal-intro.html' ORDER BY id LIMIT 1),
  'dificil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 39 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'Guardar as consultas mais lentas para análise', false),
    (1, 'Registrar as alterações em um log antes de gravá-las nos arquivos de dados, permitindo recuperação após falhas', true),
    (2, 'Compactar as tabelas para economizar espaço', false),
    (3, 'Criptografar os dados em disco', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 39 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 39, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 39 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 39 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  40,
  (SELECT id FROM categorias_perguntas WHERE nome = 'Ferramentas'),
  'Qual formato do `pg_dump` gera um script SQL em texto puro, que é restaurado com o `psql`?',
  'O formato `plain` gera um arquivo de texto com comandos SQL, que pode ser executado com o `psql`. Os formatos `custom`, `directory` e `tar` são restaurados com o `pg_restore`, que permite, entre outras coisas, restaurar só algumas tabelas.',
  'Documentação do PostgreSQL: pg_dump',
  'https://www.postgresql.org/docs/current/app-pgdump.html',
  (SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/app-pgdump.html' ORDER BY id LIMIT 1),
  'dificil',
  FALSE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 40 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, '`custom` (`-Fc`)', false),
    (1, '`directory` (`-Fd`)', false),
    (2, '`tar` (`-Ft`)', false),
    (3, '`plain` (`-Fp`)', true)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 40 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 40, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 40 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 40 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  41,
  (SELECT id FROM categorias_perguntas WHERE nome = 'História da tecnologia'),
  'Qual máquina é amplamente considerada o primeiro computador digital eletrônico de propósito geral e em qual década ela foi operacionalizada?',
  'O ENIAC foi construído durante a Segunda Guerra Mundial e apresentado ao público em fevereiro de 1946, na Universidade da Pensilvânia, ou seja, entrou em operação na década de 1940. Projetado por John Mauchly e J. Presper Eckert, é considerado o primeiro computador digital eletrônico de propósito geral.',
  'Penn Today',
  'https://penntoday.upenn.edu/news/worlds-first-general-purpose-computer-turns-75',
  (SELECT id FROM fontes WHERE url = 'https://penntoday.upenn.edu/news/worlds-first-general-purpose-computer-turns-75' ORDER BY id LIMIT 1),
  'medio',
  TRUE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 41 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'ENIAC', true),
    (1, 'Colossus', false),
    (2, 'Z3', false),
    (3, 'ABC', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 41 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 41, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 41 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 41 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  42,
  (SELECT id FROM categorias_perguntas WHERE nome = 'História da tecnologia'),
  'Quem inventou a World Wide Web (WWW) no laboratório do CERN em 1989?',
  'Tim Berners-Lee escreveu a primeira proposta da Web em março de 1989, quando trabalhava no CERN, e no fim de 1990 já tinha o primeiro servidor e navegador funcionando. Linus Torvalds criou o Linux, Marc Andreessen foi um dos criadores do navegador Mosaic e Richard Stallman fundou o projeto GNU.',
  'CERN',
  'https://home.cern/science/computing/the-birth-of-the-web/short-history-web/',
  (SELECT id FROM fontes WHERE url = 'https://home.cern/science/computing/the-birth-of-the-web/short-history-web/' ORDER BY id LIMIT 1),
  'facil',
  TRUE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 42 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'Linus Torvalds', false),
    (1, 'Marc Andreessen', false),
    (2, 'Tim Berners-Lee', true),
    (3, 'Richard Stallman', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 42 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 42, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 42 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 42 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  43,
  (SELECT id FROM categorias_perguntas WHERE nome = 'História da tecnologia'),
  'Qual opção Tim Berners-Lee não criou?',
  'Tim Berners-Lee criou o HTML, o protocolo HTTP e o sistema de endereços (URL). O CSS veio depois: foi proposto em 1994 por Håkon Wium Lie, que trabalhava com ele no CERN, para separar o conteúdo da página da sua aparência.',
  'InfoEscola',
  'https://www.infoescola.com/informatica/cascading-style-sheets-css/',
  (SELECT id FROM fontes WHERE url = 'https://www.infoescola.com/informatica/cascading-style-sheets-css/' ORDER BY id LIMIT 1),
  'medio',
  TRUE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 43 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'HTTP', false),
    (1, 'HTML', false),
    (2, 'CSS', true),
    (3, 'URL', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 43 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 43, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 43 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 43 AND posicao_pergunta NOT IN (0, 1, 2, 3);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  44,
  (SELECT id FROM categorias_perguntas WHERE nome = 'História da tecnologia'),
  'O termo "bug" na computação se popularizou quando Grace Hopper documentou uma lagartixa real presa em um relé do computador Harvard Mark II. Essa afirmação é verdadeira ou falsa?',
  'Falsa. O inseto encontrado em 9 de setembro de 1947 no Harvard Mark II era uma mariposa, e não uma lagartixa. Ela foi colada no diário de operações da equipe. O termo "bug" já era usado para falhas técnicas antes disso; o episódio ficou famoso e Grace Hopper ajudou a divulgar a história.',
  'Educa Mais Brasil',
  'https://www.educamaisbrasil.com.br/educacao/dicas/o-que-e-bug-qual-a-origem-da-expressao',
  (SELECT id FROM fontes WHERE url = 'https://www.educamaisbrasil.com.br/educacao/dicas/o-que-e-bug-qual-a-origem-da-expressao' ORDER BY id LIMIT 1),
  'dificil',
  TRUE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 44 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'Falsa', true),
    (1, 'Verdadeira', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 44 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 44, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 44 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 44 AND posicao_pergunta NOT IN (0, 1);

INSERT INTO questao_quiz (id, categoria_id, pergunta, explicacao, nome_fonte, url_fonte, fonte_id, dificuldade_pergunta, pergunta_bonus)
VALUES (
  45,
  (SELECT id FROM categorias_perguntas WHERE nome = 'História da tecnologia'),
  'Qual o primeiro vírus de computador da história geral da tecnologia?',
  'O Creeper foi criado em 1971 por Bob Thomas, como um experimento: um programa que passava de computador em computador na ARPANET exibindo uma mensagem provocativa. Depois surgiu o Reaper, feito para removê-lo. O Brain, de 1986, é considerado o primeiro vírus para PCs.',
  'CyberSec Brasil',
  'https://www.cybersecbrazil.com.br/post/o-creeper-o-primeiro-v%C3%ADrus-de-computador-da-hist%C3%B3ria',
  (SELECT id FROM fontes WHERE url = 'https://www.cybersecbrazil.com.br/post/o-creeper-o-primeiro-v%C3%ADrus-de-computador-da-hist%C3%B3ria' ORDER BY id LIMIT 1),
  'dificil',
  TRUE
)
ON CONFLICT (id) DO UPDATE SET
  categoria_id         = EXCLUDED.categoria_id,
  pergunta             = EXCLUDED.pergunta,
  explicacao           = EXCLUDED.explicacao,
  nome_fonte           = EXCLUDED.nome_fonte,
  url_fonte            = EXCLUDED.url_fonte,
  fonte_id             = EXCLUDED.fonte_id,
  dificuldade_pergunta = EXCLUDED.dificuldade_pergunta,
  pergunta_bonus       = EXCLUDED.pergunta_bonus,
  ativo                = TRUE;

UPDATE opcoes_perguntas SET esta_correto = FALSE WHERE id_pergunta = 45 AND esta_correto;
WITH v (p, t, c) AS (VALUES
    (0, 'Brain', false),
    (1, 'ILOVEYOU', false),
    (2, 'Creeper', true),
    (3, 'WannaCry', false)
), atualiza AS (
  UPDATE opcoes_perguntas o SET alternativas = v.t, esta_correto = v.c
  FROM v WHERE o.id_pergunta = 45 AND o.posicao_pergunta = v.p
  RETURNING o.id
)
INSERT INTO opcoes_perguntas (id_pergunta, posicao_pergunta, alternativas, esta_correto)
SELECT 45, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 45 AND o.posicao_pergunta = v.p);
DELETE FROM opcoes_perguntas WHERE id_pergunta = 45 AND posicao_pergunta NOT IN (0, 1, 2, 3);

-- Mantém a sequência de ids alinhada com os ids inseridos manualmente.
SELECT setval(pg_get_serial_sequence('questao_quiz', 'id'), (SELECT MAX(id) FROM questao_quiz));
