USE project

--DROP TABLE  products
CREATE TABLE products ( 
id INT IDENTITY(1,1) PRIMARY KEY,
name VARCHAR(255) NOT NULL, 
description TEXT, 
price DECIMAL(10, 2) NOT NULL, 
category VARCHAR(50), 
stock_quantity INT DEFAULT 0 );


CREATE TABLE customers ( 
id INT IDENTITY(1,1) PRIMARY KEY,
first_name VARCHAR(100) NOT NULL, 
last_name VARCHAR(100), 
email VARCHAR(255) UNIQUE, 
phone_number VARCHAR(20) );


CREATE TABLE orders ( 
    id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL, 
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP, 
    total_amount DECIMAL(10, 2) NOT NULL, 
    status VARCHAR(20) DEFAULT 'new' CHECK (status IN ('new', 'in_progress', 'completed', 'canceled')), 
    FOREIGN KEY (customer_id) REFERENCES customers(id) 
);

--drop table order_items
CREATE TABLE order_items ( 
id INT IDENTITY(1,1) PRIMARY KEY,
order_id INT NOT NULL, 
product_id INT NOT NULL, 
quantity INT NOT NULL, 
unit_price DECIMAL(10, 2) NOT NULL, 
FOREIGN KEY (order_id) REFERENCES orders(id), 
FOREIGN KEY (product_id) REFERENCES products(id) );


CREATE TABLE employees ( 
id INT IDENTITY(1,1) PRIMARY KEY,
first_name VARCHAR(100) NOT NULL, 
last_name VARCHAR(100), 
position VARCHAR(50) NOT NULL, 
salary DECIMAL(10, 2), 
username VARCHAR(50) UNIQUE NOT NULL, 
password_hash CHAR(60) NOT NULL );

CREATE TABLE inventory ( 
id INT IDENTITY(1,1) PRIMARY KEY,
product_id INT NOT NULL, 
quantity INT NOT NULL, 
min_quantity INT NOT NULL, 
FOREIGN KEY (product_id) REFERENCES products(id) );

CREATE TABLE promotions ( 
    id INT IDENTITY(1,1) PRIMARY KEY, 
    promotion_name VARCHAR(255) NOT NULL, 
    promotion_type VARCHAR(20) CHECK (promotion_type IN ('percentage_discount', 'fixed_amount', 'gift')), 
    start_date DATE, 
    end_date DATE, 
    conditions TEXT 
);

CREATE TABLE reviews ( 
    id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL, 
	product_id INT NOT NULL, 
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5), 
    comment TEXT, 
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (customer_id) REFERENCES customers(id) 
);


-----------------------------çàïîëíåíèå
INSERT INTO products (name, description, price, category, stock_quantity) VALUES
('Espresso', 'Strong and bold coffee shot.', 2.50, 'Coffee', 50),
('Latte', 'Smooth coffee with steamed milk.', 3.50, 'Coffee', 30),
('Cappuccino', 'Coffee with frothed milk and cocoa.', 3.00, 'Coffee', 25),
('Mocha', 'Chocolate-flavored coffee drink.', 4.00, 'Coffee', 20),
('Americano', 'Espresso diluted with hot water.', 2.00, 'Coffee', 40);

INSERT INTO customers (first_name, last_name, email, phone_number) VALUES
('John', 'Doe', 'john.doe@example.com', '123-456-7890'),
('Jane', 'Smith', 'jane.smith@example.com', '234-567-8901'),
('Alice', 'Johnson', 'alice.johnson@example.com', '345-678-9012'),
('Bob', 'Brown', 'bob.brown@example.com', '456-789-0123'),
('Charlie', 'Davis', 'charlie.davis@example.com', '567-890-1234');

INSERT INTO orders (customer_id, total_amount, status) VALUES
(1, 10.00, 'completed'),
(2, 7.50, 'in_progress'),
(3, 15.00, 'completed'),
(4, 5.00, 'new'),
(5, 8.00, 'canceled');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 2.50), -- 2 Espresso
(1, 3, 1, 3.00), -- 1 Cappuccino
(2, 2, 1, 3.50), -- 1 Latte
(3, 4, 2, 4.00), -- 2 Mocha
(4, 5, 1, 2.00); -- 1 Americano

INSERT INTO employees (first_name, last_name, position, salary, username, password_hash) VALUES
('Emily', 'Clark', 'Barista', 2000.00, 'emily_clark', 'hashed_password_1'),
('Michael', 'Wilson', 'Manager', 3000.00, 'michael_wilson', 'hashed_password_2'),
('Sarah', 'Taylor', 'Cashier', 1800.00, 'sarah_taylor', 'hashed_password_3'),
('David', 'Anderson', 'Barista', 2200.00, 'david_anderson', 'hashed_password_4'),
('Laura', 'Thomas', 'Barista', 2100.00, 'laura_thomas', 'hashed_password_5');

INSERT INTO inventory (product_id, quantity, min_quantity) VALUES
(1, 40, 10),  -- Espresso
(2, 30, 5),   -- Latte
(3, 25, 5),   -- Cappuccino
(4, 20, 5),   -- Mocha
(5, 35, 10);  -- Americano

INSERT INTO promotions (promotion_name, promotion_type, start_date, end_date, conditions) VALUES
('Happy Hour', 'percentage_discount', '2023-10-01', '2023-10-31', '20% off all drinks from 4 PM to 6 PM'),
('Buy One Get One', 'gift', '2023-11-01', '2023-11-30', 'Buy one coffee and get a second one free'),
('Winter Special', 'fixed_amount', '2023-12-01', '2023-12-31', 'Get \$1 off on all hot drinks'),
('Loyalty Program', 'fixed_amount', '2023-10-15', '2024-01-15', 'Earn \$5 for every \$50 spent'),
('Weekend Treat', 'percentage_discount', '2023-10-01', '2023-10-31', '15% off on all orders over \$15 on weekends');

INSERT INTO reviews (customer_id, product_id, rating, comment) VALUES
(1, 1, 5, 'Best espresso I have ever had!'),
(2, 2, 4, 'Nice.'),
(3, 3, 5, 'Cappuccino was perfect, highly recommend!'),
(4, 4, 3, 'Mocha was good, but a bit too sweet for my taste.'),
(5, 5, 4, 'Americano is great for a morning boost!');


select * from reviews



----------------------------ïîäçàïðîñû

--Ïîëó÷èòü âñå çàêàçû, ó êîòîðûõ ñóììà ïðåâûøàåò ñðåäíþþ ñóììó âñåõ çàêàçîâ
SELECT * 
FROM orders 
WHERE total_amount > (SELECT AVG(total_amount) FROM orders);
--Ïîëó÷èòü êëèåíòîâ, êîòîðûå îñòàâèëè îòçûâû íà ïðîäóêòû
SELECT * 
FROM customers 
WHERE id IN (SELECT customer_id FROM reviews);
--Ïîëó÷èòü ñîòðóäíèêîâ ñ çàðïëàòîé âûøå ñðåäíåé çàðïëàòû
SELECT * 
FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees);

---------------çàïðîñû ñ ãðóïïèðîâêîé

--Îáùàÿ ñóììà çàêàçîâ ïî ñòàòóñó:
SELECT status, SUM(total_amount) AS total_sales
FROM orders
GROUP BY status;
--Êîëè÷åñòâî îòçûâîâ ïî êàæäîìó êëèåíòó:
SELECT customer_id, COUNT(*) AS review_count
FROM reviews
GROUP BY customer_id;
--Îáùàÿ ñóììà ïðîäàæ ïî ïðîäóêòàì:
SELECT product_id, SUM(quantity * unit_price) AS total_sales
FROM order_items
GROUP BY product_id;
--Êîëè÷åñòâî ïðîäóêòîâ â êàæäîé êàòåãîðèè:
SELECT category, COUNT(*) AS product_count
FROM products
GROUP BY category;
--Ñðåäíèé ðåéòèíã ïî ïðîäóêòàì:
SELECT product_id, AVG(rating) AS average_rating
FROM reviews
GROUP BY product_id;


------------------------îêîííàÿ ôóíêöèÿ

--äëÿ ïîäñ÷åòà îáùåãî êîëè÷åñòâà çàêàçîâ äëÿ êàæäîãî êëèåíòà
SELECT 
    c.id AS customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.id) OVER (PARTITION BY c.id) AS total_orders
FROM 
    customers c
LEFT JOIN 
    orders o ON c.id = o.customer_id;

--äëÿ âû÷èñëåíèÿ ñðåäíåé îöåíêè ïðîäóêòîâ
SELECT 
    p.id AS product_id,
    p.name,
    AVG(r.rating) OVER (PARTITION BY p.id) AS average_rating
FROM 
    products p
LEFT JOIN 
    reviews r ON p.id = r.product_id;

--äëÿ ðàíæèðîâàíèÿ ñîòðóäíèêîâ ïî çàðïëàòå
SELECT 
    e.id AS employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    RANK() OVER (ORDER BY e.salary) AS salary_rank
FROM 
    employees e;


-----------------------ïðîöåäóðà

CREATE TYPE OrderItemList AS TABLE(
    ProductID INT,
    Quantity INT
);
GO

CREATE PROCEDURE AddNewOrder
    @CustomerID INT,
    @TotalAmount DECIMAL(10, 2),
    @OrderItems OrderItemList READONLY
AS
BEGIN
    BEGIN TRANSACTION;

    -- Äîáàâëåíèå çàïèñè â òàáëèöó çàêàçîâ
    INSERT INTO orders(customer_id, total_amount, status)
    VALUES(@CustomerID, @TotalAmount, 'new');

    -- Ïîëó÷àåì ID ïîñëåäíåãî äîáàâëåííîãî çàêàçà
    DECLARE @OrderID INT = SCOPE_IDENTITY();

    -- Äîáàâëÿåì ýëåìåíòû çàêàçà
    INSERT INTO order_items(order_id, product_id, quantity, unit_price)
    SELECT @OrderID, ProductID, Quantity, P.price
    FROM @OrderItems IT
    JOIN products P ON IT.ProductID = P.id;

    -- Îáíîâëÿåì êîëè÷åñòâî ïðîäóêòîâ â èíâåíòàðå
    UPDATE inventory
    SET quantity -= QTY.Quantity
    FROM inventory INV
    INNER JOIN @OrderItems QTY ON INV.product_id = QTY.ProductID;

    COMMIT TRANSACTION;
END;
GO


DECLARE @OrderItems OrderItemList;
INSERT INTO @OrderItems(ProductID, Quantity) VALUES
(1, 2), -- äâà ýñïðåññî
(2, 1); -- îäèí ëàòòå

EXEC AddNewOrder
    @CustomerID = 1,
    @TotalAmount = 8.50,
    @OrderItems = @OrderItems;


SELECT * FROM order_items

SELECT * FROM sys.types WHERE name = 'OrderItemList';


-------------------------Triggers
drop table trigger_logs
CREATE TABLE trigger_logs (
    id INT IDENTITY(1,1) PRIMARY KEY,
    trigger_name VARCHAR(50),
    action_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    username VARCHAR(50),
    description TEXT
);


--äëÿ ïðîâåðêè ìèíèìàëüíîãî êîëè÷åñòâà íà ñêëàäå
--Drop trigger check_min_stock
CREATE TRIGGER check_min_stock
ON inventory
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;



    -- Ëîãèðóåì èçìåíåíèå óðîâíÿ çàïàñà
    INSERT INTO trigger_logs (trigger_name, action_time, username, description)
    SELECT 
        'check_min_stock',
        GETDATE(),
        SYSTEM_USER,
        CONCAT('Ïðîâåðåíî íàëè÷èå çàïàñîâ äëÿ product_id: ', i.product_id, '. Íîâûé çàïàñ: ', i.quantity)
    FROM inserted i;
END;

INSERT INTO inventory(product_id, quantity, min_quantity) VALUES (1, 50, 10);

UPDATE inventory
SET quantity = 40
WHERE product_id = 1;

Select * from trigger_logs
