CREATE SCHEMA IF NOT EXISTS stepik;
SET search_path TO stepik;
DROP TABLE IF EXISTS book;

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
           ('Стихотворение и поэмы','Есенин С.А.',650.00,15),
           ('Игрок','Достоевский Ф.М.',480.50,10);


SELECT title,
       author,
       price,
       amount
  FROM book
 WHERE price = (SELECT MIN(price)
                 FROM book
                 );

SELECT author,
       title,
       price
  FROM book
 WHERE price <= (SELECT AVG(price)
                   FROM book)
 ORDER BY price DESC;

----- ----- ----- ----- -----

SELECT title,
       author,
       amount
  FROM book
 WHERE ABS(amount - (SELECT AVG(amount) FROM book)) > 3;

SELECT author,
       title,
       price
  FROM book
 WHERE price <= (SELECT MIN(price) + 150 FROM book)
 ORDER BY price;

----- ----- ----- -----

SELECT title,
       author,
       amount
  FROM book
  WHERE author IN (SELECT author
                     FROM book
                    GROUP BY author
                   HAVING SUM(amount) >= 12
                 );

SELECT author,
       title,
       amount
  FROM book
 WHERE amount IN (SELECT amount
                    FROM book
                   GROUP BY amount
                  HAVING COUNT(amount) = 1
                  );

----- ----- ----- -----

SELECT title,
       author,
       amount
  FROM book
 WHERE amount < ALL (SELECT AVG(amount)
                       FROM book
                      GROUP BY author
                    );

SELECT title,
       author,
       amount
FROM book
WHERE amount < ANY (SELECT AVG(amount)
                    FROM book
                    GROUP BY author);

SELECT author,
       title,
       price
  FROM book
  WHERE price < ANY (SELECT MIN(price)
                     from book
                     GROUP BY author
                   );

----- ----- ----- -----

SELECT title,
       author,
       amount,
       (SELECT MAX(amount) FROM book) - amount AS Заказ
  FROM book
 WHERE amount < ALL (SELECT MAX(amount)
                      FROM book);