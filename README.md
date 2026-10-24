# SQL Sandbox

Песочница с SQL-скриптами на **PostgreSQL**: схемы, таблицы, выборки, фильтрация, выражения и работа с данными.
Репозиторий активно пополняется — новые темы и примеры добавляются по мере появления.

## Стек

- PostgreSQL (запуск в Docker)
- IntelliJ IDEA (Database tools)
- Оформление кода по [SQL Style Guide](https://www.sqlstyle.guide/ru/)

## Что уже есть в репозитории

| Тема                      | Что показано в коде                                                                                                             |
|---------------------------|-------------------------------------------------------------------------------------------------------------------------------- |
| **Схемы и таблицы (DDL)** | `CREATE SCHEMA`, `SET search_path`, `CREATE TABLE`, `DROP TABLE IF EXISTS`, идемпотентные скрипты, `ALTER TABLE ... ADD COLUMN` |
| **Типы данных**           | `SERIAL`, `VARCHAR`, `TEXT`, `INT`, `NUMERIC(p, s)`, `DATE`, массивы (`TEXT[]`), `JSONB`                                        |
| **Ограничения**           | `PRIMARY KEY`, `FOREIGN KEY` (`REFERENCES`), `NOT NULL`, `DEFAULT`                                                              |
| **DML**                   | `INSERT` (одиночный и множественный), `SELECT`, `UPDATE` с `WHERE`, псевдонимы таблиц (`AS`)                                    |
| **Фильтрация**            | `WHERE`, `AND` / `OR`, `IN`, `BETWEEN`, сравнения                                                                               |
| **Поиск по шаблону**      | `LIKE` с `%`                                                                                                                    |
| **Выражения**             | `CASE WHEN ... THEN ... ELSE ... END`, `ROUND`, арифметика над столбцами, конкатенация `\|\|`, `REPLACE`                        |
| **Сортировка**            | `ORDER BY` по нескольким столбцам, `ASC` / `DESC`                                                                               |
| **Связи между таблицами** | пример `departments` → `employees` через внешний ключ                                                                           |

## Как запустить

docker run --name my-postgres \
    -e POSTGRES_PASSWORD=mysecretpassword \
    -p 5432:5432 \
    -d postgres

Подключитесь к базе любым клиентом (IntelliJ IDEA, pgAdmin, `psql`) и выполняйте скрипты.
Все скрипты можно запускать повторно: перед созданием таблицы выполняется `DROP TABLE IF EXISTS`.
