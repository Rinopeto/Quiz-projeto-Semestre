"use strict";

/*
 * Perguntas locais do DevClash (SQL e bancos de dados).
 * Usadas quando API_BASE_URL está vazio ou a API não responde.
 *
 * Campos:
 *   bonus         true nas perguntas bônus (opcional)
 *   difficulty    "facil" | "medio" | "dificil"
 *   correctAnswer índice da alternativa correta dentro de "options"
 *   explanation   texto mostrado depois da resposta
 *   sourceName / sourceUrl   de onde veio a pergunta
 * Trechos entre crases (`SELECT`) aparecem formatados como código.
 * Esta estrutura é a mesma devolvida pela API (GET /api/questions).
 */
const LOCAL_QUESTIONS = [
  {
    id: 1,
    category: "Modelagem e DDL",
    difficulty: "facil",
    question: "Qual restrição (constraint) garante que cada linha da tabela seja identificada de forma única e não aceita valores nulos?",
    options: ["`PRIMARY KEY`", "`FOREIGN KEY`", "`CHECK`", "`DEFAULT`"],
    correctAnswer: 0,
    explanation: "A `PRIMARY KEY` é a combinação de `UNIQUE` com `NOT NULL`: os valores não podem se repetir nem ser nulos. Uma tabela pode ter no máximo uma chave primária, formada por uma ou mais colunas. Já a `FOREIGN KEY` referencia outra tabela, a `CHECK` valida uma condição e a `DEFAULT` define um valor padrão.",
    sourceName: "Documentação do PostgreSQL: Constraints",
    sourceUrl: "https://www.postgresql.org/docs/current/ddl-constraints.html"
  },
  {
    id: 2,
    category: "Modelagem e DDL",
    difficulty: "facil",
    question: "Qual comando SQL remove uma tabela inteira, incluindo sua estrutura e todos os dados?",
    options: ["`DROP TABLE`", "`TRUNCATE`", "`DELETE`", "`ALTER TABLE`"],
    correctAnswer: 0,
    explanation: "`DROP TABLE` apaga a tabela e a sua definição. O `TRUNCATE` esvazia a tabela e o `DELETE` remove linhas, mas os dois mantêm a estrutura. O `ALTER TABLE` só modifica a estrutura, sem apagar a tabela.",
    sourceName: "Documentação do PostgreSQL: Table Basics",
    sourceUrl: "https://www.postgresql.org/docs/current/ddl-basics.html"
  },
  {
    id: 3,
    category: "Ferramentas",
    difficulty: "facil",
    question: "Qual ferramenta é a plataforma open source de administração e desenvolvimento mais usada com o PostgreSQL?",
    options: ["pgAdmin", "phpMyAdmin", "SQL Server Management Studio", "MongoDB Compass"],
    correctAnswer: 0,
    explanation: "O pgAdmin permite navegar pelos objetos do banco, executar consultas e administrar servidores PostgreSQL. O phpMyAdmin é voltado ao MySQL e ao MariaDB, o SQL Server Management Studio ao SQL Server e o MongoDB Compass ao MongoDB. As cores deste quiz vêm do tema do pgAdmin.",
    sourceName: "pgAdmin",
    sourceUrl: "https://www.pgadmin.org/"
  },
  {
    id: 4,
    category: "Consultas SQL",
    difficulty: "medio",
    question: "Qual cláusula filtra os grupos formados por `GROUP BY` com base no resultado de uma função de agregação, como `COUNT(*)`?",
    options: ["`HAVING`", "`WHERE`", "`ORDER BY`", "`LIMIT`"],
    correctAnswer: 0,
    explanation: "O `WHERE` filtra as linhas antes do agrupamento e não aceita funções de agregação. O `HAVING` filtra os grupos depois que as agregações são calculadas. Exemplo: `GROUP BY cidade HAVING COUNT(*) > 10`.",
    sourceName: "Documentação do PostgreSQL: Aggregate Functions (tutorial)",
    sourceUrl: "https://www.postgresql.org/docs/current/tutorial-agg.html"
  },
  {
    id: 5,
    category: "Consultas SQL",
    difficulty: "medio",
    question: "Qual tipo de junção retorna todas as linhas da tabela da esquerda, mesmo quando não há correspondência na tabela da direita?",
    options: ["`LEFT JOIN`", "`INNER JOIN`", "`RIGHT JOIN`", "`CROSS JOIN`"],
    correctAnswer: 0,
    explanation: "No `LEFT JOIN` (ou `LEFT OUTER JOIN`) toda linha da tabela da esquerda aparece no resultado; quando não há correspondência na direita, as colunas dela vêm como `NULL`. O `INNER JOIN` devolve só as linhas com correspondência nas duas tabelas, o `RIGHT JOIN` faz o inverso e o `CROSS JOIN` gera o produto cartesiano.",
    sourceName: "Documentação do PostgreSQL: Joins Between Tables",
    sourceUrl: "https://www.postgresql.org/docs/current/tutorial-join.html"
  },
  {
    id: 6,
    category: "Consultas SQL",
    difficulty: "medio",
    question: "Em SQL, qual é o resultado da expressão `NULL = NULL`?",
    options: ["`NULL`", "`TRUE`", "`FALSE`", "Erro de sintaxe"],
    correctAnswer: 0,
    explanation: "`NULL` representa um valor desconhecido, e comparar dois desconhecidos com `=` também dá um resultado desconhecido, ou seja, `NULL`. Por isso os nulos são testados com `IS NULL` e `IS NOT NULL`.",
    sourceName: "Documentação do PostgreSQL: Comparison Functions and Operators",
    sourceUrl: "https://www.postgresql.org/docs/current/functions-comparison.html"
  },
  {
    id: 7,
    category: "PostgreSQL",
    difficulty: "medio",
    question: "Que tipo de índice o PostgreSQL cria quando você usa `CREATE INDEX` sem informar o método?",
    options: ["B-tree", "Hash", "GiST", "GIN"],
    correctAnswer: 0,
    explanation: "Sem a cláusula `USING`, o PostgreSQL cria um índice B-tree, adequado a comparações como `=`, `<`, `>` e `BETWEEN` e também à ordenação. Hash, GiST e GIN são tipos especializados e precisam ser pedidos explicitamente.",
    sourceName: "Documentação do PostgreSQL: Index Types",
    sourceUrl: "https://www.postgresql.org/docs/current/indexes-types.html"
  },
  {
    id: 8,
    category: "Transações",
    difficulty: "dificil",
    question: "Qual é o nível de isolamento de transação padrão do PostgreSQL?",
    options: ["`READ COMMITTED`", "`READ UNCOMMITTED`", "`REPEATABLE READ`", "`SERIALIZABLE`"],
    correctAnswer: 0,
    explanation: "O padrão é `READ COMMITTED`: cada comando enxerga apenas os dados confirmados (commit) antes de ele começar. O padrão SQL define `SERIALIZABLE` como nível padrão, mas no PostgreSQL o normal é `READ COMMITTED`, e isso pode ser alterado. Curiosidade: no PostgreSQL, `READ UNCOMMITTED` se comporta como `READ COMMITTED`.",
    sourceName: "Documentação do PostgreSQL: SET TRANSACTION",
    sourceUrl: "https://www.postgresql.org/docs/current/sql-set-transaction.html"
  },
  {
    id: 9,
    category: "Desempenho",
    difficulty: "dificil",
    question: "Qual comando mostra o plano de execução de uma consulta e também a executa de verdade, exibindo os tempos reais?",
    options: ["`EXPLAIN ANALYZE`", "`EXPLAIN`", "`DESCRIBE`", "`SHOW PLAN`"],
    correctAnswer: 0,
    explanation: "O `EXPLAIN` sozinho mostra apenas o plano estimado pelo otimizador. Com `EXPLAIN ANALYZE` a consulta é executada, e o resultado inclui tempos e contagens de linhas reais. Atenção: um `INSERT`, `UPDATE` ou `DELETE` analisado assim altera os dados de verdade.",
    sourceName: "Documentação do PostgreSQL: Using EXPLAIN",
    sourceUrl: "https://www.postgresql.org/docs/current/using-explain.html"
  },
  {
    id: 10,
    category: "PostgreSQL",
    difficulty: "dificil",
    question: "No PostgreSQL, qual comando de manutenção recupera o espaço ocupado por linhas mortas, as versões antigas que sobram depois de um `UPDATE` ou `DELETE`?",
    options: ["`VACUUM`", "`TRUNCATE`", "`REINDEX`", "`ANALYZE`"],
    correctAnswer: 0,
    explanation: "Por causa do MVCC, um `UPDATE` ou `DELETE` não apaga a linha antiga na hora: ela vira uma linha morta. O `VACUUM` libera esse espaço para reutilização (o autovacuum faz isso automaticamente). O `TRUNCATE` esvazia a tabela inteira, o `REINDEX` reconstrói índices e o `ANALYZE` atualiza as estatísticas usadas pelo planejador.",
    sourceName: "Documentação do PostgreSQL: Routine Vacuuming",
    sourceUrl: "https://www.postgresql.org/docs/current/routine-vacuuming.html"
  },
  {
    id: 11,
    category: "Fundamentos de SQL",
    difficulty: "facil",
    question: "O que significa a sigla SQL?",
    options: ["Standard Question Language", "Simple Query Logic", "Structured Query Language", "Sequential Query Layer"],
    correctAnswer: 2,
    explanation: "SQL vem de Structured Query Language (linguagem de consulta estruturada). É a linguagem padrão para criar, consultar e modificar dados em bancos de dados relacionais, como PostgreSQL, MySQL e SQL Server.",
    sourceName: "Wikipédia: SQL",
    sourceUrl: "https://pt.wikipedia.org/wiki/SQL"
  },
  {
    id: 13,
    category: "Consultas SQL",
    difficulty: "facil",
    question: "Qual cláusula ordena as linhas do resultado de uma consulta?",
    options: ["`GROUP BY`", "`SORT BY`", "`ORDER BY`", "`ARRANGE BY`"],
    correctAnswer: 2,
    explanation: "`ORDER BY` ordena o resultado por uma ou mais colunas, em ordem crescente (`ASC`, o padrão) ou decrescente (`DESC`). O `GROUP BY` serve para agrupar linhas, não para ordená-las.",
    sourceName: "Documentação do PostgreSQL: Sorting Rows",
    sourceUrl: "https://www.postgresql.org/docs/current/queries-order.html"
  },
  {
    id: 15,
    category: "Consultas SQL",
    difficulty: "facil",
    question: "Qual função de agregação conta o número de linhas de um resultado?",
    options: ["`COUNT`", "`SUM`", "`TOTAL`", "`LEN`"],
    correctAnswer: 0,
    explanation: "`COUNT` conta linhas (ou valores). `SUM` soma valores numéricos, e `LEN` e `TOTAL` não são funções de contagem no PostgreSQL.",
    sourceName: "Documentação do PostgreSQL: Aggregate Functions",
    sourceUrl: "https://www.postgresql.org/docs/current/functions-aggregate.html"
  },
  {
    id: 16,
    category: "Consultas SQL",
    difficulty: "facil",
    question: "Qual palavra-chave remove linhas duplicadas do resultado de um `SELECT`?",
    options: ["`SINGLE`", "`NOREPEAT`", "`DISTINCT`", "`LIMIT`"],
    correctAnswer: 2,
    explanation: "`SELECT DISTINCT` elimina as linhas repetidas do resultado. O `LIMIT` apenas restringe quantas linhas são devolvidas, sem tratar duplicatas.",
    sourceName: "Documentação do PostgreSQL: Select Lists",
    sourceUrl: "https://www.postgresql.org/docs/current/queries-select-lists.html"
  },
  {
    id: 17,
    category: "Ferramentas",
    difficulty: "facil",
    question: "No pgAdmin, qual ferramenta permite escrever e executar comandos SQL em um banco de dados?",
    options: ["ERD Tool", "Grant Wizard", "Schema Diff", "Query Tool"],
    correctAnswer: 3,
    explanation: "O Query Tool é o editor SQL do pgAdmin: você escreve as consultas, executa e vê os resultados em uma grade, além de poder ver o plano de execução. O ERD Tool desenha diagramas, o Grant Wizard gerencia permissões e o Schema Diff compara esquemas.",
    sourceName: "Documentação do pgAdmin: Query Tool",
    sourceUrl: "https://www.pgadmin.org/docs/pgadmin4/latest/query_tool.html"
  },
  {
    id: 18,
    category: "PostgreSQL",
    difficulty: "facil",
    question: "Qual é a porta TCP padrão em que o servidor PostgreSQL aceita conexões?",
    options: ["3306", "1433", "5432", "27017"],
    correctAnswer: 2,
    explanation: "A porta padrão do PostgreSQL é a 5432 (parâmetro `port`). A 3306 é a do MySQL, a 1433 do SQL Server e a 27017 do MongoDB.",
    sourceName: "Documentação do PostgreSQL: Connections and Authentication",
    sourceUrl: "https://www.postgresql.org/docs/current/runtime-config-connection.html"
  },
  {
    id: 19,
    category: "Consultas SQL",
    difficulty: "medio",
    question: "Qual operador combina o resultado de duas consultas mantendo as linhas duplicadas?",
    options: ["`UNION`", "`INTERSECT`", "`EXCEPT`", "`UNION ALL`"],
    correctAnswer: 3,
    explanation: "`UNION` junta os resultados e remove as duplicatas; `UNION ALL` mantém todas as linhas e, por isso, costuma ser mais rápido. `INTERSECT` devolve só as linhas presentes nos dois resultados e `EXCEPT` as que estão no primeiro e não no segundo.",
    sourceName: "Documentação do PostgreSQL: Combining Queries",
    sourceUrl: "https://www.postgresql.org/docs/current/queries-union.html"
  },
  {
    id: 20,
    category: "Consultas SQL",
    difficulty: "medio",
    question: "O que a função `COALESCE(a, b, c)` devolve?",
    options: ["O primeiro argumento que não for `NULL`", "O maior valor entre os argumentos", "A concatenação de todos os argumentos", "A quantidade de argumentos nulos"],
    correctAnswer: 0,
    explanation: "`COALESCE` percorre os argumentos da esquerda para a direita e devolve o primeiro que não é `NULL` (ou `NULL`, se todos forem). É muito usada para trocar nulos por um valor padrão, como `COALESCE(telefone, 'sem telefone')`.",
    sourceName: "Documentação do PostgreSQL: Conditional Expressions",
    sourceUrl: "https://www.postgresql.org/docs/current/functions-conditional.html"
  },
  {
    id: 21,
    category: "Consultas SQL",
    difficulty: "medio",
    question: "Qual cláusula define uma consulta nomeada e temporária (CTE) que pode ser usada dentro de outra consulta?",
    options: ["`TEMP`", "`WITH`", "`DEFINE`", "`USING`"],
    correctAnswer: 1,
    explanation: "A cláusula `WITH` cria CTEs (Common Table Expressions), consultas auxiliares com nome que deixam consultas complexas mais legíveis. Com `WITH RECURSIVE` também é possível percorrer estruturas hierárquicas, como árvores de categorias.",
    sourceName: "Documentação do PostgreSQL: WITH Queries",
    sourceUrl: "https://www.postgresql.org/docs/current/queries-with.html"
  },
  {
    id: 22,
    category: "Consultas SQL",
    difficulty: "medio",
    question: "Qual função de janela numera as linhas de forma sequencial (1, 2, 3...) dentro de cada partição?",
    options: ["`LAG()`", "`SUM()`", "`COUNT()`", "`ROW_NUMBER()`"],
    correctAnswer: 3,
    explanation: "`ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)` numera as linhas de cada partição em sequência, sem repetir números. `LAG()` acessa o valor da linha anterior, e `SUM()` e `COUNT()` são agregações que também podem virar funções de janela, mas não numeram linhas.",
    sourceName: "Documentação do PostgreSQL: Window Functions",
    sourceUrl: "https://www.postgresql.org/docs/current/functions-window.html"
  },
  {
    id: 23,
    category: "Modelagem e DDL",
    difficulty: "medio",
    question: "Qual restrição impede valores repetidos em uma coluna, mas, diferente da chave primária, aceita valores nulos?",
    options: ["`PRIMARY KEY`", "`NOT NULL`", "`UNIQUE`", "`CHECK`"],
    correctAnswer: 2,
    explanation: "`UNIQUE` garante que os valores não se repitam, mas não exige preenchimento. No PostgreSQL, valores nulos não são considerados iguais entre si, então a coluna pode ter vários `NULL`. Já a `PRIMARY KEY` exige valores únicos e não nulos.",
    sourceName: "Documentação do PostgreSQL: Constraints",
    sourceUrl: "https://www.postgresql.org/docs/current/ddl-constraints.html"
  },
  {
    id: 24,
    category: "Modelagem e DDL",
    difficulty: "medio",
    question: "Em uma chave estrangeira, o que faz a opção `ON DELETE CASCADE`?",
    options: ["Impede a exclusão da linha referenciada", "Define as colunas filhas como `NULL`", "Apaga automaticamente as linhas que referenciam a linha excluída", "Copia a linha excluída para uma tabela de histórico"],
    correctAnswer: 2,
    explanation: "Com `ON DELETE CASCADE`, ao excluir a linha referenciada, as linhas que dependem dela são excluídas junto. O comportamento padrão (`NO ACTION`) rejeita a exclusão, e o `SET NULL` apenas zera a coluna filha.",
    sourceName: "Documentação do PostgreSQL: Constraints",
    sourceUrl: "https://www.postgresql.org/docs/current/ddl-constraints.html"
  },
  {
    id: 26,
    category: "Modelagem e DDL",
    difficulty: "medio",
    question: "O que é uma `VIEW` em um banco de dados relacional?",
    options: ["Uma cópia física de uma tabela", "Um tipo especial de índice", "Um backup agendado", "Uma consulta salva com nome, usada como se fosse uma tabela"],
    correctAnswer: 3,
    explanation: "Uma `VIEW` guarda uma consulta com um nome e permite usá-la como uma tabela virtual. Os dados continuam nas tabelas originais, e a consulta é executada toda vez que a view é lida. Já a `MATERIALIZED VIEW` guarda o resultado da consulta.",
    sourceName: "Documentação do PostgreSQL: CREATE VIEW",
    sourceUrl: "https://www.postgresql.org/docs/current/sql-createview.html"
  },
  {
    id: 27,
    category: "Modelagem e DDL",
    difficulty: "medio",
    question: "Segundo a Primeira Forma Normal (1FN), o que cada coluna de uma tabela deve conter?",
    options: ["Apenas valores numéricos", "Valores atômicos, sem listas nem grupos repetidos", "Referências a outras tabelas", "Valores calculados a partir de outras colunas"],
    correctAnswer: 1,
    explanation: "A 1FN exige valores atômicos (indivisíveis) em cada célula: nada de listas de valores na mesma coluna nem colunas repetidas, como `telefone1`, `telefone2` e `telefone3`. É o primeiro passo da normalização, que reduz a redundância dos dados.",
    sourceName: "Wikipedia: First normal form",
    sourceUrl: "https://en.wikipedia.org/wiki/First_normal_form"
  },
  {
    id: 28,
    category: "Transações",
    difficulty: "medio",
    question: "Na sigla ACID, qual propriedade garante que, depois do `COMMIT`, os dados continuam gravados mesmo que o sistema falhe?",
    options: ["Atomicidade", "Durabilidade", "Consistência", "Isolamento"],
    correctAnswer: 1,
    explanation: "A Durabilidade garante que uma transação confirmada não seja perdida, mesmo após queda de energia ou travamento. As outras: Atomicidade (tudo ou nada), Consistência (as regras do banco continuam válidas) e Isolamento (transações simultâneas não interferem entre si).",
    sourceName: "Wikipedia: ACID",
    sourceUrl: "https://en.wikipedia.org/wiki/ACID"
  },
  {
    id: 29,
    category: "Ferramentas",
    difficulty: "medio",
    question: "No pgAdmin, qual ferramenta permite desenhar e visualizar o diagrama entidade-relacionamento (ERD) de um banco de dados?",
    options: ["Schema Diff", "ERD Tool", "Debugger", "Grant Wizard"],
    correctAnswer: 1,
    explanation: "O ERD Tool do pgAdmin desenha diagramas entidade-relacionamento: dá para criar tabelas visualmente ou gerar o diagrama a partir de um banco existente, e até gerar o SQL do desenho. O Schema Diff compara esquemas, o Debugger depura funções e o Grant Wizard concede permissões em lote.",
    sourceName: "Documentação do pgAdmin: ERD Tool",
    sourceUrl: "https://www.pgadmin.org/docs/pgadmin4/latest/erd_tool.html"
  },
  {
    id: 30,
    category: "Transações",
    difficulty: "medio",
    question: "Para que serve o comando `SAVEPOINT` dentro de uma transação?",
    options: ["Confirmar a transação definitivamente", "Criar uma cópia de segurança do banco", "Bloquear a tabela para outros usuários", "Marcar um ponto ao qual é possível voltar sem desfazer a transação inteira"],
    correctAnswer: 3,
    explanation: "`SAVEPOINT` marca um ponto dentro da transação. Com `ROLLBACK TO SAVEPOINT` desfazem-se apenas os comandos executados depois dele, e o que veio antes continua valendo até o `COMMIT` ou o `ROLLBACK` final.",
    sourceName: "Documentação do PostgreSQL: SAVEPOINT",
    sourceUrl: "https://www.postgresql.org/docs/current/sql-savepoint.html"
  },
  {
    id: 31,
    category: "PostgreSQL",
    difficulty: "medio",
    question: "Qual tipo o PostgreSQL recomenda, na maioria dos casos, para guardar dados JSON com suporte a índices e consultas mais rápidas?",
    options: ["`json`", "`text`", "`jsonb`", "`xml`"],
    correctAnswer: 2,
    explanation: "O `jsonb` guarda o JSON em formato binário decomposto: a gravação é um pouco mais lenta, mas as consultas são bem mais rápidas e ele aceita índices (como o GIN). O `json` guarda o texto exato, preservando espaços e a ordem das chaves.",
    sourceName: "Documentação do PostgreSQL: JSON Types",
    sourceUrl: "https://www.postgresql.org/docs/current/datatype-json.html"
  },
  {
    id: 34,
    category: "Transações",
    difficulty: "dificil",
    question: "Qual mecanismo permite que, no PostgreSQL, leitores e escritores não se bloqueiem, mantendo várias versões das mesmas linhas?",
    options: ["Sharding", "MVCC", "Two-phase locking", "Write-through cache"],
    correctAnswer: 1,
    explanation: "No MVCC (Multiversion Concurrency Control), cada transação enxerga um instantâneo (snapshot) dos dados, e as alterações criam novas versões das linhas. Por isso leituras não bloqueiam escritas, e escritas não bloqueiam leituras. As versões antigas são limpas depois pelo `VACUUM`.",
    sourceName: "Documentação do PostgreSQL: Introduction (MVCC)",
    sourceUrl: "https://www.postgresql.org/docs/current/mvcc-intro.html"
  },
  {
    id: 35,
    category: "Transações",
    difficulty: "dificil",
    question: "Qual é o menor nível de isolamento do PostgreSQL em que repetir uma consulta na mesma transação sempre devolve os mesmos dados?",
    options: ["`READ COMMITTED`", "`READ UNCOMMITTED`", "`SERIALIZABLE`", "`REPEATABLE READ`"],
    correctAnswer: 3,
    explanation: "No `REPEATABLE READ`, a transação usa o snapshot tirado no início da primeira consulta, então repetições enxergam os mesmos dados. No `READ COMMITTED` cada comando tira um novo snapshot, e o `READ UNCOMMITTED` se comporta como `READ COMMITTED`. O `SERIALIZABLE` também garante isso, mas é um nível acima.",
    sourceName: "Documentação do PostgreSQL: Transaction Isolation",
    sourceUrl: "https://www.postgresql.org/docs/current/transaction-iso.html"
  },
  {
    id: 36,
    category: "Transações",
    difficulty: "dificil",
    question: "Como se chama a situação em que duas transações esperam uma pela outra, cada uma segurando um bloqueio de que a outra precisa?",
    options: ["Livelock", "Dirty read", "Phantom read", "Deadlock"],
    correctAnswer: 3,
    explanation: "Isso é um deadlock (impasse). O PostgreSQL detecta a situação automaticamente e cancela uma das transações para as outras poderem continuar. A boa prática é acessar tabelas e linhas sempre na mesma ordem, o que reduz a chance de deadlocks.",
    sourceName: "Documentação do PostgreSQL: Explicit Locking",
    sourceUrl: "https://www.postgresql.org/docs/current/explicit-locking.html"
  },
  {
    id: 37,
    category: "Desempenho",
    difficulty: "dificil",
    question: "O que é um índice parcial (`partial index`) no PostgreSQL?",
    options: ["Um índice que cobre apenas a primeira coluna de uma chave composta", "Um índice criado só sobre as linhas que satisfazem uma condição `WHERE`", "Um índice reconstruído aos poucos em segundo plano", "Um índice que guarda só parte do valor de cada coluna"],
    correctAnswer: 1,
    explanation: "Um índice parcial é criado com uma cláusula `WHERE` e indexa apenas as linhas que atendem a ela, por exemplo `CREATE INDEX ON pedidos (cliente_id) WHERE status = 'aberto'`. Ele fica menor e mais barato de manter, e é útil quando as consultas olham sempre para o mesmo subconjunto dos dados.",
    sourceName: "Documentação do PostgreSQL: Partial Indexes",
    sourceUrl: "https://www.postgresql.org/docs/current/indexes-partial.html"
  },
  {
    id: 38,
    category: "Desempenho",
    difficulty: "dificil",
    question: "Qual cláusula do `CREATE INDEX` permite guardar colunas extras no índice, ajudando a evitar o acesso à tabela (index-only scan)?",
    options: ["`WITH`", "`COVER`", "`EXTEND`", "`INCLUDE`"],
    correctAnswer: 3,
    explanation: "Com `INCLUDE` (PostgreSQL 11 ou superior), colunas adicionais ficam armazenadas no índice, mas não fazem parte da chave de busca. Assim, uma consulta pode ser respondida só com o índice (index-only scan), no chamado índice de cobertura.",
    sourceName: "Documentação do PostgreSQL: Index-Only Scans and Covering Indexes",
    sourceUrl: "https://www.postgresql.org/docs/current/indexes-index-only-scans.html"
  },
  {
    id: 39,
    category: "PostgreSQL",
    difficulty: "dificil",
    question: "Qual é a principal função do WAL (Write-Ahead Log) no PostgreSQL?",
    options: ["Guardar as consultas mais lentas para análise", "Registrar as alterações em um log antes de gravá-las nos arquivos de dados, permitindo recuperação após falhas", "Compactar as tabelas para economizar espaço", "Criptografar os dados em disco"],
    correctAnswer: 1,
    explanation: "No WAL (log de escrita antecipada), toda alteração é registrada em um log antes de ser aplicada aos arquivos de dados. Se o servidor cair, o PostgreSQL refaz o que estava no log e volta a um estado consistente. O WAL também é a base da replicação e do backup contínuo.",
    sourceName: "Documentação do PostgreSQL: Write-Ahead Logging (WAL)",
    sourceUrl: "https://www.postgresql.org/docs/current/wal-intro.html"
  },
  {
    id: 40,
    category: "Ferramentas",
    difficulty: "dificil",
    question: "Qual formato do `pg_dump` gera um script SQL em texto puro, que é restaurado com o `psql`?",
    options: ["`custom` (`-Fc`)", "`directory` (`-Fd`)", "`tar` (`-Ft`)", "`plain` (`-Fp`)"],
    correctAnswer: 3,
    explanation: "O formato `plain` gera um arquivo de texto com comandos SQL, que pode ser executado com o `psql`. Os formatos `custom`, `directory` e `tar` são restaurados com o `pg_restore`, que permite, entre outras coisas, restaurar só algumas tabelas.",
    sourceName: "Documentação do PostgreSQL: pg_dump",
    sourceUrl: "https://www.postgresql.org/docs/current/app-pgdump.html"
  },
  {
    id: 41,
    bonus: true,
    category: "História da tecnologia",
    difficulty: "medio",
    question: "Qual máquina é amplamente considerada o primeiro computador digital eletrônico de propósito geral e em qual década ela foi operacionalizada?",
    options: ["ENIAC", "Colossus", "Z3", "ABC"],
    correctAnswer: 0,
    explanation: "O ENIAC foi construído durante a Segunda Guerra Mundial e apresentado ao público em fevereiro de 1946, na Universidade da Pensilvânia, ou seja, entrou em operação na década de 1940. Projetado por John Mauchly e J. Presper Eckert, é considerado o primeiro computador digital eletrônico de propósito geral.",
    sourceName: "Penn Today",
    sourceUrl: "https://penntoday.upenn.edu/news/worlds-first-general-purpose-computer-turns-75"
  },
  {
    id: 42,
    bonus: true,
    category: "História da tecnologia",
    difficulty: "facil",
    question: "Quem inventou a World Wide Web (WWW) no laboratório do CERN em 1989?",
    options: ["Linus Torvalds", "Marc Andreessen", "Tim Berners-Lee", "Richard Stallman"],
    correctAnswer: 2,
    explanation: "Tim Berners-Lee escreveu a primeira proposta da Web em março de 1989, quando trabalhava no CERN, e no fim de 1990 já tinha o primeiro servidor e navegador funcionando. Linus Torvalds criou o Linux, Marc Andreessen foi um dos criadores do navegador Mosaic e Richard Stallman fundou o projeto GNU.",
    sourceName: "CERN",
    sourceUrl: "https://home.cern/science/computing/the-birth-of-the-web/short-history-web/"
  },
  {
    id: 43,
    bonus: true,
    category: "História da tecnologia",
    difficulty: "medio",
    question: "Qual opção Tim Berners-Lee não criou?",
    options: ["HTTP", "HTML", "CSS", "URL"],
    correctAnswer: 2,
    explanation: "Tim Berners-Lee criou o HTML, o protocolo HTTP e o sistema de endereços (URL). O CSS veio depois: foi proposto em 1994 por Håkon Wium Lie, que trabalhava com ele no CERN, para separar o conteúdo da página da sua aparência.",
    sourceName: "InfoEscola",
    sourceUrl: "https://www.infoescola.com/informatica/cascading-style-sheets-css/"
  },
  {
    id: 44,
    bonus: true,
    category: "História da tecnologia",
    difficulty: "dificil",
    question: "O termo \"bug\" na computação se popularizou quando Grace Hopper documentou uma lagartixa real presa em um relé do computador Harvard Mark II. Essa afirmação é verdadeira ou falsa?",
    options: ["Falsa", "Verdadeira"],
    correctAnswer: 0,
    explanation: "Falsa. O inseto encontrado em 9 de setembro de 1947 no Harvard Mark II era uma mariposa, e não uma lagartixa. Ela foi colada no diário de operações da equipe. O termo \"bug\" já era usado para falhas técnicas antes disso; o episódio ficou famoso e Grace Hopper ajudou a divulgar a história.",
    sourceName: "Educa Mais Brasil",
    sourceUrl: "https://www.educamaisbrasil.com.br/educacao/dicas/o-que-e-bug-qual-a-origem-da-expressao"
  },
  {
    id: 45,
    bonus: true,
    category: "História da tecnologia",
    difficulty: "dificil",
    question: "Qual o primeiro vírus de computador da história geral da tecnologia?",
    options: ["Brain", "ILOVEYOU", "Creeper", "WannaCry"],
    correctAnswer: 2,
    explanation: "O Creeper foi criado em 1971 por Bob Thomas, como um experimento: um programa que passava de computador em computador na ARPANET exibindo uma mensagem provocativa. Depois surgiu o Reaper, feito para removê-lo. O Brain, de 1986, é considerado o primeiro vírus para PCs.",
    sourceName: "CyberSec Brasil",
    sourceUrl: "https://www.cybersecbrazil.com.br/post/o-creeper-o-primeiro-v%C3%ADrus-de-computador-da-hist%C3%B3ria"
  },
  {
    id: 46,
    bonus: true,
    category: "História da tecnologia",
    difficulty: "facil",
    question: "Em que ano Linus Torvalds anunciou e lançou a primeira versão do kernel Linux?",
    options: ["1983", "1995", "2001", "1991"],
    correctAnswer: 3,
    explanation: "Em agosto de 1991, o estudante finlandês Linus Torvalds anunciou que estava criando um novo sistema operacional, e a primeira versão do kernel foi lançada em setembro daquele ano. O ano de 1983 é o do anúncio do projeto GNU, de Richard Stallman.",
    sourceName: "Wikipedia: Linux",
    sourceUrl: "https://en.wikipedia.org/wiki/Linux"
  },
  {
    id: 47,
    bonus: true,
    category: "História da tecnologia",
    difficulty: "medio",
    question: "Qual rede de computadores, financiada pelo Departamento de Defesa dos EUA, é considerada a precursora da internet?",
    options: ["Ethernet", "ARPANET", "Bluetooth", "Wi-Fi"],
    correctAnswer: 1,
    explanation: "A ARPANET, financiada pela agência ARPA do Departamento de Defesa dos EUA, enviou sua primeira mensagem em 1969 e é considerada a precursora da internet. Ethernet, Bluetooth e Wi-Fi são tecnologias de conexão, não a rede que deu origem à internet.",
    sourceName: "Wikipedia: ARPANET",
    sourceUrl: "https://en.wikipedia.org/wiki/ARPANET"
  },
  {
    id: 48,
    bonus: true,
    category: "História da tecnologia",
    difficulty: "medio",
    question: "Quem propôs o modelo relacional de banco de dados, em um artigo de 1970 enquanto trabalhava na IBM?",
    options: ["Charles Bachman", "Michael Stonebraker", "Edgar F. Codd", "Larry Ellison"],
    correctAnswer: 2,
    explanation: "Edgar F. Codd, pesquisador da IBM, publicou em 1970 o artigo que propôs o modelo relacional, base dos bancos de dados SQL. Charles Bachman ficou conhecido pelo modelo de rede, Michael Stonebraker criou o Ingres e o POSTGRES (origem do PostgreSQL) e Larry Ellison cofundou a Oracle.",
    sourceName: "Wikipedia: Edgar F. Codd",
    sourceUrl: "https://en.wikipedia.org/wiki/Edgar_F._Codd"
  },
  {
    id: 49,
    bonus: true,
    category: "História da tecnologia",
    difficulty: "dificil",
    question: "Qual navegador, lançado em 1993 pelo NCSA, ajudou a popularizar a Web por ter interface gráfica e mostrar imagens junto com o texto?",
    options: ["Mosaic", "Netscape Navigator", "Internet Explorer", "Firefox"],
    correctAnswer: 0,
    explanation: "O NCSA Mosaic foi criado por Marc Andreessen e Eric Bina, e o seu lançamento em 1993 popularizou a Web graças à interface gráfica e às imagens exibidas junto com o texto. O Netscape Navigator veio em 1994, o Internet Explorer em 1995 e o Firefox em 2004.",
    sourceName: "Wikipedia: NCSA Mosaic",
    sourceUrl: "https://en.wikipedia.org/wiki/NCSA_Mosaic"
  },
  {
    id: 50,
    bonus: true,
    category: "História da tecnologia",
    difficulty: "dificil",
    question: "Qual linguagem de programação, criada por uma equipe da IBM liderada por John Backus e lançada em 1957, foi uma das primeiras linguagens de alto nível amplamente usadas?",
    options: ["COBOL", "BASIC", "Pascal", "FORTRAN"],
    correctAnswer: 3,
    explanation: "O FORTRAN (Formula Translation), desenvolvido por uma equipe da IBM liderada por John Backus, teve o seu primeiro compilador entregue em 1957 e foi muito usado em computação científica. O COBOL surgiu em 1959, o BASIC em 1964 e o Pascal em 1970.",
    sourceName: "Wikipedia: Fortran",
    sourceUrl: "https://en.wikipedia.org/wiki/Fortran"
  }
];

function cloneLocalQuestions() {
  return LOCAL_QUESTIONS.map((q) => ({ ...q, options: [...q.options] }));
}

function isValidQuestion(q) {
  return (
    q &&
    typeof q.question === "string" &&
    Array.isArray(q.options) &&
    q.options.length >= 2 &&
    Number.isInteger(q.correctAnswer) &&
    q.correctAnswer >= 0 &&
    q.correctAnswer < q.options.length
  );
}

/*
 * Camada de acesso aos dados.
 * Com API_BASE_URL configurada, busca as perguntas no backend (GET /api/questions).
 * Se a API estiver fora do ar ou devolver dados inválidos, usa as perguntas locais,
 * assim o quiz continua funcionando (por exemplo, no GitHub Pages sem backend).
 */
async function loadQuestions(limit) {
  if (!API_BASE_URL) return cloneLocalQuestions();

  const controller = new AbortController();
  // 45 s: planos gratuitos de hospedagem (ex.: Render) levam até ~1 min para "acordar" na primeira chamada.
  const timeoutId = setTimeout(() => controller.abort(), 45000);
  try {
    const query = limit ? `?limit=${encodeURIComponent(limit)}` : "";
    const response = await fetch(`${API_BASE_URL}/api/questions${query}`, { signal: controller.signal });
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    const data = await response.json();
    if (!Array.isArray(data) || data.length === 0 || !data.every(isValidQuestion)) {
      throw new Error("Resposta inválida da API");
    }
    return data;
  } catch (err) {
    console.warn("[devclash] API indisponível, usando perguntas locais:", err);
    return cloneLocalQuestions();
  } finally {
    clearTimeout(timeoutId);
  }
}
