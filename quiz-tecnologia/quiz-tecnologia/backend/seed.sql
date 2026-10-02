-- Dados iniciais (gerados a partir de js/questions.js). Pode ser executado mais de uma vez.

INSERT INTO categories (name) VALUES
  ('História da tecnologia')
ON CONFLICT DO NOTHING;

INSERT INTO questions (id, category_id, statement, explanation, source_name, source_url)
VALUES (
  1,
  (SELECT id FROM categories WHERE name = 'História da tecnologia'),
  'Qual máquina é amplamente considerada o primeiro computador digital eletrônico de propósito geral e em qual década ela foi operacionalizada?',
  'O ENIAC foi construído durante a Segunda Guerra Mundial e apresentado ao público em fevereiro de 1946, na Universidade da Pensilvânia, ou seja, entrou em operação na década de 1940. Projetado por John Mauchly e J. Presper Eckert, é considerado o primeiro computador digital eletrônico de propósito geral.',
  'Penn Today',
  'https://penntoday.upenn.edu/news/worlds-first-general-purpose-computer-turns-75'
) ON CONFLICT DO NOTHING;

INSERT INTO options (question_id, position, text, is_correct) VALUES
  (1, 0, 'ENIAC', true),
  (1, 1, 'Colossus', false),
  (1, 2, 'Z3', false),
  (1, 3, 'ABC', false)
ON CONFLICT DO NOTHING;

INSERT INTO questions (id, category_id, statement, explanation, source_name, source_url)
VALUES (
  2,
  (SELECT id FROM categories WHERE name = 'História da tecnologia'),
  'Quem inventou a World Wide Web (WWW) no laboratório do CERN em 1989?',
  'Tim Berners-Lee escreveu a primeira proposta da Web em março de 1989, quando trabalhava no CERN, e no fim de 1990 já tinha o primeiro servidor e navegador funcionando. Linus Torvalds criou o Linux, Marc Andreessen foi um dos criadores do navegador Mosaic e Richard Stallman fundou o projeto GNU.',
  'CERN',
  'https://home.cern/science/computing/the-birth-of-the-web/short-history-web/'
) ON CONFLICT DO NOTHING;

INSERT INTO options (question_id, position, text, is_correct) VALUES
  (2, 0, 'Tim Berners-Lee', true),
  (2, 1, 'Linus Torvalds', false),
  (2, 2, 'Marc Andreessen', false),
  (2, 3, 'Richard Stallman', false)
ON CONFLICT DO NOTHING;

INSERT INTO questions (id, category_id, statement, explanation, source_name, source_url)
VALUES (
  3,
  (SELECT id FROM categories WHERE name = 'História da tecnologia'),
  'Qual opção Tim Berners-Lee não criou?',
  'Tim Berners-Lee criou o HTML, o protocolo HTTP e o sistema de endereços (URL). O CSS veio depois: foi proposto em 1994 por Håkon Wium Lie, que trabalhava com ele no CERN, para separar o conteúdo da página da sua aparência.',
  'InfoEscola',
  'https://www.infoescola.com/informatica/cascading-style-sheets-css/'
) ON CONFLICT DO NOTHING;

INSERT INTO options (question_id, position, text, is_correct) VALUES
  (3, 0, 'CSS', true),
  (3, 1, 'HTTP', false),
  (3, 2, 'HTML', false),
  (3, 3, 'URL', false)
ON CONFLICT DO NOTHING;

INSERT INTO questions (id, category_id, statement, explanation, source_name, source_url)
VALUES (
  4,
  (SELECT id FROM categories WHERE name = 'História da tecnologia'),
  'O termo "bug" na computação se popularizou quando Grace Hopper documentou uma lagartixa real presa em um relé do computador Harvard Mark II. Essa afirmação é verdadeira ou falsa?',
  'Falsa. O inseto encontrado em 9 de setembro de 1947 no Harvard Mark II era uma mariposa, e não uma lagartixa. Ela foi colada no diário de operações da equipe. O termo "bug" já era usado para falhas técnicas antes disso; o episódio ficou famoso e Grace Hopper ajudou a divulgar a história.',
  'Educa Mais Brasil',
  'https://www.educamaisbrasil.com.br/educacao/dicas/o-que-e-bug-qual-a-origem-da-expressao'
) ON CONFLICT DO NOTHING;

INSERT INTO options (question_id, position, text, is_correct) VALUES
  (4, 0, 'Falsa', true),
  (4, 1, 'Verdadeira', false)
ON CONFLICT DO NOTHING;

INSERT INTO questions (id, category_id, statement, explanation, source_name, source_url)
VALUES (
  5,
  (SELECT id FROM categories WHERE name = 'História da tecnologia'),
  'Qual o primeiro vírus de computador da história geral da tecnologia?',
  'O Creeper foi criado em 1971 por Bob Thomas, como um experimento: um programa que passava de computador em computador na ARPANET exibindo uma mensagem provocativa. Depois surgiu o Reaper, feito para removê-lo. O Brain, de 1986, é considerado o primeiro vírus para PCs.',
  'CyberSec Brasil',
  'https://www.cybersecbrazil.com.br/post/o-creeper-o-primeiro-v%C3%ADrus-de-computador-da-hist%C3%B3ria'
) ON CONFLICT DO NOTHING;

INSERT INTO options (question_id, position, text, is_correct) VALUES
  (5, 0, 'Creeper', true),
  (5, 1, 'Brain', false),
  (5, 2, 'ILOVEYOU', false),
  (5, 3, 'WannaCry', false)
ON CONFLICT DO NOTHING;

-- Mantém a sequência de ids alinhada com os ids inseridos manualmente.
SELECT setval(pg_get_serial_sequence('questions', 'id'), (SELECT MAX(id) FROM questions));
