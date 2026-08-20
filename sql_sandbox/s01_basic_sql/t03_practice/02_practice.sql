CREATE SCHEMA IF NOT EXISTS cinema_app;
SET search_path TO cinema_app;
DROP TABLE IF EXISTS movies;

CREATE TABLE movies (
    PRIMARY KEY(movie_id),
    movie_id     SERIAL,
    title        VARCHAR(100)  NOT NULL,
    director     VARCHAR(50)   NOT NULL,
    genre        VARCHAR(50)   NOT NULL,
    rating       NUMERIC(3,1)  NOT NULL,
    duration_min INT           NOT NULL,
    ticket_price NUMERIC(10,2) NOT NULL
);

INSERT INTO movies (title, director, genre, rating, duration_min, ticket_price)
     VALUES ('The Dark Knight',    'Christopher Nolan', 'Action', 9.0, 152, 500.00),
            ('Interstellar',       'Christopher Nolan', 'Sci-Fi', 8.6, 169, 450.00),
            ('Pulp Fiction',       'Quentin Tarantino', 'Crime',  8.9, 154, 400.00),
            ('Kill Bill: Vol. 1',  'Quentin Tarantino', 'Action', 8.1, 111, 350.00),
            ('The Matrix',         'Lana Wachowski',    'Sci-Fi', 8.7, 136, 300.00),
            ('Dune: Part One',     'Denis Villeneuve',  'Sci-Fi', 8.0, 155, 600.00),
            ('Mad Max: Fury Road', 'George Miller',     'Action', 8.1, 120, 400.00);

SELECT title,
       director,
       genre
  FROM movies
 WHERE rating > 8.5
   AND genre IN ('Action', 'Sci-Fi');

SELECT title,
       director
  FROM movies
 WHERE title LIKE 'The%' OR director LIKE '%Q%';

SELECT title,
       duration_min,
       ticket_price,
       ROUND(
           CASE
               WHEN duration_min > 150 THEN ticket_price + (ticket_price * 0.2)
               ELSE ticket_price - (ticket_price * 0.1) -- ticket_price * 0.9
           END, 2) AS new_price
FROM movies;

SELECT title,
       genre,
       rating
  FROM movies
 ORDER BY genre, rating DESC;

UPDATE movies
   SET title = title || ' (Хит)'
 WHERE director = 'Christopher Nolan';

UPDATE movies
   SET title = REPLACE(title, ' (Хит', ' (Хит)')
WHERE director = 'Christopher Nolan'; -- ну или просто снести через exists как всегда делаю в песочнице
