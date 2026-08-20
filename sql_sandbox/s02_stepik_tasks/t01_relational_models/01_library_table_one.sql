/* =====================================================
  Курс: Stepik (Основы SQL)
  Модуль: 1.1 Реляционные модели
  Задача: Создать таблицу book
  Условие: Создать таблицу с полями title, author, price...
===================================================== */

-- 1. Создаем изолированную "коробку" для Степика (сработает один раз)
CREATE SCHEMA IF NOT EXISTS stepik;

-- 2. Переключаем наш фокус в эту коробку (чтобы не мусорить в public)
SET search_path TO stepik;

-- 3. Сносим старую таблицу, если переделываем задачу
DROP TABLE IF EXISTS library_one;

-- 4. Твой код для задачи
CREATE TABLE library_one (
    PRIMARY KEY (book_id),
    book_id SERIAL       NOT NULL,
    title   VARCHAR(50)  NOT NULL,
    author  VARCHAR(30)  NOT NULL,
    price   DECIMAL(8,2) NOT NULL,
    amount  INT          NOT NULL
);

-- 5. Проверка (как это выглядит у нас)
INSERT INTO library_one (title, author, price, amount)
    VALUES ('Белая гвардия','Булгаков М.А',540.50,5),
           ('Мастер и Маргарита', 'Булгаков М.А.', 670.99, 3),
           ('Идиот','Достоевский Ф.М.',460.00,10),
           ('Братья Карамазовы','Достоевский Ф.М.',799.01,2);

UPDATE library_one
   SET title = 'Не идиот!'
 WHERE title = 'Идиот'
   AND price = 460.00;

SELECT * FROM library_one;