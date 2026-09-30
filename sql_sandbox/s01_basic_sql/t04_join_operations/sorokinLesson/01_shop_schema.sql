CREATE SCHEMA IF NOT EXISTS joins_practice;
SET search_path TO joins_practice;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

-- 1. Таблица покупателей
CREATE TABLE users (
    PRIMARY KEY (user_id),
    user_id       SERIAL       NOT NULL,
    user_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(100) UNIQUE,
    registered_at DATE         DEFAULT CURRENT_DATE
);

-- 2. Таблица товаров
CREATE TABLE products (
    PRIMARY KEY (product_id),
    product_id   SERIAL        NOT NULL,
    product_name VARCHAR(100)  NOT NULL,
    category     VARCHAR(50),
    price        NUMERIC(10,2) CHECK(price >= 0)
);

-- 3. Таблица заказов (Связь 1:N к users)
CREATE TABLE orders (
    PRIMARY KEY (order_id),
    order_id   SERIAL NOT NULL,
    user_id    INT    NOT NULL REFERENCES users (user_id),
    order_date DATE   DEFAULT CURRENT_DATE
);

-- 4. Таблица состава заказов (Связь M:N между orders и products)
CREATE TABLE order_items (
    PRIMARY KEY (order_id, product_id),
    order_id   INT NOT NULL REFERENCES orders (order_id),
    product_id INT NOT NULL REFERENCES products (product_id),
    quantity   INT CHECK (quantity > 0) DEFAULT 1
);

-- --- НАПОЛНЕНИЕ ДАННЫМИ ---
INSERT INTO users (user_name, email)
    VALUES ('Иван Иванов', 'ivan@mail.com'),
           ('Анна Смирнова', 'anna@mail.com'),
           ('Петр Петров', 'petr@mail.com'); -- Петр пока ничего не купил

INSERT INTO products (product_name, category, price)
    VALUES ('Ноутбук Dell', 'Electronics', 1200.00),
           ('Мышка Logitech', 'Electronics', 50.00),
           ('Стол IKEA', 'Furniture', 150.00),
           ('Кофемашина', 'Appliances', 300.00); -- Кофемашину никто не купил

INSERT INTO orders (user_id, order_date)
    VALUES (1, '2025-10-01'), -- Заказ Ивана
           (1, '2025-10-05'), -- Еще заказ Ивана
           (2, '2025-10-02'); -- Заказ Анны

INSERT INTO order_items (order_id, product_id, quantity)
    VALUES (1, 1, 1), -- В первом заказе Ивана: 1 ноутбук
           (1, 2, 2), -- В первом заказе Ивана: 2 мышки
           (2, 3, 1), -- Во втором заказе Ивана: 1 стол
           (3, 1, 1); -- В заказе Анны: 1 ноутбук