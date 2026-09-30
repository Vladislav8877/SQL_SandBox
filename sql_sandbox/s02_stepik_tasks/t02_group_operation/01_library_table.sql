/* =====================================================
  Курс: Stepik (Основы SQL)
  Модуль: 1.3 Запросы, групповые операции
===================================================== */

CREATE SCHEMA IF NOT EXISTS stepik;
SET search_path TO stepik;
DROP TABLE IF EXISTS library_three;

CREATE TABLE library_three (
                             PRIMARY KEY (book_id),
                             book_id SERIAL       NOT NULL,
                             title   VARCHAR(50)  NOT NULL,
                             author  VARCHAR(30)  NOT NULL,
                             price   DECIMAL(8,2) NOT NULL,
                             amount  INT          NOT NULL
);


INSERT INTO library_three (title, author, price, amount)
VALUES ('Белая гвардия','Булгаков М.А.',540.50,5),
       ('Мастер и Маргарита', 'Булгаков М.А.', 670.99, 3),
       ('Идиот','Достоевский Ф.М.',460.00,10),
       ('Братья Карамазовы','Достоевский Ф.М.',799.01,2),
       ('Стихотворение и поэмы','Есенин С.А.',650.00,15),
       ('Игрок','Достоевский Ф.М.',480.50,10);

----- ----- ----- ----- -----

-- Чтобы отобрать уникальные элементы некоторого столбца используется ключевое слово DISTINCT
SELECT DISTINCT author
  FROM library_three;

SELECT author
  FROM library_three
 GROUP BY author;

---

SELECT author,
       SUM(amount),
       COUNT(*) AS total_price
  FROM library_three
 GROUP BY author;

---

/*
Задание 1.
Посчитать, количество различных книг и количество экземпляров книг каждого автора , хранящихся на складе.
Столбцы назвать Автор, Различных_книг и Количество_экземпляров соответственно.
*/

SELECT author,
       COUNT(title) AS "Различных_книг",
       SUM(amount)  AS "Количество_экземпляров"
  FROM library_three
 GROUP BY author;

---

SELECT author,
       MIN(price) AS min_price
  FROM library_three
 GROUP BY author;

/*
Задание 2.
Вывести фамилию и инициалы автора, минимальную, максимальную и среднюю цену книг каждого автора .
Вычисляемые столбцы назвать Минимальная_цена, Максимальная_цена и Средняя_цена соответственно.
*/
SELECT author,
       MIN(price)          AS Минимальная_цена,
       MAX(price)          AS Максимальная_цена,
       ROUND(AVG(price),2) AS Средняя_цена
  FROM library_three
 GROUP BY author;

---

SELECT author,
       SUM(price * amount) AS Стоимость
  FROM library_three
 GROUP BY author;

/*
Задание 4.
Вывести цену самой дешевой книги, цену самой дорогой и среднюю цену всех книг на складе.
Названия столбцов Минимальная_цена, Максимальная_цена, Средняя_цена соответственно.
Среднюю цену округлить до двух знаков после запятой.
*/

SELECT MIN(price)          AS Минимальная_цена,
       MAX(price)          AS Максимальная_цена,
       ROUND(AVG(price),2) AS Средняя_цена
FROM library_three;

---

-- Найти минимальную и максимальную цену книг всех авторов, общая стоимость книг которых больше 5000.
SELECT author,
       MIN(price) AS Минимальная_цена,
       MAX(price) AS Максимальная_цена
  FROM library_three
 GROUP BY author
HAVING SUM(price * amount) > 5000;

/*
Задание 5.
Вычислить среднюю цену и суммарную стоимость тех книг, количество экземпляров которых принадлежит интервалу от 5 до 14,
включительно. Столбцы назвать Средняя_цена и Стоимость, значения округлить до 2-х знаков после запятой.
*/

SELECT ROUND(AVG(price),2) AS Средняя_цена,
       SUM(price * amount) AS Стоимость
  FROM library_three
 WHERE amount BETWEEN 5 AND 14;

---

/*
Посчитать стоимость всех экземпляров каждого автора без учета книг «Идиот» и «Белая гвардия».
В результат включить только тех авторов, у которых суммарная стоимость книг (без учета книг «Идиот» и «Белая гвардия»)
более 5000 руб. Вычисляемый столбец назвать Стоимость. Результат отсортировать по убыванию стоимости.
*/

SELECT author,
    SUM(price * amount) AS Стоимость
  FROM library_three
 WHERE title NOT IN ('Идиот','Белая гвардия')
 GROUP BY author
HAVING SUM(price * amount) > 5000
 ORDER BY Стоимость DESC;