/* 
   Database Management Task - Order Management System
   This script creates the schema, inserts sample data, and runs the required analysis queries.
*/

-- 0. Cleanup (Optional, but helpful for re-running the script)
DROP TABLE IF EXISTS Payments CASCADE;
DROP TABLE IF EXISTS OrderItems CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Products CASCADE;
DROP TABLE IF EXISTS Customers CASCADE;

-- 1. Tables Creation
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    joined_at DATE DEFAULT CURRENT_DATE
);

CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10, 2),
    stock_count INT
);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
    order_date DATE DEFAULT CURRENT_DATE,
    order_status VARCHAR(20) DEFAULT 'Pending'
);

CREATE TABLE OrderItems (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES Products(product_id) ON DELETE CASCADE,
    quantity INT,
    unit_price DECIMAL(10, 2)
);

CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id) ON DELETE CASCADE,
    payment_method VARCHAR(50),
    amount DECIMAL(10, 2),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Sample Data Insertion (5 Customers, 10 Orders, Products, Payments)
INSERT INTO Customers (name, email) VALUES 
('Rahul Sharma', 'rahul@example.com'),
('Priya Patel', 'priya@example.com'),
('Amit Kumar', 'amit@example.com'),
('Sneha Reddy', 'sneha@example.com'),
('Vikram Singh', 'vikram@example.com');

INSERT INTO Products (name, price, stock_count) VALUES 
('Laptop', 75000.00, 10),
('Smartphone', 25000.00, 20),
('Headphones', 2000.00, 50),
('Monitor', 12000.00, 15);

-- 10 Sample Orders
INSERT INTO Orders (customer_id, order_date, order_status) VALUES 
(1, '2026-05-01', 'Shipped'),
(1, '2026-05-05', 'Paid'),
(2, '2026-04-10', 'Shipped'),
(2, '2026-05-08', 'Pending'),
(3, '2026-05-02', 'Paid'),
(4, '2026-05-09', 'Pending'),
(1, '2026-05-07', 'Paid'),
(5, '2026-04-25', 'Shipped'),
(2, '2026-05-06', 'Paid'),
(3, '2026-05-09', 'Pending');

-- Linking items to orders
INSERT INTO OrderItems (order_id, product_id, quantity, unit_price) VALUES 
(1, 1, 1, 75000.00), (2, 3, 2, 2000.00), (3, 2, 1, 25000.00), (4, 4, 1, 12000.00),
(5, 2, 1, 25000.00), (6, 3, 1, 2000.00), (7, 4, 2, 12000.00), (8, 1, 1, 75000.00),
(9, 2, 1, 25000.00), (10, 3, 1, 2000.00);

INSERT INTO Payments (order_id, payment_method, amount) VALUES 
(1, 'Credit Card', 75000.00), (2, 'UPI', 4000.00), (3, 'Debit Card', 25000.00),
(5, 'UPI', 25000.00), (7, 'Net Banking', 24000.00), (8, 'Credit Card', 75000.00),
(9, 'UPI', 25000.00);


-- 3. Analysis Queries

-- Query 1: Top 3 customers with the highest number of orders
-- Purpose: To identify our most frequent buyers by joining customers and orders.
SELECT c.name, COUNT(o.order_id) as total_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_orders DESC
LIMIT 3;

-- Query 2: Retrieve orders placed in the last 30 days
-- Purpose: To track recent sales activity and identify pending shipments.
SELECT * 
FROM Orders 
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days';

-- Query 3: Calculate total revenue for each product
-- Purpose: To evaluate product performance by multiplying quantity with price from OrderItems.
SELECT p.name, SUM(oi.quantity * oi.unit_price) as total_revenue
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name
ORDER BY total_revenue DESC;
