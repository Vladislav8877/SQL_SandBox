SET search_path TO joins_practice;

SELECT o.order_id,
       o.order_date,
       u.user_name
  FROM orders AS o
  JOIN users AS u
ON o.user_id = u.user_id;

SELECT o.order_id,
       o.order_date,
       u.user_name,
       oi.product_id,
       oi.quantity
  FROM orders AS o
  JOIN users AS u
ON o.user_id = u.user_id
  JOIN order_items AS oi
ON o.order_id = oi.order_id;

SELECT o.order_id,
       u.user_name,
       p.product_name,
       oi.quantity,
       (p.price * oi.quantity) AS item_total
  FROM orders AS o
  JOIN users AS u
ON o.user_id = u.user_id
  JOIN order_items AS oi
ON o.order_id = oi.order_id
  JOIN products AS p
ON p.product_id = oi.product_id;

SELECT o.order_id,
       o.order_date,
       oi.product_id
  FROM orders AS o
  LEFT JOIN order_items AS oi
ON o.order_id = oi.order_id;

