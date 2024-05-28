-- DATA ANALYSIS

-- 1) Customer demographic analysis

-- Query the distribution of customers by gender
SELECT customer_gender, count(customer_gender) as gender_count
FROM customers
GROUP BY customer_gender;

-- Query the distribution of customers by age
SELECT customer_age, count(customer_age) as count_of_ages
FROM customers
GROUP BY customer_age
ORDER BY count_of_ages desc;

-- Distribution of customers by country
SELECT country, count(distinct customer_id) as customers_count
FROM customers
GROUP BY country
ORDER BY customers_count desc;

-- Geographic distribution of customers by city, state, and country.
SELECT city, state, country, count(customer_id) as customers_count
FROM customers
GROUP BY city, state, country
ORDER BY customers_count desc;


-- 2) Product Analysis:

-- Distribution of products by category.
SELECT product_category, count(product_name) as product_count
FROM products
GROUP BY product_category;

-- Average price of products within each category.
SELECT product_category, round(avg(product_price),2)
FROM products
GROUP BY product_category;

-- Top 10 most purchased products
SELECT
	p.product_name, 
	sum(units_purchased) as total_units_purchased
FROM
    products p
JOIN 
    purchase pu ON p.product_id=pu.product_id
GROUP BY
    p.product_name
ORDER BY total_units_purchased desc
limit 10;

-- Sales analysis by product
SELECT
	p.product_name,
	round(sum(units_purchased *p.product_price),2) as total_sales
FROM
	products p
JOIN 
	purchase pu ON p.product_id= pu.product_id
GROUP BY
    p.product_name
ORDER BY total_sales desc;

-- 3) Sales trend

-- Total units purchased over time
SELECT 
     year(STR_TO_DATE(purchase_date, '%m/%d/%Y')) AS year, 
	 SUM(units_purchased) AS total_units_sold
FROM 
     purchase
GROUP BY year
ORDER BY total_units_sold desc;

-- What is the yearly sales trend
SELECT 
     year(STR_TO_DATE(purchase_date, '%m/%d/%Y')) AS year, 
	 round(sum(units_purchased*p.product_price),2) as total_sales
FROM 
     purchase pu
JOIN 
     products p ON pu.product_id=p.product_id
GROUP BY year;

-- Retrieve monthly sales trend across the years
SELECT 
     year(STR_TO_DATE(purchase_date, '%m/%d/%Y')) as year,
     monthname(STR_TO_DATE(purchase_date, '%m/%d/%Y')) as month,
	 round(sum(units_purchased*p.product_price),2) as total_sales,
     row_number() over (partition by year(STR_TO_DATE(purchase_date, '%m/%d/%Y')) order by round(sum(units_purchased*p.product_price),2) desc) as rownum
FROM purchase pu
JOIN products p
ON pu.product_id=p.product_id
GROUP BY year, month;

-- 4) Target market analysis

-- Query the top product category preferred by customers in different age groups 
WITH ranked_products as(
SELECT c.age_group, 
       p.product_category, 
       sum(pu.units_purchased) as purchase_count,
       row_number() over (partition by age_group order by sum(pu.units_purchased) desc) as rownum
FROM customers c
JOIN purchase pu ON c.customer_id=pu.customer_id
JOIN products p ON pu.product_id=p.product_id
GROUP BY c.age_group, p.product_category
)
SELECT
      age_group,
      product_category,
      purchase_count
FROM
      ranked_products
WHERE rownum=1;


-- Query the total sales made in each country
SELECT
    pu.purchase_location, 
	round(sum(pu.units_purchased*p.product_price),2) as total_sales
FROM
    purchase pu
JOIN 
    products p ON pu.product_id=p.product_id
GROUP BY
    pu.purchase_location
ORDER BY total_sales desc;

-- Sort customers by their total purchase amounts
SELECT
    c.customer_id,
    c.customer_name,
    round(SUM(units_purchased * product_price),2) AS total_purchase_amount
FROM
    customers c 
JOIN
    purchase pu ON c.customer_id=pu.customer_id
JOIN 
    products p ON pu.product_id = p.product_id
GROUP BY
    c.customer_id, c.customer_name
ORDER BY
    total_purchase_amount DESC;

-- Retrieve the top 10 customers by units purchased within each country.
WITH top_customers as (
SELECT
	c.customer_name,
	c.country,
	sum(pu.units_purchased)as total_units_purchased,
	row_number() over (partition by country order by sum(pu.units_purchased) desc) as rownum
FROM
	customers c
JOIN
	purchase pu ON c.customer_id=pu.customer_id
GROUP BY
	c.country, customer_name
)
SELECT country, 
       customer_name,
       total_units_purchased
FROM top_customers
WHERE rownum between 1 and 10
ORDER BY country, total_units_purchased desc;

-- Retrieve the top 10 customers by total_purchase_amount within each country.
WITH top_customers as (
SELECT 
	c.customer_name,
	c.country,
	round(sum(pu.units_purchased*p.product_price),2)as total_purchase_amount,
	row_number() over (partition by country order by round(sum(pu.units_purchased*p.product_price),2) desc) as rownum
FROM
	customers c
JOIN 
    purchase pu ON c.customer_id=pu.customer_id
JOIN 
    products p ON pu.product_id=p.product_id
GROUP BY 
	c.country, customer_name
)
SELECT country, 
       customer_name,
       total_purchase_amount
FROM top_customers
WHERE rownum between 1 and 10
ORDER BY country, total_purchase_amount desc;

-- Total sales for each state in australia.
SELECT c.state,
       round(SUM(p.product_price * pu.units_purchased),2) AS total_sales
FROM customers c
JOIN purchase pu ON c.customer_id = pu.customer_id
JOIN products p ON pu.product_id = p.product_id
WHERE c.country = 'Australia'
GROUP BY c.state
ORDER BY total_sales desc;

-- Total sales for each state in United States.
SELECT c.state,
       round(SUM(p.product_price * pu.units_purchased),2) AS total_sales
FROM customers c
JOIN purchase pu ON c.customer_id = pu.customer_id
JOIN products p ON pu.product_id = p.product_id
WHERE c.country = 'United States'
GROUP BY c.state
ORDER BY total_sales desc;

-- Total sales for each state in Canada
SELECT c.state,
       round(SUM(p.product_price * pu.units_purchased),2) AS total_sales
FROM customers c
JOIN purchase pu ON c.customer_id = pu.customer_id
JOIN products p ON pu.product_id = p.product_id
WHERE c.country = 'Canada'
GROUP BY c.state
ORDER BY total_sales desc;

-- 5)Correlation between geographic location and product preferences.

-- Best selling product in each country
WITH RankedProducts AS (
    SELECT 
        c.country,
        p.product_name AS best_selling_product,
        round(SUM(p.product_price * pu.units_purchased),2) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY c.country ORDER BY round(SUM(p.product_price * pu.units_purchased),2) DESC) AS rn
    FROM 
        purchase pu
    JOIN 
        products p ON pu.product_id = p.product_id
    JOIN
        customers c ON pu.customer_id = c.customer_id
    GROUP BY
        c.country, p.product_name)
SELECT 
    country,
    best_selling_product,
    total_sales
FROM 
    RankedProducts
WHERE 
    rn = 1;

-- Best selling product category in each country
WITH ranked_products as (
SELECT
	c.country,
	p.product_category,
	round(sum(p.product_price*pu.units_purchased),2) as total_sales,
	row_number() over (partition by country order by round(sum(p.product_price*pu.units_purchased),2)desc) as rownum
FROM 
    customers c
JOIN 
    purchase pu ON c.customer_id=pu.customer_id
JOIN
    products p ON pu.product_id=p.product_id
GROUP BY
    c.country, p.product_category
)
SELECT
	  country,
	  product_category, 
	  total_sales
FROM ranked_products
WHERE rownum=1;

-- Best selling product in each state across the countries
WITH RankedProducts AS (
    SELECT 
        c.country,
        c.state,
        p.product_name AS best_selling_product,
        round(SUM(p.product_price * pu.units_purchased),2) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY c.state ORDER BY round(SUM(p.product_price * pu.units_purchased),2) DESC) AS rn
    FROM purchase pu
    JOIN products p 
    ON pu.product_id = p.product_id
    JOIN customers c 
    ON pu.customer_id = c.customer_id 
    GROUP BY c.country, c.state, p.product_name)
SELECT 
    country,
    state,
    best_selling_product,
    total_sales
FROM RankedProducts
WHERE rn = 1;

-- Best selling product category in each state across the countries
WITH RankedProducts AS (
    SELECT 
        c.country,
        c.state,
        p.product_category AS best_selling_category,
        round(SUM(p.product_price * pu.units_purchased),2) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY c.state ORDER BY round(SUM(p.product_price * pu.units_purchased),2) DESC) AS rn
    FROM purchase pu
    JOIN products p 
    ON pu.product_id = p.product_id
    JOIN customers c 
    ON pu.customer_id = c.customer_id 
    GROUP BY c.country, c.state, p.product_category)
SELECT 
    country,
    state,
    best_selling_category,
    total_sales
FROM RankedProducts
WHERE rn = 1;

-- creating a view to export the fields needed for analysis
CREATE VIEW customer AS 
SELECT customer_id, customer_name, age_group, gender, city, state, country
FROM customers;

CREATE VIEW product AS
SELECT*
FROM products;

CREATE VIEW sales AS
SELECT pu.*,p.product_price, (p.product_price*pu.units_purchased) as total_sales
FROM purchase pu
JOIN products p
ON pu.product_id=p.product_id


