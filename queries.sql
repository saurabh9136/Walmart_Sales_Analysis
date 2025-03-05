USE walmart_data;
SELECT * FROM sales_data;

-- Find difference payment method and number of transactions, number of qty sold

SELECT 
payment_method, COUNT(*) AS transactions, SUM(quantity) AS sold_quantity 
FROM sales_data 
GROUP BY payment_method;

-- Identify the highest-rated category in each branch, displaying the branch, category AVG RATING
SELECT * FROM
(SELECT  
    branch, 
    category, 
    AVG(rating) AS avg_rating,
    RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS ranks
FROM sales_data  
GROUP BY branch, category) AS data
WHERE ranks = 1;


-- Identify the busiest day for each branch based on the number of transactions
SELECT * FROM (
SELECT 
	branch,
    DAYNAME(STR_TO_DATE(date, '%d/%m/%y')) as day_name,
    COUNT(*) as no_transactions,
    RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS ranks
from sales_data 
GROUP BY branch, day_name
) AS everyday_data
WHERE ranks =1;

-- Calculate the total number of items sold per payment method. List payment_menthod and total quantity
SELECT
	payment_method,
    SUM(quantity) AS total_quantity
FROM sales_data
GROUP BY payment_method
ORDER BY total_quantity DESC;

-- determine the average, minimum and maximum rating of category of each city.
-- List the city, average_rating, min_rating and maximum_rating

SELECT 
	city, 
    category,
    AVG(rating) AS average_rating,
    MIN(rating) AS min_rating,
    MAX(rating) AS maximum_rating
FROM sales_data
GROUP BY city, category;

-- Calculate the total profit for each category by considering total_profit as
-- (unit_price* quantity * profit_margin). List category and total_profit, ordered from highest to lowest profit.

SELECT 
	category,
    SUM(unit_price * quantity * profit_margin) AS total_profit
FROM sales_data
GROUP BY category
ORDER BY total_profit DESC;

-- Q.7
-- Determine the most common payment method for each Branch. Display Branch and the preferred_payment_method.
SELECT * FROM 
(
SELECT 
	branch,
    payment_method,
    COUNT(*) as total_trans,
    RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS ranks
FROM sales_data
GROUP BY branch, payment_method) AS data
WHERE ranks = 1;

-- Q.8
-- Categorize sales into 3 group MORNING, AFTERNOON, EVENING
-- Find out which of the shift and number of invoices

SELECT 
branch,
	CASE 
		WHEN HOUR(STR_TO_DATE(time, '%H:%i:%s')) < 12 THEN 'Evening'
		WHEN HOUR(STR_TO_DATE(time, '%H:%i:%s')) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
    END
 as shift_time,
 COUNT(*)
from sales_data
GROUP BY branch, shift_time
ORDER BY shift_time DESC;


-- 

WITH revenue_2022
AS 
(
	SELECT 
		branch,
        SUM(total_amount) as revenue
	FROM sales_data
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2022
    GROUP BY branch
),
revenue_2023
AS
(
	SELECT 
		branch,
        SUM(total_amount) as revenue
	FROM sales_data
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2023
    GROUP BY branch
)
SELECT 
	last_year.branch,
	last_year.revenue,
	current_year.revenue,
	ROUND((last_year.revenue - current_year.revenue)/last_year.revenue* 100,2) AS desc_ration
FROM revenue_2022 AS last_year 
JOIN revenue_2023 as current_year
ON last_year.branch= current_year.branch
WHERE last_year.revenue > current_year.revenue
ORDER BY desc_ration DESC
LIMIT 5;