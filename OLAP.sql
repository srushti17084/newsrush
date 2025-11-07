DROP DATABASE IF EXISTS globalgadgets_dw;
CREATE DATABASE globalgadgets_dw;
USE globalgadgets_dw;
CREATE TABLE dim_product (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  category VARCHAR(50),
  brand VARCHAR(50)
);

CREATE TABLE dim_customer (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  gender VARCHAR(10),
  age INT
);

CREATE TABLE dim_time (
  time_id INT PRIMARY KEY,
  date DATE,
  month VARCHAR(20),
  quarter VARCHAR(10),
  year INT
);

CREATE TABLE dim_location (
  location_id INT PRIMARY KEY,
  city VARCHAR(50),
  state VARCHAR(50),
  country VARCHAR(50)
);

CREATE TABLE fact_sales (
  sales_id INT PRIMARY KEY,
  product_id INT,
  customer_id INT,
  time_id INT,
  location_id INT,
  quantity_sold INT,
  total_sales DECIMAL(10,2),
  FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
  FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
  FOREIGN KEY (time_id) REFERENCES dim_time(time_id),
  FOREIGN KEY (location_id) REFERENCES dim_location(location_id)
);

INSERT INTO dim_customer (customer_id, customer_name, gender, age) VALUES
(1, 'Alice Sharma', 'F', 28),
(2, 'Rahul Mehta', 'M', 35),
(3, 'Neha Verma', 'F', 24),
(4, 'Amit Patel', 'M', 40),
(5, 'Sana Iqbal', 'F', 30);
INSERT INTO dim_location (location_id, city, state, country) VALUES
(101, 'Mumbai', 'Maharashtra', 'India'),
(102, 'Bangalore', 'Karnataka', 'India'),
(103, 'Delhi', 'Delhi', 'India'),
(104, 'Chennai', 'Tamil Nadu', 'India'),
(105, 'Pune', 'Maharashtra', 'India');
INSERT INTO dim_product (product_id, product_name, category, brand) VALUES
(501, 'Smartphone', 'Electronics', 'Samsung'),
(502, 'Headphones', 'Accessories', 'Boat'),
(503, 'Tablet', 'Electronics', 'Apple'),
(504, 'Smartwatch', 'Accessories', 'Noise'),
(505, 'Laptop', 'Electronics', 'Dell');
INSERT INTO dim_time (time_id, date, month, quarter, year) VALUES
(1001, '2025-07-21', 'July', 'Q3', 2025),
(1002, '2025-07-22', 'July', 'Q3', 2025),
(1003, '2025-07-23', 'July', 'Q3', 2025),
(1004, '2025-08-01', 'August', 'Q3', 2025),
(1005, '2025-08-05', 'August', 'Q3', 2025);
INSERT INTO fact_sales (sales_id, product_id, customer_id, time_id, location_id, quantity_sold, total_sales) VALUES
(9001, 501, 1, 1001, 101, 2, 30000.00),
(9002, 502, 2, 1002, 102, 1, 2000.00),
(9003, 503, 3, 1003, 103, 1, 10000.00),
(9004, 504, 4, 1004, 104, 2, 10000.00),
(9005, 505, 5, 1005, 105, 1, 55000.00);

SELECT * FROM dim_customer;
SELECT * FROM dim_location;
SELECT * FROM dim_product;
SELECT * FROM dim_time;
SELECT * FROM fact_sales;

SELECT 
    dp.category,
    dl.country,
    SUM(fs.total_sales) AS total_sales_2025
FROM fact_sales fs
JOIN dim_product dp ON fs.product_id = dp.product_id
JOIN dim_time dt ON fs.time_id = dt.time_id
JOIN dim_location dl ON fs.location_id = dl.location_id
WHERE dt.year = 2025
GROUP BY dp.category, dl.country;

SELECT 
    dp.brand,
    dl.city,
    SUM(fs.total_sales) AS total_sales
FROM fact_sales fs
JOIN dim_product dp ON fs.product_id = dp.product_id
JOIN dim_time dt ON fs.time_id = dt.time_id
JOIN dim_location dl ON fs.location_id = dl.location_id
WHERE dp.category = 'Electronics'
  AND dl.country = 'India'
  AND dt.quarter = 'Q3'
GROUP BY dp.brand, dl.city;

SELECT 
    dl.country,
    dl.state,
    dl.city,
    SUM(fs.total_sales) AS total_sales
FROM fact_sales fs
JOIN dim_location dl ON fs.location_id = dl.location_id
GROUP BY dl.country, dl.state, dl.city WITH ROLLUP;

SELECT 
    dp.category,
    dp.product_name,
    SUM(fs.total_sales) AS total_sales
FROM fact_sales fs
JOIN dim_product dp ON fs.product_id = dp.product_id
GROUP BY dp.category, dp.product_name
ORDER BY dp.category;

SELECT 
    dp.category,
    SUM(CASE WHEN dt.quarter = 'Q1' THEN fs.total_sales ELSE 0 END) AS Q1_Sales,
    SUM(CASE WHEN dt.quarter = 'Q2' THEN fs.total_sales ELSE 0 END) AS Q2_Sales,
    SUM(CASE WHEN dt.quarter = 'Q3' THEN fs.total_sales ELSE 0 END) AS Q3_Sales,
    SUM(CASE WHEN dt.quarter = 'Q4' THEN fs.total_sales ELSE 0 END) AS Q4_Sales
FROM fact_sales fs
JOIN dim_product dp ON fs.product_id = dp.product_id
JOIN dim_time dt ON fs.time_id = dt.time_id
GROUP BY dp.category;

