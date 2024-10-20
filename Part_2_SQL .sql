-- Questions answered using PostgreSQL dialect

-- QUESTION 1
-- Write a query to return the customer_name, product_name, and total_amount
-- for each sale in the last 30 days.
SELECT
    c.customer_name,
    p.product_name,
    s.total_amount
FROM Sales s 
JOIN Customers c USING (customer_id)
JOIN Products p USING (product_id)
WHERE s.sale_date >= CURRENT_DATE - INTERVAL '30 days';

-- QUESTION 2
-- Write a query to find the total revenue generated by each product category
-- in the last year. The output should include the product category and the
-- total revenue for that category.
SELECT
    p.category,
    SUM(s.total_revenue) AS total_revenue
FROM Products p
JOIN Sales s USING (product_id)
WHERE s.sale_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY p.category;

--QUESTION 3
-- Write a query to return all customers who made purchases in 2023 and are
-- located in the "West" region.
SELECT
    DISTINCT c.customer_name
FROM Customers c 
JOIN Sales s USING (customer_id)
WHERE EXTRACT(YEAR FROM s.sale_date) = 2023 AND c.sales_region = 'West';

-- QUESTION 4
-- Write a query to display the total number of sales, total quantity sold, and
-- total revenue for each customer. The result should include the customer_name,
-- total sales, total quantity, and total revenue.
SELECT
    c.customer_name,
    COUNT(s.sales_id) AS num_sales,
    SUM(s.quantity) AS quantity_sold,
    SUM(s.total_amount) AS total_revenue
FROM Customer c 
JOIN Sales s USING (customer_id)
GROUP BY customer_name;

-- QUESTION 5
-- Write a query to find the top 3 customers (by total revenue) in the year 2023.
SELECT
    c.customer_name,
    SUM(s.total_amount) AS total_revenue
FROM Customers c 
JOIN Sales s USING (customer_id)
WHERE EXTRACT(YEAR FROM s.sale_date) = 2023
GROUP BY c.customer_name
ORDER BY total_revenue DESC
LIMIT 3;

-- QUESTION 6
-- Write a query to rank products by their total sales quantity in 2023. The result
-- should include the product_name, total quantity sold, and rank.
SELECT
    p.product_name,
    SUM(s.quantity) AS total_quantity_sold,
    RANK() OVER (ORDER BY SUM(s.quantity) DESC) AS rnk
FROM Products p 
JOIN Sales s USING (product_id)
WHERE EXTRACT(YEAR FROM s.sale_date) = 2023
GROUP BY p.product_name
ORDER BY rnk;

-- QUESTION 7
-- Write a query that categorizes customers into "New" (if they signed up in the last
-- 6 months) or "Existing" based on their sign_up_date. Include the customer_name,
-- region, and category in the result.
SELECT
    customer_name,
    sales_region,
    CASE
        WHEN c.sign_up_date >= CURRENT_DATE - INTERVAL '6 months' THEN 'New'
        ELSE 'Existing'
    END AS category
FROM Customers;

-- QUESTION 8
-- Write a query to return the month and year along with the total sales for each month
-- for the last 12 months.
SELECT
   EXTRACT(MONTH FROM sale_date) AS month,
   EXTRACT(YEAR FROM sale_date) AS year,
   SUM(total_amount) AS total_sales
FROM Sales
WHERE sales_date >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date) 
ORDER BY year, month

-- QUESTION 9
-- Write a query to return the product categories that generated more than $50,000 in
-- revenue during the last 6 months.
SELECT
    p.category,
    SUM(s.total_amount) AS total_revenue
FROM Products p 
JOIN Sales s USING (product_id)
WHERE s.sales_date >= CURRENT_DATE - INTERVAL '6 months'
GROUP BY p.category
HAVING SUM(s.total_amount) > 50000;

-- QUESTION 10
-- Write a query to check for any sales where the total_amount doesn’t match the expected
-- value (i.e., quantity * price).
SELECT
    s.sales_id,
    s.quantity,
    p.price,
    s.quantity * p.price AS expected_total,
    s.total_amount
FROM Sales s 
JOIN Products p USING (product_id)
WHERE s.total_amount != (s.quantity * p.price); 

