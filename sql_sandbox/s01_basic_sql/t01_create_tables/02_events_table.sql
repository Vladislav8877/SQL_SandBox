-- Создаем схему темы и переключаемся на нее
CREATE SCHEMA IF NOT EXISTS basic_sql;
SET search_path TO basic_sql;

-- 1. Снос таблицы перед созданием (чтобы скрипт можно было запускать много раз)
DROP TABLE IF EXISTS events;

-- 2. Создание структуры таблицы
CREATE TABLE events (
    PRIMARY KEY (event_id),
    event_id SERIAL       NOT NULL,
    name     VARCHAR(100) NOT NULL,
    date     DATE         DEFAULT CURRENT_DATE
);

-- 3. Заполнение тестовыми данными
INSERT INTO events (name)
     VALUES ('meet on SQL');

-- 4. Вывод результата
SELECT e.event_id,
       e.name,
       e.date
  FROM events AS e;

