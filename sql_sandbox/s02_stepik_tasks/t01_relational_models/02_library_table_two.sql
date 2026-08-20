/* =====================================================
  Курс: Stepik (Основы SQL)
  Модуль: 1.2 Выборка данных
===================================================== */

-- 1. Создаем изолированную "коробку" для Степика (сработает один раз)
CREATE SCHEMA IF NOT EXISTS stepik;

-- 2. Переключаем наш фокус в эту коробку (чтобы не мусорить в public)
SET search_path TO stepik;

-- 3. Сносим старую таблицу, если переделываем задачу
DROP TABLE IF EXISTS library_two;

-- 4. Твой код для задачи
CREATE TABLE library_two (
    PRIMARY KEY (book_id),
    book_id SERIAL       NOT NULL,
    title   VARCHAR(50)  NOT NULL,
    author  VARCHAR(30)  NOT NULL,
    price   DECIMAL(8,2) NOT NULL,
    amount  INT          NOT NULL
);

-- 5. Проверка (как это выглядит у нас)
INSERT INTO library_two (title, author, price, amount)
    VALUES ('Белая гвардия','Булгаков М.А.',540.50,5),
           ('Мастер и Маргарита', 'Булгаков М.А.', 670.99, 3),
           ('Идиот','Достоевский Ф.М.',460.00,10),
           ('Братья Карамазовы','Достоевский Ф.М.',799.01,2),
           ('Стихотворение и поэмы','Есенин С.А.',650.00,15);

UPDATE library_two
   SET title = 'Не идиот!'
 WHERE title = 'Идиот'
   AND price = 460.00;

SELECT title AS "Название книги",
       author AS Автор
FROM library_two;

SELECT title, author, price, amount,
       price * amount AS total
FROM library_two;

-----

SELECT title,
       price,
       ROUND(price - (price / 1.18), 2) AS tax,
       ROUND(price / 1.18, 2) AS price_tax
  FROM library_two;

SELECT title,
       author,
       amount,
       ROUND(price - (price * 0.30), 2) AS new_price
  FROM library_two;

-----

SELECT title,
       author,
       amount,
       CASE
           WHEN amount < 4 THEN ROUND(price * 0.5, 2)
           ELSE ROUND(price * 0.7, 2)
       END AS sale
  FROM library_two;

SELECT title,
       amount,
       CASE
           WHEN amount < 4  THEN 'Мало'
           WHEN amount < 10 THEN 'Нормально'
           WHEN amount > 20 THEN 'Слишком много'
           ELSE 'Достаточно'
       END AS stock_status
  FROM library_two;

SELECT title,
       amount,
       price,
       ROUND(
           CASE
               WHEN amount < 4  THEN price * 0.5
               WHEN amount < 11 THEN price * 0.7
               ELSE price * 0.9
           END, 2) AS sale,
       CASE
           WHEN amount < 4  THEN 'скидка 50%'
           WHEN amount < 11 THEN 'скидка 30%'
           ELSE 'скидка 10%'
       END AS "Ваша скидка"
  FROM library_two;

SELECT author,
       title,
       ROUND(
           CASE
               WHEN author = 'Булгаков М.А.' THEN price + (price * 0.1) -- price * 1.1
               WHEN author = 'Есенин С.А.' THEN price + (price * 0.05) -- price * 1.05
               ELSE price
           END, 2) AS new_price
  FROM library_two;

-----

SELECT author,
       title,
       amount,
       price,
       amount * price AS total_price
  FROM library_two
 WHERE amount < 10;

-----

SELECT author,
       title,
       price
  FROM library_two
 WHERE (author = 'Булгаков М.А.' OR author = 'Есенин С.А.') AND price > 600;

SELECT title,
       author,
       price,
       amount
  FROM library_two
 WHERE (price < 500 OR price > 600) AND price * amount >= 5000;

-----

SELECT title,
       amount
  FROM library_two
 WHERE amount BETWEEN 5 AND 14; -- WHERE amount >= 5 AND amount <= 14

SELECT author,
       title,
       price
  FROM library_two
 WHERE author IN ('Булгаков М.А.','Достоевский Ф.М.'); -- WHERE author = '...' OR author = '...';

SELECT title,
       author,
       amount
  FROM library_two
 WHERE price BETWEEN 540.50 AND 800
   AND amount IN (2,3,5,7);

-----

SELECT title,
       author,
       price
  FROM library_two
 ORDER BY author;

SELECT title,
       author,
       price,
       amount
 FROM library_two
 ORDER BY author, price DESC, amount;

SELECT author,
       title
  FROM library_two
 WHERE amount BETWEEN 2 AND 14
 ORDER BY author DESC, title;

-----

SELECT title
  FROM library_two
 WHERE title LIKE '%а'; -- 'Б%'


SELECT title
  FROM library_two
 WHERE title LIKE '___от'; -- '%от' к_т кит...

SELECT title
  FROM library_two
 WHERE title LIKE '_____'; -- вывести книги, название которых 5 символов:

SELECT title
  FROM library_two
 WHERE title LIKE '_____%'; -- вывести книги, название которых длиннее 5 символов:

SELECT title
  FROM library_two
  WHERE title NOT LIKE '% %';

SELECT title,
       author
  FROM library_two
 WHERE title LIKE '% %'
   AND (author LIKE '% С._.' OR author LIKE '% _.С.')
 ORDER BY title;

-----