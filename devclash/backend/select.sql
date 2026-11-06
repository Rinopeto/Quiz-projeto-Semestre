-- DEVCLASH - TODOS OS SELECTS DO PROJETO
-- Banco: PostgreSQL
-- Origem: backend/seed.sql e backend/src/app.js
--
-- Compilação de todos os 196 SELECTs usados como comandos SQL reais,
-- considerando os SELECTs aninhados dentro de outras instruções.
-- Inclui repetições necessárias para mostrar todas as 45 questões.
--
-- Este arquivo não contém INSERT, UPDATE ou DELETE executáveis.
-- SELECT setval(...) aparece ao final da seção do seed, comentado,
-- pois modifica o valor de uma sequência do banco.
--
-- As consultas da API usavam parâmetros $1 / $2.
-- Para testar diretamente no pgAdmin, foram substituídos por exemplos
-- conforme indicado em cada consulta; a lógica dos SELECTs foi preservada.
--
-- As consultas montadas a partir de INSERTs usam somente os SELECTs
-- originais. As consultas das opções usam a CTE VALUES sem o UPDATE
-- original; por isso apenas mostram linhas ainda não cadastradas.
-- Nenhum comando deve alterar tabelas ou registros do banco.
-- Textos decorativos, enunciados do quiz e comentários que apenas
-- mencionam SELECT não foram considerados consultas do banco.
--
-- Conteúdo: 2 consultas de carga inicial (4 SELECTs), 45 blocos de perguntas
-- (180 SELECTs), 1 consulta de sequência (2 SELECTs, comentada),
-- e 6 consultas da API (10 SELECTs).
-- ============================================================================

-- PARTE 1 - CONSULTAS DO SEED (READ-ONLY)

-- Carga de categorias (SELECT separado do INSERT)
-- Origem: backend/seed.sql:5
-- Inclui a subconsulta NOT EXISTS; nenhuma linha é inserida por este arquivo.
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

-- Carga de fontes (SELECT separado do INSERT)
-- Origem: backend/seed.sql:19
-- Inclui a subconsulta NOT EXISTS; nenhuma linha é inserida por este arquivo.
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

-- ============================================================================
-- QUESTÃO 1
-- ============================================================================

-- Questão 1: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:69
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Modelagem e DDL';

-- Questão 1: busca de ID em fontes
-- Origem: backend/seed.sql:74
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/ddl-constraints.html' ORDER BY id LIMIT 1;

-- Questão 1: alternativas que ainda não existem
-- Origem: backend/seed.sql:101
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`PRIMARY KEY`', true),
    (1, '`FOREIGN KEY`', false),
    (2, '`CHECK`', false),
    (3, '`DEFAULT`', false)
)
SELECT 1, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 1 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 2
-- ============================================================================

-- Questão 2: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:108
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Modelagem e DDL';

-- Questão 2: busca de ID em fontes
-- Origem: backend/seed.sql:113
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/ddl-basics.html' ORDER BY id LIMIT 1;

-- Questão 2: alternativas que ainda não existem
-- Origem: backend/seed.sql:140
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`DROP TABLE`', true),
    (1, '`TRUNCATE`', false),
    (2, '`DELETE`', false),
    (3, '`ALTER TABLE`', false)
)
SELECT 2, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 2 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 3
-- ============================================================================

-- Questão 3: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:147
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Ferramentas';

-- Questão 3: busca de ID em fontes
-- Origem: backend/seed.sql:152
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.pgadmin.org/' ORDER BY id LIMIT 1;

-- Questão 3: alternativas que ainda não existem
-- Origem: backend/seed.sql:179
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'pgAdmin', true),
    (1, 'phpMyAdmin', false),
    (2, 'SQL Server Management Studio', false),
    (3, 'MongoDB Compass', false)
)
SELECT 3, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 3 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 4
-- ============================================================================

-- Questão 4: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:186
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL';

-- Questão 4: busca de ID em fontes
-- Origem: backend/seed.sql:191
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/tutorial-agg.html' ORDER BY id LIMIT 1;

-- Questão 4: alternativas que ainda não existem
-- Origem: backend/seed.sql:218
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`HAVING`', true),
    (1, '`WHERE`', false),
    (2, '`ORDER BY`', false),
    (3, '`LIMIT`', false)
)
SELECT 4, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 4 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 5
-- ============================================================================

-- Questão 5: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:225
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL';

-- Questão 5: busca de ID em fontes
-- Origem: backend/seed.sql:230
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/tutorial-join.html' ORDER BY id LIMIT 1;

-- Questão 5: alternativas que ainda não existem
-- Origem: backend/seed.sql:257
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`LEFT JOIN`', true),
    (1, '`INNER JOIN`', false),
    (2, '`RIGHT JOIN`', false),
    (3, '`CROSS JOIN`', false)
)
SELECT 5, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 5 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 6
-- ============================================================================

-- Questão 6: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:264
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL';

-- Questão 6: busca de ID em fontes
-- Origem: backend/seed.sql:269
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/functions-comparison.html' ORDER BY id LIMIT 1;

-- Questão 6: alternativas que ainda não existem
-- Origem: backend/seed.sql:296
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`NULL`', true),
    (1, '`TRUE`', false),
    (2, '`FALSE`', false),
    (3, 'Erro de sintaxe', false)
)
SELECT 6, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 6 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 7
-- ============================================================================

-- Questão 7: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:303
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'PostgreSQL';

-- Questão 7: busca de ID em fontes
-- Origem: backend/seed.sql:308
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/indexes-types.html' ORDER BY id LIMIT 1;

-- Questão 7: alternativas que ainda não existem
-- Origem: backend/seed.sql:335
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'B-tree', true),
    (1, 'Hash', false),
    (2, 'GiST', false),
    (3, 'GIN', false)
)
SELECT 7, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 7 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 8
-- ============================================================================

-- Questão 8: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:342
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Transações';

-- Questão 8: busca de ID em fontes
-- Origem: backend/seed.sql:347
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/sql-set-transaction.html' ORDER BY id LIMIT 1;

-- Questão 8: alternativas que ainda não existem
-- Origem: backend/seed.sql:374
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`READ COMMITTED`', true),
    (1, '`READ UNCOMMITTED`', false),
    (2, '`REPEATABLE READ`', false),
    (3, '`SERIALIZABLE`', false)
)
SELECT 8, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 8 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 9
-- ============================================================================

-- Questão 9: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:381
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Desempenho';

-- Questão 9: busca de ID em fontes
-- Origem: backend/seed.sql:386
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/using-explain.html' ORDER BY id LIMIT 1;

-- Questão 9: alternativas que ainda não existem
-- Origem: backend/seed.sql:413
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`EXPLAIN ANALYZE`', true),
    (1, '`EXPLAIN`', false),
    (2, '`DESCRIBE`', false),
    (3, '`SHOW PLAN`', false)
)
SELECT 9, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 9 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 10
-- ============================================================================

-- Questão 10: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:420
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'PostgreSQL';

-- Questão 10: busca de ID em fontes
-- Origem: backend/seed.sql:425
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/routine-vacuuming.html' ORDER BY id LIMIT 1;

-- Questão 10: alternativas que ainda não existem
-- Origem: backend/seed.sql:452
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`VACUUM`', true),
    (1, '`TRUNCATE`', false),
    (2, '`REINDEX`', false),
    (3, '`ANALYZE`', false)
)
SELECT 10, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 10 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 11
-- ============================================================================

-- Questão 11: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:459
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Fundamentos de SQL';

-- Questão 11: busca de ID em fontes
-- Origem: backend/seed.sql:464
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://pt.wikipedia.org/wiki/SQL' ORDER BY id LIMIT 1;

-- Questão 11: alternativas que ainda não existem
-- Origem: backend/seed.sql:491
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'Standard Question Language', false),
    (1, 'Simple Query Logic', false),
    (2, 'Structured Query Language', true),
    (3, 'Sequential Query Layer', false)
)
SELECT 11, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 11 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 12
-- ============================================================================

-- Questão 12: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:498
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Fundamentos de SQL';

-- Questão 12: busca de ID em fontes
-- Origem: backend/seed.sql:503
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/dml-insert.html' ORDER BY id LIMIT 1;

-- Questão 12: alternativas que ainda não existem
-- Origem: backend/seed.sql:530
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`ADD ROW`', false),
    (1, '`INSERT INTO`', true),
    (2, '`APPEND`', false),
    (3, '`CREATE ROW`', false)
)
SELECT 12, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 12 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 13
-- ============================================================================

-- Questão 13: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:537
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL';

-- Questão 13: busca de ID em fontes
-- Origem: backend/seed.sql:542
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/queries-order.html' ORDER BY id LIMIT 1;

-- Questão 13: alternativas que ainda não existem
-- Origem: backend/seed.sql:569
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`GROUP BY`', false),
    (1, '`SORT BY`', false),
    (2, '`ORDER BY`', true),
    (3, '`ARRANGE BY`', false)
)
SELECT 13, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 13 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 14
-- ============================================================================

-- Questão 14: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:576
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Fundamentos de SQL';

-- Questão 14: busca de ID em fontes
-- Origem: backend/seed.sql:581
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/dml-update.html' ORDER BY id LIMIT 1;

-- Questão 14: alternativas que ainda não existem
-- Origem: backend/seed.sql:608
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`MODIFY`', false),
    (1, '`CHANGE`', false),
    (2, '`UPDATE`', true),
    (3, '`ALTER`', false)
)
SELECT 14, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 14 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 15
-- ============================================================================

-- Questão 15: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:615
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL';

-- Questão 15: busca de ID em fontes
-- Origem: backend/seed.sql:620
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/functions-aggregate.html' ORDER BY id LIMIT 1;

-- Questão 15: alternativas que ainda não existem
-- Origem: backend/seed.sql:647
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`COUNT`', true),
    (1, '`SUM`', false),
    (2, '`TOTAL`', false),
    (3, '`LEN`', false)
)
SELECT 15, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 15 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 16
-- ============================================================================

-- Questão 16: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:654
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL';

-- Questão 16: busca de ID em fontes
-- Origem: backend/seed.sql:659
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/queries-select-lists.html' ORDER BY id LIMIT 1;

-- Questão 16: alternativas que ainda não existem
-- Origem: backend/seed.sql:686
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`SINGLE`', false),
    (1, '`NOREPEAT`', false),
    (2, '`DISTINCT`', true),
    (3, '`LIMIT`', false)
)
SELECT 16, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 16 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 17
-- ============================================================================

-- Questão 17: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:693
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Ferramentas';

-- Questão 17: busca de ID em fontes
-- Origem: backend/seed.sql:698
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.pgadmin.org/docs/pgadmin4/latest/query_tool.html' ORDER BY id LIMIT 1;

-- Questão 17: alternativas que ainda não existem
-- Origem: backend/seed.sql:725
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'ERD Tool', false),
    (1, 'Grant Wizard', false),
    (2, 'Schema Diff', false),
    (3, 'Query Tool', true)
)
SELECT 17, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 17 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 18
-- ============================================================================

-- Questão 18: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:732
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'PostgreSQL';

-- Questão 18: busca de ID em fontes
-- Origem: backend/seed.sql:737
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/runtime-config-connection.html' ORDER BY id LIMIT 1;

-- Questão 18: alternativas que ainda não existem
-- Origem: backend/seed.sql:764
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '3306', false),
    (1, '1433', false),
    (2, '5432', true),
    (3, '27017', false)
)
SELECT 18, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 18 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 19
-- ============================================================================

-- Questão 19: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:771
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL';

-- Questão 19: busca de ID em fontes
-- Origem: backend/seed.sql:776
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/queries-union.html' ORDER BY id LIMIT 1;

-- Questão 19: alternativas que ainda não existem
-- Origem: backend/seed.sql:803
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`UNION`', false),
    (1, '`INTERSECT`', false),
    (2, '`EXCEPT`', false),
    (3, '`UNION ALL`', true)
)
SELECT 19, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 19 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 20
-- ============================================================================

-- Questão 20: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:810
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL';

-- Questão 20: busca de ID em fontes
-- Origem: backend/seed.sql:815
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/functions-conditional.html' ORDER BY id LIMIT 1;

-- Questão 20: alternativas que ainda não existem
-- Origem: backend/seed.sql:842
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'O primeiro argumento que não for `NULL`', true),
    (1, 'O maior valor entre os argumentos', false),
    (2, 'A concatenação de todos os argumentos', false),
    (3, 'A quantidade de argumentos nulos', false)
)
SELECT 20, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 20 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 21
-- ============================================================================

-- Questão 21: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:849
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL';

-- Questão 21: busca de ID em fontes
-- Origem: backend/seed.sql:854
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/queries-with.html' ORDER BY id LIMIT 1;

-- Questão 21: alternativas que ainda não existem
-- Origem: backend/seed.sql:881
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`TEMP`', false),
    (1, '`WITH`', true),
    (2, '`DEFINE`', false),
    (3, '`USING`', false)
)
SELECT 21, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 21 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 22
-- ============================================================================

-- Questão 22: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:888
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL';

-- Questão 22: busca de ID em fontes
-- Origem: backend/seed.sql:893
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/functions-window.html' ORDER BY id LIMIT 1;

-- Questão 22: alternativas que ainda não existem
-- Origem: backend/seed.sql:920
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`LAG()`', false),
    (1, '`SUM()`', false),
    (2, '`COUNT()`', false),
    (3, '`ROW_NUMBER()`', true)
)
SELECT 22, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 22 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 23
-- ============================================================================

-- Questão 23: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:927
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Modelagem e DDL';

-- Questão 23: busca de ID em fontes
-- Origem: backend/seed.sql:932
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/ddl-constraints.html' ORDER BY id LIMIT 1;

-- Questão 23: alternativas que ainda não existem
-- Origem: backend/seed.sql:959
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`PRIMARY KEY`', false),
    (1, '`NOT NULL`', false),
    (2, '`UNIQUE`', true),
    (3, '`CHECK`', false)
)
SELECT 23, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 23 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 24
-- ============================================================================

-- Questão 24: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:966
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Modelagem e DDL';

-- Questão 24: busca de ID em fontes
-- Origem: backend/seed.sql:971
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/ddl-constraints.html' ORDER BY id LIMIT 1;

-- Questão 24: alternativas que ainda não existem
-- Origem: backend/seed.sql:998
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'Impede a exclusão da linha referenciada', false),
    (1, 'Define as colunas filhas como `NULL`', false),
    (2, 'Apaga automaticamente as linhas que referenciam a linha excluída', true),
    (3, 'Copia a linha excluída para uma tabela de histórico', false)
)
SELECT 24, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 24 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 25
-- ============================================================================

-- Questão 25: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1005
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Modelagem e DDL';

-- Questão 25: busca de ID em fontes
-- Origem: backend/seed.sql:1010
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/sql-truncate.html' ORDER BY id LIMIT 1;

-- Questão 25: alternativas que ainda não existem
-- Origem: backend/seed.sql:1037
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`TRUNCATE`', true),
    (1, '`DROP TABLE`', false),
    (2, '`DELETE`', false),
    (3, '`VACUUM`', false)
)
SELECT 25, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 25 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 26
-- ============================================================================

-- Questão 26: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1044
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Modelagem e DDL';

-- Questão 26: busca de ID em fontes
-- Origem: backend/seed.sql:1049
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/sql-createview.html' ORDER BY id LIMIT 1;

-- Questão 26: alternativas que ainda não existem
-- Origem: backend/seed.sql:1076
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'Uma cópia física de uma tabela', false),
    (1, 'Um tipo especial de índice', false),
    (2, 'Um backup agendado', false),
    (3, 'Uma consulta salva com nome, usada como se fosse uma tabela', true)
)
SELECT 26, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 26 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 27
-- ============================================================================

-- Questão 27: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1083
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Modelagem e DDL';

-- Questão 27: busca de ID em fontes
-- Origem: backend/seed.sql:1088
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://en.wikipedia.org/wiki/First_normal_form' ORDER BY id LIMIT 1;

-- Questão 27: alternativas que ainda não existem
-- Origem: backend/seed.sql:1115
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'Apenas valores numéricos', false),
    (1, 'Valores atômicos, sem listas nem grupos repetidos', true),
    (2, 'Referências a outras tabelas', false),
    (3, 'Valores calculados a partir de outras colunas', false)
)
SELECT 27, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 27 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 28
-- ============================================================================

-- Questão 28: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1122
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Transações';

-- Questão 28: busca de ID em fontes
-- Origem: backend/seed.sql:1127
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://en.wikipedia.org/wiki/ACID' ORDER BY id LIMIT 1;

-- Questão 28: alternativas que ainda não existem
-- Origem: backend/seed.sql:1154
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'Atomicidade', false),
    (1, 'Durabilidade', true),
    (2, 'Consistência', false),
    (3, 'Isolamento', false)
)
SELECT 28, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 28 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 29
-- ============================================================================

-- Questão 29: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1161
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Ferramentas';

-- Questão 29: busca de ID em fontes
-- Origem: backend/seed.sql:1166
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.pgadmin.org/docs/pgadmin4/latest/erd_tool.html' ORDER BY id LIMIT 1;

-- Questão 29: alternativas que ainda não existem
-- Origem: backend/seed.sql:1193
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'Schema Diff', false),
    (1, 'ERD Tool', true),
    (2, 'Debugger', false),
    (3, 'Grant Wizard', false)
)
SELECT 29, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 29 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 30
-- ============================================================================

-- Questão 30: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1200
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Transações';

-- Questão 30: busca de ID em fontes
-- Origem: backend/seed.sql:1205
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/sql-savepoint.html' ORDER BY id LIMIT 1;

-- Questão 30: alternativas que ainda não existem
-- Origem: backend/seed.sql:1232
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'Confirmar a transação definitivamente', false),
    (1, 'Criar uma cópia de segurança do banco', false),
    (2, 'Bloquear a tabela para outros usuários', false),
    (3, 'Marcar um ponto ao qual é possível voltar sem desfazer a transação inteira', true)
)
SELECT 30, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 30 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 31
-- ============================================================================

-- Questão 31: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1239
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'PostgreSQL';

-- Questão 31: busca de ID em fontes
-- Origem: backend/seed.sql:1244
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/datatype-json.html' ORDER BY id LIMIT 1;

-- Questão 31: alternativas que ainda não existem
-- Origem: backend/seed.sql:1271
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`json`', false),
    (1, '`text`', false),
    (2, '`jsonb`', true),
    (3, '`xml`', false)
)
SELECT 31, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 31 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 32
-- ============================================================================

-- Questão 32: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1278
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Consultas SQL';

-- Questão 32: busca de ID em fontes
-- Origem: backend/seed.sql:1283
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/functions-matching.html' ORDER BY id LIMIT 1;

-- Questão 32: alternativas que ainda não existem
-- Origem: backend/seed.sql:1310
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`LIKE`', false),
    (1, '`ILIKE`', true),
    (2, '`SIMILAR`', false),
    (3, '`MATCHES`', false)
)
SELECT 32, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 32 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 33
-- ============================================================================

-- Questão 33: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1317
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Desempenho';

-- Questão 33: busca de ID em fontes
-- Origem: backend/seed.sql:1322
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/indexes-types.html' ORDER BY id LIMIT 1;

-- Questão 33: alternativas que ainda não existem
-- Origem: backend/seed.sql:1349
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'B-tree', false),
    (1, 'Hash', false),
    (2, 'BRIN', false),
    (3, 'GIN', true)
)
SELECT 33, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 33 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 34
-- ============================================================================

-- Questão 34: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1356
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Transações';

-- Questão 34: busca de ID em fontes
-- Origem: backend/seed.sql:1361
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/mvcc-intro.html' ORDER BY id LIMIT 1;

-- Questão 34: alternativas que ainda não existem
-- Origem: backend/seed.sql:1388
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'Sharding', false),
    (1, 'MVCC', true),
    (2, 'Two-phase locking', false),
    (3, 'Write-through cache', false)
)
SELECT 34, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 34 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 35
-- ============================================================================

-- Questão 35: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1395
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Transações';

-- Questão 35: busca de ID em fontes
-- Origem: backend/seed.sql:1400
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/transaction-iso.html' ORDER BY id LIMIT 1;

-- Questão 35: alternativas que ainda não existem
-- Origem: backend/seed.sql:1427
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`READ COMMITTED`', false),
    (1, '`READ UNCOMMITTED`', false),
    (2, '`SERIALIZABLE`', false),
    (3, '`REPEATABLE READ`', true)
)
SELECT 35, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 35 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 36
-- ============================================================================

-- Questão 36: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1434
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Transações';

-- Questão 36: busca de ID em fontes
-- Origem: backend/seed.sql:1439
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/explicit-locking.html' ORDER BY id LIMIT 1;

-- Questão 36: alternativas que ainda não existem
-- Origem: backend/seed.sql:1466
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'Livelock', false),
    (1, 'Dirty read', false),
    (2, 'Phantom read', false),
    (3, 'Deadlock', true)
)
SELECT 36, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 36 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 37
-- ============================================================================

-- Questão 37: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1473
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Desempenho';

-- Questão 37: busca de ID em fontes
-- Origem: backend/seed.sql:1478
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/indexes-partial.html' ORDER BY id LIMIT 1;

-- Questão 37: alternativas que ainda não existem
-- Origem: backend/seed.sql:1505
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'Um índice que cobre apenas a primeira coluna de uma chave composta', false),
    (1, 'Um índice criado só sobre as linhas que satisfazem uma condição `WHERE`', true),
    (2, 'Um índice reconstruído aos poucos em segundo plano', false),
    (3, 'Um índice que guarda só parte do valor de cada coluna', false)
)
SELECT 37, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 37 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 38
-- ============================================================================

-- Questão 38: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1512
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Desempenho';

-- Questão 38: busca de ID em fontes
-- Origem: backend/seed.sql:1517
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/indexes-index-only-scans.html' ORDER BY id LIMIT 1;

-- Questão 38: alternativas que ainda não existem
-- Origem: backend/seed.sql:1544
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`WITH`', false),
    (1, '`COVER`', false),
    (2, '`EXTEND`', false),
    (3, '`INCLUDE`', true)
)
SELECT 38, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 38 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 39
-- ============================================================================

-- Questão 39: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1551
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'PostgreSQL';

-- Questão 39: busca de ID em fontes
-- Origem: backend/seed.sql:1556
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/wal-intro.html' ORDER BY id LIMIT 1;

-- Questão 39: alternativas que ainda não existem
-- Origem: backend/seed.sql:1583
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'Guardar as consultas mais lentas para análise', false),
    (1, 'Registrar as alterações em um log antes de gravá-las nos arquivos de dados, permitindo recuperação após falhas', true),
    (2, 'Compactar as tabelas para economizar espaço', false),
    (3, 'Criptografar os dados em disco', false)
)
SELECT 39, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 39 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 40
-- ============================================================================

-- Questão 40: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1590
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'Ferramentas';

-- Questão 40: busca de ID em fontes
-- Origem: backend/seed.sql:1595
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.postgresql.org/docs/current/app-pgdump.html' ORDER BY id LIMIT 1;

-- Questão 40: alternativas que ainda não existem
-- Origem: backend/seed.sql:1622
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, '`custom` (`-Fc`)', false),
    (1, '`directory` (`-Fd`)', false),
    (2, '`tar` (`-Ft`)', false),
    (3, '`plain` (`-Fp`)', true)
)
SELECT 40, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 40 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 41
-- ============================================================================

-- Questão 41: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1629
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'História da tecnologia';

-- Questão 41: busca de ID em fontes
-- Origem: backend/seed.sql:1634
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://penntoday.upenn.edu/news/worlds-first-general-purpose-computer-turns-75' ORDER BY id LIMIT 1;

-- Questão 41: alternativas que ainda não existem
-- Origem: backend/seed.sql:1661
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'ENIAC', true),
    (1, 'Colossus', false),
    (2, 'Z3', false),
    (3, 'ABC', false)
)
SELECT 41, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 41 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 42
-- ============================================================================

-- Questão 42: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1668
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'História da tecnologia';

-- Questão 42: busca de ID em fontes
-- Origem: backend/seed.sql:1673
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://home.cern/science/computing/the-birth-of-the-web/short-history-web/' ORDER BY id LIMIT 1;

-- Questão 42: alternativas que ainda não existem
-- Origem: backend/seed.sql:1700
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'Linus Torvalds', false),
    (1, 'Marc Andreessen', false),
    (2, 'Tim Berners-Lee', true),
    (3, 'Richard Stallman', false)
)
SELECT 42, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 42 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 43
-- ============================================================================

-- Questão 43: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1707
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'História da tecnologia';

-- Questão 43: busca de ID em fontes
-- Origem: backend/seed.sql:1712
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.infoescola.com/informatica/cascading-style-sheets-css/' ORDER BY id LIMIT 1;

-- Questão 43: alternativas que ainda não existem
-- Origem: backend/seed.sql:1739
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'HTTP', false),
    (1, 'HTML', false),
    (2, 'CSS', true),
    (3, 'URL', false)
)
SELECT 43, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 43 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 44
-- ============================================================================

-- Questão 44: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1746
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'História da tecnologia';

-- Questão 44: busca de ID em fontes
-- Origem: backend/seed.sql:1751
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.educamaisbrasil.com.br/educacao/dicas/o-que-e-bug-qual-a-origem-da-expressao' ORDER BY id LIMIT 1;

-- Questão 44: alternativas que ainda não existem
-- Origem: backend/seed.sql:1776
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'Falsa', true),
    (1, 'Verdadeira', false)
)
SELECT 44, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 44 AND o.posicao_pergunta = v.p);

-- ============================================================================
-- QUESTÃO 45
-- ============================================================================

-- Questão 45: busca de ID em categorias_perguntas
-- Origem: backend/seed.sql:1783
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM categorias_perguntas WHERE nome = 'História da tecnologia';

-- Questão 45: busca de ID em fontes
-- Origem: backend/seed.sql:1788
-- Subconsulta originalmente usada para preencher uma chave estrangeira.
SELECT id FROM fontes WHERE url = 'https://www.cybersecbrazil.com.br/post/o-creeper-o-primeiro-v%C3%ADrus-de-computador-da-hist%C3%B3ria' ORDER BY id LIMIT 1;

-- Questão 45: alternativas que ainda não existem
-- Origem: backend/seed.sql:1815
-- A CTE de UPDATE foi omitida: esta é somente a parte SELECT, com os VALUES originais.
WITH v (p, t, c) AS (VALUES
    (0, 'Brain', false),
    (1, 'ILOVEYOU', false),
    (2, 'Creeper', true),
    (3, 'WannaCry', false)
)
SELECT 45, v.p, v.t, v.c FROM v
WHERE NOT EXISTS (SELECT 1 FROM opcoes_perguntas o WHERE o.id_pergunta = 45 AND o.posicao_pergunta = v.p);

-- Ajuste da sequência de ID (consulta original, não execute sem necessidade)
-- Origem: backend/seed.sql:1820
-- ATENÇÃO: setval altera a sequência, apesar de estar em um SELECT. Mantido comentado por segurança.
-- SELECT setval(pg_get_serial_sequence('questao_quiz', 'id'), (SELECT MAX(id) FROM questao_quiz));

-- ============================================================================
-- PARTE 2 - CONSULTAS DA API
-- ============================================================================

-- API: perguntas ativas aleatórias
-- Origem: backend/src/app.js:14
-- Original usa $1 para o limite; exemplo substitui por 10 para executar no pgAdmin.
SELECT q.id,
         c.nome AS category,
         q.pergunta AS question,
         q.explicacao AS explanation,
         COALESCE(f.nome, q.nome_fonte) AS "sourceName",
         COALESCE(f.url, q.url_fonte) AS "sourceUrl",
         q.dificuldade_pergunta::text AS difficulty,
         q.pergunta_bonus AS bonus,
         array_agg(o.alternativas ORDER BY o.posicao_pergunta) AS options,
         MIN(o.posicao_pergunta) FILTER (WHERE o.esta_correto) AS "correctAnswer"
  FROM (SELECT * FROM questao_quiz WHERE ativo ORDER BY random() LIMIT 10) q
  JOIN categorias_perguntas c ON c.id = q.categoria_id
  LEFT JOIN fontes f ON f.id = q.fonte_id
  JOIN opcoes_perguntas o ON o.id_pergunta = q.id
  GROUP BY q.id, c.nome, q.pergunta, q.explicacao, f.nome, f.url, q.nome_fonte, q.url_fonte,
           q.dificuldade_pergunta, q.pergunta_bonus;

-- API: ranking dos jogadores
-- Origem: backend/src/app.js:46
-- Original usa $1 (limite) e $2 (nome); exemplo usa 10 e NULL.
WITH melhor AS (
    SELECT DISTINCT ON (d.jogador_id)
           j.nome AS name, d.pontuacao_total AS points, d.tempo_total AS total_time,
           d.terminou_em AS finished, d.id
    FROM dados_partidas d
    JOIN jogadores j ON j.id = d.jogador_id
    ORDER BY d.jogador_id, d.pontuacao_total DESC, d.tempo_total ASC, d.terminou_em ASC, d.id ASC
  ), classificados AS (
    SELECT name, points,
           ROW_NUMBER() OVER (ORDER BY points DESC, total_time ASC, finished ASC, id ASC) AS position
    FROM melhor
  )
  SELECT position::int AS position, name, points
  FROM classificados
  WHERE position <= 10 OR name = NULL
  ORDER BY position;

-- API: Confere as alternativas corretas
-- Origem: backend/src/app.js:144
-- Original recebe $1 como lista de IDs das perguntas; exemplo usa [1,2,3].
SELECT id_pergunta, posicao_pergunta FROM opcoes_perguntas WHERE esta_correto AND id_pergunta = ANY(ARRAY[1,2,3]::int[]);

-- API: Busca jogador para possível inclusão (trecho SELECT do INSERT)
-- Origem: backend/src/app.js:165
-- O INSERT original foi removido; verifica apenas se o nome ainda não existe.
SELECT 'JogadorExemplo'::text WHERE NOT EXISTS (SELECT 1 FROM jogadores WHERE nome = 'JogadorExemplo'::text);

-- API: Obtém o ID do jogador
-- Origem: backend/src/app.js:168
-- Original recebe $1 como nome; exemplo usa JogadorExemplo.
SELECT id FROM jogadores WHERE nome = 'JogadorExemplo' ORDER BY id LIMIT 1;

-- API: Checa conexão com o banco
-- Origem: backend/src/app.js:211
SELECT 1;

