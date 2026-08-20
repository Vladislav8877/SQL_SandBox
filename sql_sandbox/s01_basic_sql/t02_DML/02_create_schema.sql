CREATE SCHEMA company;

CREATE TABLE company.employees (
    PRIMARY KEY (employee_id),
    employee_id SERIAL      NOT NULL,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL
);

ALTER TABLE company.employees
    ADD COLUMN skills     TEXT[],
    ADD COLUMN extra_info JSONB;
/*
Мы добавили колонку skills, объявив ее как массив строк (тип TEXT с суффиксом []).
Мы добавили колонку extra_info, объявив ее как бинарный JSON (JSONB).
*/

INSERT INTO company.employees (first_name, last_name, skills, extra_info)
     VALUES (
            'bob',
            'brown',
            '{"Java","SQL","Docker"}',
            '{"hobbies":["gaming","photography"],"experience_years":5}'::jsonb
            );

UPDATE company.employees
   SET skills = '{"Java","SQL","Kubernetes"}'
 WHERE first_name = 'Bob';

/*
Если бы в таблице employees был столбец manager_id, ссылающийся на employee_id в этой же таблице:

UPDATE company.employees
   SET manager_id = 1;
 WHERE first_name = 'Bob';

СУБД проверит, существует ли в этой таблице сотрудник с id = 1.
Если такого сотрудника нет,
транзакция будет отклонена из-за нарушения ссылочной целостности (ошибка нарушения Foreign Key).
*/

