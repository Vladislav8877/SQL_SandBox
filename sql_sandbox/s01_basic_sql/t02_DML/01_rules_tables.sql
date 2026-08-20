-- 1. Справочник отделов
CREATE TABLE departments (
    PRIMARY KEY (department_id),
    department_id   SERIAL NOT NULL,
    department_name TEXT   NOT NULL
);

-- 2. Таблица сотрудников с внешним ключом
CREATE TABLE employees (
    PRIMARY KEY (employee_id),
    employee_id   SERIAL      NOT NULL,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    department_id INT         REFERENCES departments (department_id)
);