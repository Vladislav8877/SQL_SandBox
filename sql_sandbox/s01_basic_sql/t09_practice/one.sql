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

/*
SELECT name
  FROM employees
 WHERE department_id NOT IN (SELECT department_id FROM departments);

ЭТО ЛОВУШКА ТАК ПИСАТЬ НЕЛЬЗЯ, ЕСЛИ ВЕРНЕТСЯ ХОТЬ ОДИН NULL
ТО ВСЯ ЦЕОПЧКА ПРОВЕРКИ NOT NULL БУДЕТ UNKNOWN И СТРОКИ ОТБРОСЯТСЯ

НУЖНО ВСЕГДА ИСПОЛЬЗОВАТЬ NOT EXISTS (SELECT 1) ЕСЛИ ЕСТЬ ХОТЬ ОДИН МАЛЕЙШИЙ
ШАНС УВИДЕТЬ NULL
 */

