CREATE SCHEMA IF NOT EXISTS tech_store;

SET search_path TO tech_store;

DROP TABLE IF EXISTS gadgets;

CREATE TABLE gadgets (
    PRIMARY KEY (gadget_id),
    gadget_id   SERIAL,
    device_type VARCHAR(50)   NOT NULL,
    brand       VARCHAR(50)   NOT NULL,
    model       VARCHAR(100)  NOT NULL,
    price       NUMERIC(10,2) NOT NULL,
    stock       INT           NOT NULL
);

INSERT INTO gadgets (device_type, brand, model, price, stock)
     VALUES ('Phone','Apple','iPhone 14',799.9,15),
            ('Phone','Apple','iPhone 15 Pro',999.50,5),
            ('Phone','Samsung','Galaxy S23',850.00,12),
            ('Tablet','Apple','iPad Air',599.00,8),
            ('Tablet','Samsung','Galaxy Tab S9',799.99,3),
            ('Laptop','Apple','MacBook Pro 14', 1999.00,2),
            ('Laptop','Asus','ROG Zephyrus',1450.50,7);

SELECT brand,
       model,
       price
  FROM gadgets
 WHERE price BETWEEN 600.00 AND 1000.00
   AND device_type IN ('Phone', 'Tablet');

SELECT device_type,
       brand,
       model,
       price,
       stock,
       ROUND(
           CASE
               WHEN stock < 6 THEN price * 0.95
               ELSE price * 0.85
           END, 2) AS new_price
  FROM gadgets;

SELECT device_type,
       brand,
       model
  FROM gadgets
 WHERE model LIKE '%Pro' OR model LIKE '% Pro %';

SELECT brand,
       model,
       price
  FROM gadgets
 ORDER BY brand, price DESC;

UPDATE gadgets
   SET model = 'Игровой ' || brand
 WHERE brand = 'Asus'
   AND device_type = 'Laptop';