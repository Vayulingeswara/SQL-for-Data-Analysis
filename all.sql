-- your code goes here
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50)
);

INSERT INTO customers (customer_id, customer_name, email, city) VALUES
(1, 'Amit Kumar', 'amit@example.com', 'Delhi'),
(2, 'Sneha Sharma', 'sneha@example.com', 'Mumbai'),
(3, 'Rahul Verma', 'rahul@example.com', 'Bangalore'),
(4, 'Priya Singh', 'priya@example.com', 'Chennai');
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    product_category VARCHAR(50),
    price DECIMAL(10,2)
);

INSERT INTO products (product_id, product_name, product_category, price) VALUES
(101, 'Smartphone', 'Electronics', 15000.00),
(102, 'Laptop', 'Electronics', 55000.00),
(103, 'Shoes', 'Fashion', 2500.00),
(104, 'Watch', 'Accessories', 3000.00);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    order_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
INSERT INTO orders (order_id, customer_id, product_id, order_date, order_amount) VALUES
(1001, 1, 101, '2025-09-01', 15000.00),
(1002, 2, 103, '2025-09-05', 2500.00),
(1003, 3, 102, '2025-09-10', 55000.00),
(1004, 1, 104, '2025-09-15', 3000.00),
(1005, 4, 103, '2025-09-20', 2500.00);
-- 1. Select all customers from Delhi
SELECT customer_id, customer_name, city
FROM customers
WHERE city = 'Delhi';

-- 2. List all products ordered, ordered by price (highest first)
SELECT product_id, product_name, price
FROM products
ORDER BY price DESC;

-- 3. Show total orders by each customer
SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC;
-- 1. INNER JOIN: Get customer names with their orders
SELECT c.customer_name, o.order_id, o.order_date, o.order_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

-- 2. LEFT JOIN: List all customers even if they haven’t placed orders
SELECT c.customer_name, o.order_id, o.order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- 3. RIGHT JOIN: List all orders with customer details
-- (Some SQL engines may not support RIGHT JOIN, in SQLite you simulate with LEFT JOIN)
SELECT o.order_id, o.order_date, c.customer_name
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

-- 1. Customers who spent more than average order amount
SELECT customer_id, SUM(order_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(order_amount) > (SELECT AVG(order_amount) FROM orders);

-- 2. Find the most expensive product ordered
SELECT product_name, price
FROM products
WHERE price = (SELECT MAX(price) FROM products);

-- 1. Total revenue from all orders
SELECT SUM(order_amount) AS total_revenue
FROM orders;

-- 2. Average revenue per order
SELECT AVG(order_amount) AS avg_order_value
FROM orders;

-- 3. Average revenue per customer (ARPU)
SELECT AVG(user_revenue) AS arpu
FROM (
    SELECT customer_id, SUM(order_amount) AS user_revenue
    FROM orders
    GROUP BY customer_id
) sub;
-- 1. Create a view of high-value customers (spent > 10,000)
CREATE VIEW high_value_customers AS
SELECT c.customer_id, c.customer_name, SUM(o.order_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.order_amount) > 10000;

-- 2. Create a view showing order details with product info
CREATE VIEW order_summary AS
SELECT o.order_id, c.customer_name, p.product_name, o.order_date, o.order_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id;

-- 3. Create a view for category-wise sales
CREATE VIEW category_sales AS
SELECT p.product_category, SUM(o.order_amount) AS total_sales
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_category;
SELECT * FROM high_value_customers;
SELECT * FROM order_summary ORDER BY order_date DESC;
SELECT * FROM category_sales;
-- Create index on customer_id in orders (frequently used in joins)
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- Create index on product_id in orders
CREATE INDEX idx_orders_product_id ON orders(product_id);

-- Create index on order_date to speed up date range queries
CREATE INDEX idx_orders_order_date ON orders(order_date);

-- Create index on product_category in products
CREATE INDEX idx_products_category ON products(product_category);
