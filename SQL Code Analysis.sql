-- DATA CLEANING
-- 1) Combine the first and last names of all customers 
set sql_safe_updates=0; -- to disable safe updates mode

alter table customers
add column customer_name varchar(255);

update customers
set customer_name = concat(first_name, ' ', last_name);

alter table customers
drop column first_name,
drop column last_name;

-- 2) Modify the customer_email field to display censored email addresses for customers 

update customers
set email= concat(substring(email, 1, 2), repeat('*',position('@' in email)-3), substring(email, position('@' in email)));

alter table customers
rename column email to censored_email;

-- 3)Write a query to break out the address column into seperate columns for street, city, state, postal_code and country
ALTER TABLE customers
ADD COLUMN street VARCHAR(255),
ADD COLUMN city VARCHAR(100),
ADD COLUMN state VARCHAR(100),
ADD COLUMN postal_code VARCHAR(20),
ADD COLUMN country varchar(255);

UPDATE customers
set street= substring(address, 1, position(',' in address)-1),
city= trim(substring_index(substring_index(address, ',', 2), ',', -1)),
state= trim(substring_index(substring_index(address, ',', 3), ',', -1)),
postal_code= trim(substring_index(substring_index(address, ',', -2), ',', 1)),
country= trim(substring_index(address, ',', -1));

alter table customers
drop column address;

-- 4) Segment the customer's age into age brackets
ALTER table customers
ADD column age_group varchar(255);

UPDATE customers
SET age_group = 
CASE
WHEN age BETWEEN 21 and 30 THEN '(21-30yrs)'
WHEN age BETWEEN 31 and 40 THEN '(31-40yrs)'
WHEN age BETWEEN 41 AND 50 THEN '(41-50yrs)'
ELSE '(51yrs and above)'
END;

-- 5)The product_id and name are joined together in the product table. Write a query to seperate them into different columns
CREATE TABLE products AS
SELECT 
     substring(product_id_name, 1, position('_' in product_id_name)-1) as product_id, 
     substring(product_id_name, position('_' in product_id_name)+1) as product_name, 
     product_category, 
     product_price
FROM
     product;

drop table product;

set sql_safe_updates=1;  -- enable safe update mode

-- DATA ANALYSIS
-- 1) Customer demographic analysis

-- Query the distribution of customers by gender
select customer_gender, count(customer_gender) as gender_count
from customers
group by customer_gender;

-- Query the distribution of customers by age

select customer_age, count(customer_age) as count_of_ages
from customers
group by customer_age
order by count_of_ages desc;

-- Distribution of customers by country
select country, count(distinct customer_id) as customers_count
from customers
group by country
order by customers_count desc;

-- Geographic distribution of customers by city, state, and country.
select city, state, country, count(customer_id) as customers_count
from customers
group by city, state, country
order by customers_count desc;


-- 2) Product Analysis:

-- Distribution of products by category.
select product_category, count(product_name) as product_count
from products
group by product_category;

-- Average price of products within each category.
select product_category, round(avg(product_price),2)
from products
group by product_category;

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
WITH ranked_products as
(select c.age_group, 
       p.product_category, 
       sum(pu.units_purchased) as purchase_count,
       row_number() over (partition by age_group order by sum(pu.units_purchased) desc) as rownum
from customers c
join purchase pu on c.customer_id=pu.customer_id
join products p on pu.product_id=p.product_id
group by c.age_group, p.product_category)
select 
      age_group,
      product_category,
      purchase_count
from
      ranked_products
where rownum=1;


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
select country, 
       customer_name,
       total_units_purchased
from top_customers
where rownum between 1 and 10
order by country, total_units_purchased desc;

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
select country, 
       customer_name,
       total_purchase_amount
from top_customers
where rownum between 1 and 10
order by country, total_purchase_amount desc;

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
select
	country,
	product_category, 
	total_sales
from ranked_products
where rownum=1;

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

-- creating a view to export fields needed for analysis
create view customer as 
select customer_id, customer_name, age_group, gender, city, state, country
from customers;

create view product as
select*
from products;

create view sales as
select pu.*,p.product_price, (p.product_price*pu.units_purchased) as total_sales
from purchase pu
join products p
on pu.product_id=p.product_id


