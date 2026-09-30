CREATE SCHEMA IF NOT EXISTS basic_sql;
SET search_path TO basic_sql;

DROP TABLE IF EXISTS bad_table;
DROP TABLE IF EXISTS employees_it;
DROP TABLE IF EXISTS departmens_it;

CREATE TABLE bad_table (
    PRIMARY KEY (employee_id),
    employee_id        SERIAL      NOT NULL,
    employee_name      VARCHAR(30) NOT NULL,
    department_name    VARCHAR(30) NOT NULL,
    department_address VARCHAR(50) NOT NULL
);

INSERT INTO bad_table (employee_name, department_name, department_address)
    VALUES ('Vlad','Backend','Moscow'),
           ('Nikita','Backend','Moscow'),
           ('Julia','Frontend','Piter'),
           ('Goga','Frontend','Piter'),
           ('Albert','Sales','Rostov');


CREATE TABLE employees_it (
    PRIMARY KEY (employee_id),
    employee_id   SERIAL      NOT NULL,
    employee_name VARCHAR(30) NOT NULL,
    department_id INT         NOT NULL REFERENCES departments(department_id)
);

CREATE TABLE departments_it (
    PRIMARY KEY (department_id),
    department_id      SERIAL      NOT NULL,
    department_name    VARCHAR(30) NOT NULL,
    department_address VARCHAR(30) NOT NULL
);

INSERT INTO employees_it (employee_name, department_id)
    VALUES ('Vlad',1),
           ('Nikita',1),
           ('Julia',2),
           ('Goga',2),
           ('Albert',3);

INSERT INTO departments_it (department_name, department_address)
    VALUES ('Backend','Moscow'),
           ('Frontend','Piter'),
           ('Sales','Rostov');

