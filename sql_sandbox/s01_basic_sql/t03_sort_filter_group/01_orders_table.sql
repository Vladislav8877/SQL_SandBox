CREATE SCHEMA IF NOT EXISTS basic_sql;
SET search_path TO basic_sql;
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    PRIMARY KEY (order_id),
    order_id     SERIAL,
    product_name TEXT          NOT NULL,
    category     TEXT          NOT NULL,
    price        NUMERIC(10,2) CHECK (price >= 0),
    quantity     INT           CHECK (quantity > 0),
    order_date   DATE          DEFAULT CURRENT_DATE
);

INSERT INTO orders (product_name, category, price, quantity, order_date)
    VALUES ('Smartphone X', 'Electronics', 699.99,  2, '2025-01-05'),
           ('Laptop Pro',   'Electronics', 1299.50, 1, '2025-01-06'),
           ('Coffee Beans', 'Groceries',   9.99,    3, '2025-01-07'),
           ('OLED TV',      'Electronics', 1799.00, 1, '2025-01-07'),
           ('Green Tea',    'Groceries',   4.99,    5, '2025-01-08'),
           ('Office Chair', 'Furniture',   149.00,  2, '2025-01-09'),
           ('Desk Lamp',    'Furniture',   29.99,   1, '2025-01-09'),
           ('Water Filter', 'Groceries',   25.00,   2, '2025-01-10');

SELECT product_name,
       price
  FROM orders
 ORDER BY price;
-- Сначала пойдут товары с минимальной ценой, затем — с большей. ASC — по возрастанию (по умолчанию). DESC — по убыванию.

SELECT product_name,
       category,
       price,
       order_date
  FROM orders
 ORDER BY category, price DESC;
/*
Сначала упорядочим по категории (по возрастанию: Electronics, Furniture, Groceries),
а внутри каждой категории — по цене (по убыванию)
*/

SELECT product_name,
       price,
       order_date
  FROM orders
 ORDER BY order_date DESC NULLS LAST;

/*
В PostgreSQL можно управлять положением NULL: ORDER BY column NULLS FIRST или NULLS LAST.
По умолчанию NULL считается "больше всех остальных значений", поэтому при ASC он окажется в конце, а при DESC — в начале.
*/

/*
Здесь я явно указываю NULLS LAST — если бы в order_date были пустые значения (заказ ещё не оформлен до конца),
они бы гарантированно оказались в конце списка, а не перемешались с реальными датами.
*/

-----

SELECT product_name,
       price
  FROM orders
 WHERE price > 500
 ORDER BY price DESC;

-----

SELECT product_name,
       category,
       price
  FROM orders
 WHERE category = 'Electronics'
   AND price < 1000;

-----

SELECT product_name,
       price
  FROM orders
 WHERE price BETWEEN 10 AND 200;
-- Все товары, цена которых в диапазоне [10..200].

-----

SELECT product_name
  FROM orders
 WHERE product_name ILIKE '%desk%';

-----

SELECT product_name,
       category
  FROM orders
 WHERE category IN ('Furniture', 'Groceries');
-- Выберем товары только из категорий Мебель и Продукты.

-----

SELECT product_name
  FROM orders
 WHERE product_name ~* 'coffee|tea';
-- Знак ~* означает «регистронезависимый поиск» по шаблону. Здесь мы ищем названия, содержащие «coffee» или «tea».

SELECT product_name,
       category,
       quantity,
       order_date
  FROM orders
 WHERE order_date > '2025-01-06'
   AND quantity > 1
   AND category <> 'Groceries';
-- AND category <> 'Groceries' — оператор <> означает "не равно".

----- ----- ----- ----- -----

SELECT category,
       SUM(price * quantity) AS total_revenue
  FROM orders
 GROUP BY category;

/*
GROUP BY category — база данных просматривает всю таблицу и собирает все товары в три виртуальные "корзины":
Electronics, Groceries, Furniture.

SUM(price * quantity) — база залезает в каждую "корзину", для каждого товара умножает цену на количество,
а затем складывает эти произведения в единую сумму.
*/

SELECT category,
       COUNT(*) AS order_count
  FROM orders
 GROUP BY category;

SELECT COUNT(DISTINCT category) AS distinct_cats
  FROM orders;
/*
Здесь нет GROUP BY, значит база считает всю таблицу одной огромной группой.
COUNT(DISTINCT category) — база смотрит на колонку category, видит там повторения, отбрасывает дубликаты и отвечает:
"Здесь всего 3 уникальные категории".
*/

SELECT category,
       MAX(price)             AS max_price,
       MIN(price)             AS min_price,
       ROUND(AVG(quantity),2) AS avg_qty
  FROM orders
 GROUP BY category;

SELECT category,
       COUNT(*)            AS total_orders,
       ROUND(AVG(price),2) AS avg_price,
       MAX(price)          AS max_price,
       MIN(price)          AS min_price
  FROM orders
 GROUP BY category;

----- ----- ----- ----- -----

SELECT category,
       SUM(price * quantity) AS total_revenue
  FROM orders
 GROUP BY category
HAVING SUM(price * quantity) > 1000
 ORDER BY total_revenue DESC;

SELECT category,
       SUM(price * quantity) AS total_revenue,
       COUNT(*)              AS orders_count
  FROM orders
 GROUP BY category
HAVING SUM(price * quantity) > 100
 ORDER BY total_revenue DESC;

------------------------------
/*
напиши запрос, который выведет product_name, category, price для всех товаров,
у которых цена находится в диапазоне от 20 до 800, ИЛИ название товара содержит слово "Tea" (без учёта регистра).
Результат отсортируй по цене по убыванию.
 */
SELECT product_name,
       category,
       price
  FROM orders
 WHERE price BETWEEN 20 AND 800
    OR product_name ~* 'Tea'
 ORDER BY price DESC;

---

/*
Напиши запрос с группировкой: выведи для каждой категории среднюю цену товара (округли до 2 знаков),
но покажи только те категории, где средняя цена больше 50. Результат отсортируй по средней цене по возрастанию.
 */
SELECT category,
       ROUND(AVG(price),2) AS avg_price
  FROM orders
 GROUP BY category
HAVING AVG(price) > 50
 ORDER BY avg_price;

---

-- Группировка сразу по двум столбцам: категория + дата заказа
SELECT category,
       order_date,
       SUM(price * quantity) AS daily_revenue_by_category
  FROM orders
 GROUP BY category, order_date
 ORDER BY order_date, category;

---

/*
Задача 1. Выведи product_name и price всех товаров, отсортированных по цене по возрастанию.
*/
SELECT product_name,
       price
  FROM orders
 ORDER BY price;

---

/*
Задача 2. Выведи все товары категории Electronics, цена которых больше 700,
отсортируй по названию товара в алфавитном порядке.
*/
SELECT product_name, --SELECT * FROM orders
       category,
       price,
       quantity,
       order_date
  FROM orders
 WHERE category = 'Electronics'
   AND price > 700
 ORDER BY product_name;

---

/*
Задача 3. Выведи товары, название которых начинается на букву "O"
или содержит слово "Chair" (используй LIKE или ILIKE).
*/
SELECT *
  FROM orders
 WHERE product_name LIKE 'O%'
    OR product_name ILIKE '%Chair%';

---

/*
Задача 4. Выведи товары, которые НЕ относятся к категориям
Groceries и Furniture (используй NOT IN).
*/
SELECT *
  FROM orders
 WHERE category NOT IN ('Groceries', 'Furniture');

---

/*
Задача 5. Посчитай общее количество заказов (COUNT(*)) и суммарное количество единиц товара (SUM(quantity))
по всей таблице — без группировки, одной строкой на весь результат.
*/
SELECT COUNT(*)      AS total_orders,
       SUM(quantity) AS total_quantity
  FROM orders;

---

/*
Задача 6. Для каждой категории выведи минимальную и максимальную цену товара (MIN, MAX),
отсортируй по максимальной цене по убыванию.
*/
SELECT category,
       MIN(price) AS min_price,
       MAX(price) AS max_price
  FROM orders
 GROUP BY category
 ORDER BY max_price DESC;

---

/*
Задача 7. Выведи только те категории, в которых больше одного заказа (используй GROUP BY + HAVING + COUNT(*)).
*/
SELECT category,
       COUNT(*) AS orders_count
  FROM orders
 GROUP BY category
HAVING COUNT(*) > 1;

---

/*
Задача 8. Посчитай суммарную выручку (price * quantity) по каждой дате заказа (order_date), отсортируй по дате.
*/

SELECT order_date,
       SUM(price * quantity) AS total_price
  FROM orders
 GROUP BY order_date
 ORDER BY order_date;

---

/*
Задача 9. Выведи категории, где средняя цена товара (AVG(price)) больше, чем средняя цена товара по всей таблице
(подумай, как получить это число — можно сначала посчитать вручную одним запросом,
а потом подставить как константу в HAVING; полноценный подзапрос для сравнения мы разберём позже, в теме про subquery).
*/

SELECT category,
       ROUND(AVG(price),2) AS avg_category_price
  FROM orders
 GROUP BY category
HAVING AVG(price) > 502.18;

---

/*
Задача 10. Комбинированная: выведи категорию, количество заказов и суммарную выручку только для заказов,
оформленных после 2025-01-06, но покажи только те категории, где суммарная выручка больше 500,
результат отсортируй по выручке по убыванию.
*/

SELECT category,
       SUM(quantity)         AS quantity,
       SUM(price * quantity) AS total_price
  FROM orders
 WHERE order_date > '2025-01-06'
 GROUP BY category
HAVING SUM(price * quantity) > 500
 ORDER BY total_price DESC;

SELECT COUNT(DISTINCT category) AS distinct_category
FROM orders;