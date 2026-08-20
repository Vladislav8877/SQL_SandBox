/* =====================================================
  Тема: Создание таблицы пользователей и вставка данных
  Паттерн: Style Guide Саймона Холиуэлла
===================================================== */

-- Создаем схему темы и переключаемся на нее
CREATE SCHEMA IF NOT EXISTS basic_sql;
SET search_path TO basic_sql;

-- 1. Снос таблицы перед созданием (чтобы скрипт можно было запускать много раз)
DROP TABLE IF EXISTS users;

-- 2. Создание структуры таблицы
CREATE TABLE users (
    PRIMARY KEY (user_id),
    user_id   SERIAL       NOT NULL,
    name      VARCHAR(50)  NOT NULL,
    date      DATE         DEFAULT CURRENT_DATE
);

-- 3. Заполнение тестовыми данными
INSERT INTO users (name)
     VALUES ('Vladislav'),
            ('Nikita'),
            ('Sveta');

-- 4. Вывод результата
SELECT u.user_id,
       u.name,
       u.date
  FROM users AS u;