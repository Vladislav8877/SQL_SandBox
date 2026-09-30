CREATE SCHEMA IF NOT EXISTS joins_practice;
SET search_path TO joins_practice;

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS teachers;

-- Таблица А (условно "левая")
CREATE TABLE students (
    PRIMARY KEY (student_id),
    student_id    SERIAL       NOT NULL,
    student_name  VARCHAR(50)  NOT NULL
);

-- Таблица Б (условно "правая")
CREATE TABLE enrollments (
    PRIMARY KEY (enrollment_id),
    enrollment_id  SERIAL      NOT NULL,
    student_id     INT         REFERENCES students (student_id),
    course_name    VARCHAR(50) NOT NULL
);

CREATE TABLE teachers (
    PRIMARY KEY (teacher_id),
    teacher_id   SERIAL      NOT NULL,
    teacher_name VARCHAR(50) NOT NULL,
    course_name  VARCHAR(50) NOT NULL
);

INSERT INTO students (student_name)
    VALUES ('Влад'),      -- id = 1, есть запись на курс
           ('Никита'),    -- id = 2, есть запись на курс
           ('Света'),     -- id = 3, есть запись на курс
           ('Игорь');     -- id = 4, НЕТ ни одной записи на курс

INSERT INTO enrollments (student_id, course_name)
    VALUES (1, 'SQL'),
           (1, 'Java'),      -- у Влада ДВЕ записи -> увидим размножение строк
           (2, 'Python'),
           (3, 'SQL'),
           (NULL, 'Docker'); -- "ничья" запись, студента с таким id не существует

INSERT INTO teachers (teacher_name, course_name)
    VALUES ('Петров','SQL'),
           ('Сидоров','Java'),
           ('Кузнецов','Python');


SELECT s.student_name,
       e.course_name
  FROM students AS s
  JOIN enrollments AS e
ON s.student_id = e.student_id;
-- Главный вывод про INNER JOIN: пропадает всё, что не нашло пару с обеих сторон.

----- ----- ----- ----- -----

SELECT s.student_name,
       e.course_name
  FROM students AS s
  LEFT JOIN enrollments AS e
ON s.student_id = e.student_id;
-- Мысленная модель LEFT JOIN: "покажи мне ВСЕХ студентов, а курсы подставь, если они есть".
-- Ничего из левой таблицы никогда не потеряется.

SELECT s.student_name,
       e.course_name
  FROM students AS s
  LEFT JOIN enrollments AS e
ON s.student_id = e.student_id
 WHERE e.enrollment_id IS NULL;
-- «Найди записи левой таблицы, которым ничего не соответствует в правой таблице».
-- NULL проверяем у правой таблице

----- ----- ----- -----

SELECT s.student_name,
       e.course_name
  FROM students AS s
 RIGHT JOIN enrollments AS e
ON s.student_id = e.student_id;

SELECT s.student_name,
       e.course_name
FROM students AS s
RIGHT JOIN enrollments AS e
ON s.student_id = e.student_id
WHERE s.student_id IS NULL;

SELECT s.student_name,
       e.course_name
FROM enrollments AS e
LEFT JOIN students AS s
ON s.student_id = e.student_id;

SELECT s.student_name,
       e.course_name
  FROM students AS s
  LEFT JOIN enrollments AS e
ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

----- ----- ----- -----

SELECT s.student_name,
       e.course_name
  FROM students AS s
  FULL JOIN enrollments AS e
ON s.student_id = e.student_id;
-- FULL JOIN = взять результат INNER JOIN + добавить "сирот" слева (как LEFT) + добавить "сирот" справа (как RIGHT).
-- Никто не теряется ни с одной стороны.

----- ----- ----- -----

SELECT s.student_name,
       e.course_name
  FROM students AS s
 CROSS JOIN enrollments AS e;
-- декартовое произведение.

SELECT COUNT(*)
  FROM students AS s
 CROSS JOIN enrollments AS e;

-------------------------

SELECT s.student_name,
       e.course_name,
       t.teacher_name
  FROM students AS s
  JOIN enrollments AS e
ON s.student_id = e.student_id
  LEFT JOIN teachers AS t
    ON e.course_name = t.course_name
 ORDER BY s.student_name;

SELECT s.student_name,
       COUNT(*) AS course_count
  FROM students AS s
  LEFT JOIN enrollments AS e
ON s.student_id = e.student_id
 GROUP BY s.student_name
 ORDER BY course_count DESC;

/*
Напиши свой запрос: найди все курсы (enrollments), у которых нет реального студента
(то есть student_id IS NULL после JOIN) — паттерн "поиска сирот", но в обратную сторону от Шага 2
(используй RIGHT JOIN или разверни через LEFT JOIN).
*/

SELECT e.course_name,
       s.student_name
  FROM enrollments AS e
  LEFT JOIN students AS s
ON s.student_id = e.student_id
 WHERE s.student_id IS NULL;

/*
Напиши запрос по трём таблицам (students, enrollments, teachers),
который покажет только тех студентов, кто учится у Петрова.
*/

SELECT s.student_name,
       e.course_name,
       t.teacher_name
  FROM students AS s
  JOIN enrollments AS e
ON s.student_id = e.student_id
  JOIN teachers AS t
    ON e.course_name = t.course_name
 WHERE t.teacher_name = 'Петров';