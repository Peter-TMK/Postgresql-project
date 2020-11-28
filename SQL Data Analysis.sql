--Checking the number of rows for each table

SELECT count(*)
FROM customer

SELECT count(*)
FROM product

SELECT count(*)
FROM sales

--                              ============Que1============

--Get the list of cities where the region is north or east without any duplicates using IN statement
--Get the list of all orders where the 'sales' value is between 100 and 500 using the BETWEEN operator
--Get the list of customers whose last name contains only 4 characters using LIKE

SELECT DISTINCT city,region --Region is declared in the output just to be sure the query is correct
FROM customer
WHERE region = 'North' OR region = 'East'

SELECT order_id, sales
FROM sales
WHERE sales BETWEEN '100'AND '500'

SELECT customer_name
FROM customer
WHERE customer_name LIKE '% ____'

--                              ============Que2============

--Retrieve all orders where 'discount' value is greater than zero, in descending order of 'discount' value
--Limit the number of results in above query to top 10


SELECT discount
FROM sales
WHERE discount > 0
ORDER BY discount DESC
LIMIT 10

--                              ============Que3============

--Find the sum of all 'sales' values
--Find count of the number of customers in the North region with age is between 20 and 30
--Find the average age of East region customers
--Find the minimum and maximum aged customer from Philadelphia

SELECT SUM(sales)
FROM sales

SELECT COUNT(*)
FROM customer
WHERE region = 'North' AND age BETWEEN 20 AND 30

SELECT AVG(age)
FROM customer
WHERE region = 'East'

SELECT AVG(age),MIN(age),MAX(age)
FROM customer
WHERE city= 'Philadelphia'

--                              ============Que4============

--Make a dashboard showing the following figures for each product ID...
-- ...Total sales(in $) in descending order, Number of orders, Max,Min and Average sales values.

--Get the list of product ID's where the quantity of product sold is greater than 10


SELECT product_id, SUM(sales) "Total Sales($)", COUNT(order_id) "Number of Orders", MAX(sales) "Maximum Sales",
		MIN(sales) "Minimum Sales",AVG(sales) "Average Sales"
FROM sales
GROUP BY product_id
ORDER BY "Total Sales($)" DESC

SELECT product_id, quantity
FROM sales
WHERE quantity > 10

--                              ============Que5============

--Find the total sales done in every state for customer between 20 and 60 years
--Get data containing product_id,product name,category,total sales value of that product and total quantity sold.

SELECT c.customer_name "Name",c.age "Age",c.state "Customer State", SUM(s.sales) "Total Sales"
FROM sales s
LEFT JOIN customer c
ON s.customer_id = c.customer_id
WHERE age BETWEEN 20 AND 60
GROUP BY "Customer State",c.customer_name,c.age
ORDER BY "Total Sales" DESC

SELECT p.product_name,p.category,p.sub_category,SUM(s.sales) "Total Sales", SUM(s.quantity) "Total Quantity Sold"
FROM sales s
LEFT JOIN product p
ON s.product_id = p.product_id
GROUP BY p.product_name,p.category,p.sub_category
ORDER BY "Total Sales" DESC

--                              ============Que6============

--Get data with all columns of sales table, and customer name, customer age,
--product name and category are in the same result set

CREATE table prod_sales_merge AS --Here, we merged product and sales tables and called it 'prod_sales_merge'.
SELECT s.*,p.product_name,p.category
FROM product p
LEFT JOIN sales s
ON p.product_id = s.product_id

SELECT psm.*, c.customer_name, c.age --Similarly to the above merged table, we merge the 'prod_sales_merge' table with the 'customer' table
FROM prod_sales_merge psm
LEFT JOIN customer c
ON psm.customer_id = c.customer_id

--====================OR WITHOUT CREATING A NEWLY MERGED TABLE====================================

SELECT psm.*, c.customer_name, c.age
FROM customer c
LEFT JOIN (SELECT s.*,p.product_name,p.category
FROM product p
LEFT JOIN sales s
ON p.product_id = s.product_id) psm
ON psm.customer_id = c.customer_id

--                              ============Que7============

--Find maximum length of characters in the product name string from product table
--Retrieve product name, sub-category and category from product table and an additional column named 'product_details'...
-- ...which contains a concatenated string of product name, sub-category and category
--Analyze the product_id column and take out three parts composing the product_id in three different columns
--List down comma seperated product name where sub-category is either Chairs or Tables.

SELECT product_name,LENGTH(product_name) "Length of Name"
FROM product

SELECT product_name,category,sub_category,product_name||', '||category||', '||sub_category as "product_details"
FROM product

SELECT product_id, SUBSTRING(product_id FOR 3), SUBSTRING(product_id FROM 5 FOR 2), SUBSTRING(product_id FROM 8 FOR 8)
FROM product

SELECT product_name,sub_category,string_agg(sub_category,', ')
FROM product
WHERE sub_category IN ('Chairs','Tables')
GROUP BY product_name, sub_category

--                              ============Que8============

--You are running a lottery for your customers,so pick a list of 5 lucky customers from ...
--...customer table using random function
--Suppose you cannot change the customer in fraction points. So, for sales value of 1.63, ...
--...you will get either 1 or 2. In such a scenario, find out
--Total sales revenue if you are charging the lower integer value of sales always
--Total sales revenue if you are charging the higher integer value of sales always
--Total sales revenue if you are rounding-off the sales always

SELECT customer_name "Name",SETSEED(0.5), ROUND(RANDOM())
FROM customer
ORDER BY ROUND(RANDOM()) DESC
LIMIT 5;

SELECT c.customer_name,SUM(CEIL(s.sales)) "Higher Sum",SUM(FLOOR(s.sales)) "Lower Sum",SUM(ROUND(s.sales)) "Rounded Sum"
FROM customer c
LEFT JOIN sales s
ON c.customer_id = s.customer_id
GROUP BY c.customer_name

--                              ============Que9============

--Find out the current age of "Batman" who was born on "April 6, 1939" in Years, Month and Days
--Find out the delivery period and sales on discount
--Analyze and find out the monthly sales of sub-category chair
--Do you observe any seasonality in sales of this sub-category

SELECT AGE(CURRENT_DATE, '1939-4-6') "Batman Current Age"

SELECT *
FROM sales

SELECT p.product_name "Product Name",AGE(ship_date,order_date) "Delivery Time",s.sales,s.quantity,s.discount,(s.sales * s.quantity) "Normal Sales Value",(s.sales * s.quantity) - ((s.sales * s.quantity) * s.discount) "Discounted Sales Value",s.profit
FROM sales s
LEFT JOIN product p
ON s.product_id = p.product_id
WHERE p.sub_category = 'Chairs'

--                              ============Que10============

--Find out all customers who have their first name and last name of 5 characters each
-- ...and last name starts with "A,B,C or D"
--Create a table "Zipcode" and insert the below data in it ('PIN/ZIP Codes',234432,23345,sdfe4,123&3,67424,7895432,12312)
--Find out the valid zipcodes from this table(5 or 6 Numeric Characters)

-- USING LIKE CONDITION
SELECT customer_name, LENGTH(customer_name) -1 "Length of Name"
FROM customer
WHERE customer_name
LIKE '_____ A____'
OR customer_name
LIKE '_____ B____'
OR customer_name
LIKE '_____ C____'
OR customer_name
LIKE '_____ D____'


-- USING REGEX
SELECT customer_name, LENGTH(customer_name) -1 "Length of Name"
FROM customer
WHERE customer_name
~* '^[a-z]{5}\s(a|b|c|d)[a-z]{4}$'
