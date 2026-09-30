CREATE SCHEMA IF NOT EXISTS basic_sql;
SET search_path TO basic_sql;

DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- 1. Таблица отделов
CREATE TABLE departments (
    PRIMARY KEY (department_id),
    department_id   SERIAL        NOT NULL,
    department_name VARCHAR(50)   NOT NULL,
    budget          NUMERIC(12,2) NOT NULL
);

-- 2. Таблица сотрудников (manager_id -- self-reference для будущих примеров)
CREATE TABLE employees (
    PRIMARY KEY (employee_id),
    employee_id   SERIAL        NOT NULL,
    name          VARCHAR(50)   NOT NULL,
    department_id INT           REFERENCES departments (department_id),
    salary        NUMERIC(10,2) NOT NULL,
    manager_id    INT           REFERENCES employees (employee_id)
);

-- 3. Заполнение отделов
--Marketing намеренно останется без сотрудников (edge case для EXISTS/NOT EXISTS)
INSERT INTO departments (department_name, budget)
    VALUES ('Engineering', 500000.00),
           ('Sales',       200000.00),
           ('HR',           80000.00),
           ('Marketing',   150000.00);

-- 4. Заполнение сотрудников
--    Zoe намеренно без отдела (department_id = NULL) -- edge case для NOT IN
INSERT INTO employees (name, department_id, salary, manager_id)
    VALUES ('Ivan',   1, 90000.00, NULL),
           ('Petr',   1, 75000.00, 1),
           ('Anna',   1, 60000.00, 1),
           ('Olga',   2, 65000.00, NULL),
           ('Boris',  2, 55000.00, 4),
           ('Sergey', 3, 50000.00, NULL),
           ('Zoe',    NULL, 45000.00, NULL);


/* =====================================================
   БЛОК А. Скалярный подзапрос в WHERE (некоррелированный)
   Задача: сотрудники с зарплатой выше средней по компании
   =====================================================
*/

SELECT name
  FROM employees
 WHERE salary > (SELECT AVG(salary) FROM employees);
-- Разбор: подзапрос считает AVG(salary) один раз (не зависит от employees
-- во внешнем запросе), возвращает одно число, внешний WHERE сравнивает
-- salary каждой строки с этим числом.

/* =====================================================
   БЛОК Б. Коррелированный подзапрос в WHERE
   Задача: сотрудники, чья зарплата выше средней ИМЕННО ИХ отдела
   =====================================================
*/

SELECT e1.name,
       e1.department_id,
       e1.salary
  FROM employees AS e1
 WHERE e1.salary > (SELECT AVG(salary)
                   FROM employees AS e2
                   WHERE e2.department_id = e1.department_id
                   );

/* =====================================================
   БЛОК К. IN -- сотрудники из "дорогих" отделов (budget > 150000)
   =====================================================
*/

SELECT name,
       department_id
  FROM employees
 WHERE department_id IN (SELECT department_id
                           FROM departments
                          WHERE budget > 150000
                        );

SELECT name
  FROM employees
 WHERE department_id IN (SELECT department_id
                           FROM departments
                          WHERE budget > 100000
                        );


/* =====================================================
   БЛОК И. ANY и ALL
   =====================================================
*/

SELECT name,
       salary
  FROM employees
 WHERE salary > ANY (SELECT salary
                       FROM employees
                      WHERE department_id = 2
                    );

SELECT name,
       salary
  FROM employees
 WHERE salary > ALL (SELECT salary
                       FROM employees
                      WHERE department_id = 2
                    );

/* =====================================================
   БЛОК Г. Скалярный подзапрос в SELECT
   Задача: показать зарплату сотрудника рядом со средней по компании
   =====================================================
*/

SELECT e.name,
       e.salary,
       (SELECT ROUND(AVG(salary),2) FROM employees) AS company_avg
  FROM employees AS e;


SELECT e.name,
       e.salary,
       (SELECT ROUND(AVG(salary),2) FROM employees) AS company_avg,
       e.salary - (SELECT ROUND(AVG(salary),2) FROM employees) AS diff_from_avg
FROM employees AS e;


/* =====================================================
   БЛОК В. Подзапрос в FROM (derived table)
   Задача: показать только те отделы, где средняя зарплата > 60000
  =====================================================
*/

SELECT dept_avg.department_id,
       dept_avg.avg_salary
  FROM (SELECT department_id,
               AVG(salary) AS avg_salary
          FROM employees
         WHERE department_id IS NOT NULL
      GROUP BY department_id) AS dept_avg
 ORDER BY department_id;


SELECT avg_table.department_id,
       avg_table.avg_salary
  FROM (SELECT department_id,
               AVG(salary) AS avg_salary
          FROM employees
      GROUP BY department_id
        HAVING AVG(salary) > 60000) AS avg_table;


SELECT avg_table.department_id,
       avg_table.avg_salary
  FROM (SELECT department_id,
               AVG(salary) AS avg_salary
          FROM employees
      GROUP BY department_id) AS avg_table
 WHERE avg_table.avg_salary > 50000
 ORDER BY department_id;

/* =====================================================
   БЛОК Д. EXISTS -- отделы, в которых ЕСТЬ сотрудники
  =====================================================
*/

SELECT d.department_name
  FROM departments AS d
 WHERE EXISTS (SELECT 1
                 FROM employees AS e
                WHERE e.department_id = d.department_id);

SELECT d.department_name
  FROM departments AS d
 WHERE NOT EXISTS (SELECT 1
                     FROM employees AS e
                    WHERE e.department_id = d.department_id);

/*
SELECT name
  FROM employees
 WHERE department_id NOT IN (SELECT department_id FROM departments);

ЭТО ЛОВУШКА ТАК ПИСАТЬ НЕЛЬЗЯ, ЕСЛИ ВЕРНЕТСЯ ХОТЬ ОДИН NULL
ТО ВСЯ ЦЕОПЧКА ПРОВЕРКИ NOT NULL БУДЕТ UNKNOWN И СТРОКИ ОТБРОСЯТСЯ

НУЖНО ВСЕГДА ИСПОЛЬЗОВАТЬ NOT EXISTS (SELECT 1) ЕСЛИ ЕСТЬ ХОТЬ ОДИН МАЛЕЙШИЙ
ШАНС УВИДЕТЬ NULL
*/


/* =====================================================
   ==================  ЗАДАНИЯ  =========================
   Пиши решения ниже, каждое отдельным блоком с комментарием.
   =====================================================
*/
-- ЗАДАНИЕ 1 (скалярный подзапрос в WHERE, некоррелированный)
-- Найди сотрудников с зарплатой СТРОГО НИЖЕ средней зарплаты по компании.

SELECT department_id,
       name,
       salary
  FROM employees
 WHERE salary < (SELECT AVG(salary)
                   FROM employees);

-- ЗАДАНИЕ 2 (подзапрос в FROM)
-- Выведи department_id и максимальную зарплату (MAX) по каждому отделу,
-- но только для отделов, где максимальная зарплата больше 60000.
-- Обязательно через производную таблицу (подзапрос в FROM), не через HAVING.

SELECT e.department_id,
       e.max_salary
  FROM (SELECT department_id,
             MAX(salary) AS max_salary
        FROM employees
       GROUP BY department_id
      HAVING MAX(salary) > 60000) AS e
 ORDER BY max_salary DESC;

-- ЗАДАНИЕ 3 (EXISTS, коррелированный)
-- Найди сотрудников, которые являются менеджерами (manager_id) хотя бы
-- для одного другого сотрудника. Используй EXISTS.
-- Подсказка: подзапрос должен проверять employees AS sub
-- WHERE sub.manager_id = outer.employee_id.

SELECT out.employee_id,
       out.name
  FROM employees AS out
 WHERE EXISTS (SELECT 1
                 FROM employees AS sub
                WHERE sub.manager_id = out.employee_id);

-- ЗАДАНИЕ 4 (коррелированный подзапрос, посложнее)
-- Найди сотрудников, чья зарплата является МАКСИМАЛЬНОЙ в их отделе
-- (то есть "лучшая зарплата" в каждом отделе).
-- Подсказка: сравни e.salary с (SELECT MAX(salary) FROM employees
-- WHERE department_id = e.department_id).


SELECT e.department_id,
       e.name,
       e.salary
  FROM employees AS e
 WHERE e.salary = (SELECT MAX(salary)
                    FROM employees
                   WHERE department_id = e.department_id);

-- ЗАДАНИЕ 5 (на понимание ловушки NULL, комментарием текстом, без кода)
-- Объясни своими словами: почему BLOK З вернул пустой результат,
-- хотя логически должен был вернуть Marketing? Опиши в комментарии,
-- как именно NULL "заражает" цепочку AND внутри NOT IN.

SELECT d.department_name
FROM departments AS d
WHERE d.department_id NOT IN (SELECT e.department_id FROM employees AS e);
-- Потому что employees.department_id содержит NULL (строка Zoe).
-- Подзапрос возвращает список: {1, 1, 1, 2, 2, 3, NULL}.
-- Проверка d.department_id NOT IN (1, 1, 1, 2, 2, 3, NULL) внутренне
-- разворачивается как:
--   d.department_id <> 1 AND d.department_id <> 1 AND ... AND d.department_id <> NULL
-- Любое сравнение "x <> NULL" даёт UNKNOWN, а UNKNOWN в цепочке AND
-- "заражает" весь результат -> WHERE никогда не становится TRUE.
-- ВЫВОД: используй NOT EXISTS (см. БЛОК Е), если есть шанс NULL
-- в колонке подзапроса.