CREATE SCHEMA IF NOT EXISTS stepik;
SET search_path TO stepik;

DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS supply;

CREATE TABLE book (
    PRIMARY KEY (book_id),
    book_id SERIAL       NOT NULL,
    title   VARCHAR(50)  NOT NULL,
    author  VARCHAR(30)  NOT NULL,
    price   DECIMAL(8,2) NOT NULL,
    amount  INT          NOT NULL
);

INSERT INTO book (title, author, price, amount)
    VALUES ('Белая гвардия','Булгаков М.А.',540.50,5),
           ('Мастер и Маргарита', 'Булгаков М.А.', 670.99, 3),
           ('Идиот','Достоевский Ф.М.',460.00,10),
           ('Братья Карамазовы','Достоевский Ф.М.',799.01,3),
           ('Стихотворение и поэмы','Есенин С.А.',650.00,15);

CREATE TABLE supply (
    PRIMARY KEY (supply_id),
    supply_id SERIAL NOT NULL,
    title VARCHAR(50) NOT NULL,
    author VARCHAR(50) NOT NULL,
    price DECIMAL(8,2) NOT NULL,
    amount INT NOT NULL);

INSERT INTO supply (title, author, price, amount)
    VALUES ('Лирика','Пастернак Б.Л.',518.99,2),
           ('Черный человек','Есенин С.А.',570.20,6),
           ('Белая гвардия','Булгаков М.А.',540.50,7),
           ('Идиот','Достоевский Ф.М.',360.80,3);

INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount
  FROM supply;


INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount
  FROM supply
 WHERE author NOT IN ('Булгаков М.А.','Достоевский Ф.М.');

INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount
  FROM supply
 WHERE author NOT IN (SELECT author
                     FROM book);

SELECT * FROM book;
