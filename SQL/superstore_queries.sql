-- Superstore Sales Analysis: SQL queries
-- Table: sales (9,800 rows)

-- Q1: What are the overall KPIs?
SELECT
    ROUND(SUM(sales), 0)                            AS total_sales,
    COUNT(DISTINCT order_id)                        AS total_orders,
    COUNT(DISTINCT customer_id)                     AS total_customers,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 0) AS avg_order_value
FROM sales;

-- Q2: Which category brings the most sales?
SELECT category,
       ROUND(SUM(sales), 0)     AS total_sales,
       COUNT(DISTINCT order_id) AS orders
FROM sales
GROUP BY category
ORDER BY total_sales DESC;

-- Q3: How did sales grow year over year?
SELECT order_year,
       ROUND(SUM(sales), 0) AS total_sales,
       ROUND((SUM(sales) - LAG(SUM(sales)) OVER (ORDER BY order_year))
             * 100.0 / LAG(SUM(sales)) OVER (ORDER BY order_year), 1) AS growth_pct
FROM sales
GROUP BY order_year
ORDER BY order_year;

-- Q4: Who are the top 10 customers by sales?
SELECT customer_name,
       ROUND(SUM(sales), 0) AS total_sales
FROM sales
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- Q5: How do sales split by region and segment?
SELECT region,
       segment,
       ROUND(SUM(sales), 0) AS total_sales
FROM sales
GROUP BY region, segment
ORDER BY region, total_sales DESC;

-- Q6: How long does each ship mode take on average?
SELECT ship_mode,
       ROUND(AVG(shipping_days), 2) AS avg_shipping_days
FROM sales
GROUP BY ship_mode
ORDER BY avg_shipping_days;

-- Q7: What are the top 3 products in each category?
SELECT *
FROM (
    SELECT category,
           product_name,
           ROUND(SUM(sales), 0) AS total_sales,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY SUM(sales) DESC) AS rank_no
    FROM sales
    GROUP BY category, product_name
)
WHERE rank_no <= 3
ORDER BY category, rank_no;

-- Q8: Which customers bought in 2 or more different years?
SELECT customer_name,
       COUNT(DISTINCT order_year) AS years_active
FROM sales
GROUP BY customer_name
HAVING COUNT(DISTINCT order_year) >= 2
ORDER BY years_active DESC;