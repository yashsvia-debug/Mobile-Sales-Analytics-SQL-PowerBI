/*
===============================================================================
Project      : Mobile Sales Analytics
Author       : Yashsvi Sharma
Database     : MySQL

Description:
This script contains intermediate-level business SQL queries performed on the
Mobile Sales dataset. These queries focus on deriving meaningful business
insights using filtering, grouping, aggregate functions, HAVING clauses,
subqueries, and Common Table Expressions (CTEs).
===============================================================================
*/

/*==============================================================================
Question 1
Find the top 5 brands based on total revenue.
==============================================================================*/

SELECT
    Brand,
    SUM(Units_Sold * Price_Per_Unit) AS Revenue
FROM mobile_sales
GROUP BY Brand
ORDER BY Revenue DESC
LIMIT 5;

/*==============================================================================
Question 2
Find the top 5 mobile models based on units sold.
==============================================================================*/

SELECT
    Mobile_Model,
    SUM(Units_Sold) AS Total_Units_Sold
FROM mobile_sales
GROUP BY Mobile_Model
ORDER BY Total_Units_Sold DESC
LIMIT 5;

/*==============================================================================
Question 3
Find the average customer rating for each brand.
==============================================================================*/

SELECT
    Brand,
    ROUND(AVG(Customer_Ratings),2) AS Average_Rating
FROM mobile_sales
GROUP BY Brand
ORDER BY Average_Rating DESC;

/*==============================================================================
Question 4
Find cities where total revenue exceeds 1,000,000.
==============================================================================*/

SELECT
    City,
    SUM(Units_Sold * Price_Per_Unit) AS Revenue
FROM mobile_sales
GROUP BY City
HAVING Revenue > 1000000
ORDER BY Revenue DESC;

-- Alternate Solution

SELECT
    City,
    SUM(Units_Sold * Price_Per_Unit) AS Revenue
FROM mobile_sales
GROUP BY City
HAVING SUM(Units_Sold * Price_Per_Unit) > 1000000
ORDER BY Revenue DESC;

/*==============================================================================
Question 5
Find the brand having the highest average selling price.
==============================================================================*/

SELECT
    Brand,
    ROUND(AVG(Price_Per_Unit),2) AS Average_Price
FROM mobile_sales
GROUP BY Brand
ORDER BY Average_Price DESC
LIMIT 1;

/*==============================================================================
Question 6
Find the most preferred payment method.
==============================================================================*/

-- Preferred Solution

SELECT
    Payment_Method,
    COUNT(*) AS Total_Transactions
FROM mobile_sales
GROUP BY Payment_Method
ORDER BY Total_Transactions DESC
LIMIT 1;

-- Alternate Solution

SELECT
    Payment_Method,
    COUNT(*) AS Total_Transactions
FROM mobile_sales
GROUP BY Payment_Method
HAVING COUNT(*) = (
        SELECT MAX(cnt)
        FROM(
            SELECT COUNT(*) AS cnt
            FROM mobile_sales
            GROUP BY Payment_Method
        ) t
);

/*==============================================================================
Question 7
Find the brand with the highest number of transactions.
==============================================================================*/

SELECT
    Brand,
    COUNT(*) AS Transactions
FROM mobile_sales
GROUP BY Brand
ORDER BY Transactions DESC
LIMIT 1;

/*==============================================================================
Question 8
Find the total revenue generated in each month.
==============================================================================*/

SELECT
    Year,
    Month,
    SUM(Units_Sold * Price_Per_Unit) AS Revenue
FROM mobile_sales
GROUP BY Year, Month
ORDER BY Year, Month;

/*==============================================================================
Question 9
Find the top-selling mobile model within each brand.
==============================================================================*/

WITH ModelSales AS
(
SELECT
    Brand,
    Mobile_Model,
    SUM(Units_Sold) AS Units
FROM mobile_sales
GROUP BY Brand, Mobile_Model
)

SELECT *
FROM ModelSales ms
WHERE Units =
(
SELECT MAX(Units)
FROM ModelSales
WHERE Brand = ms.Brand
);

/*==============================================================================
Question 10
Find brands whose average customer rating is above the overall average rating.
==============================================================================*/

SELECT
    Brand,
    ROUND(AVG(Customer_Ratings),2) AS Average_Rating
FROM mobile_sales
GROUP BY Brand
HAVING AVG(Customer_Ratings) >
(
SELECT AVG(Customer_Ratings)
FROM mobile_sales
)
ORDER BY Average_Rating DESC;



