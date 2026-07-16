/*
===============================================================================
Project      : Mobile Sales Analytics
Author       : Yashsvi Sharma
Database     : MySQL

Description:
This script contains advanced business SQL queries performed on the Mobile
Sales dataset. These queries focus on solving complex analytical business
problems using window functions, Common Table Expressions (CTEs), ranking,
running totals, percentage contribution, and month-over-month analysis.
===============================================================================
*/

/*==============================================================================
Question 1
Rank all brands based on total revenue.
==============================================================================*/

WITH BrandRevenue AS
(
    SELECT
        Brand,
        SUM(Units_Sold * Price_Per_Unit) AS Revenue
    FROM mobile_sales
    GROUP BY Brand
)

SELECT
    Brand,
    Revenue,
    DENSE_RANK() OVER(ORDER BY Revenue DESC) AS Revenue_Rank
FROM BrandRevenue;

/*==============================================================================
Question 2
Find the top 3 mobile models within each brand based on revenue.
==============================================================================*/

WITH ModelRevenue AS
(
    SELECT
        Brand,
        Mobile_Model,
        SUM(Units_Sold * Price_Per_Unit) AS Revenue
    FROM mobile_sales
    GROUP BY Brand, Mobile_Model
)

SELECT
    Brand,
    Mobile_Model,
    Revenue
FROM
(
    SELECT *,
           DENSE_RANK() OVER
           (
               PARTITION BY Brand
               ORDER BY Revenue DESC
           ) AS rn
    FROM ModelRevenue
) t
WHERE rn <= 3
ORDER BY Brand, Revenue DESC;

/*==============================================================================
Question 3
Calculate the cumulative monthly revenue.
==============================================================================*/

WITH MonthlyRevenue AS
(
    SELECT
        Year,
        Month,
        SUM(Units_Sold * Price_Per_Unit) AS Revenue
    FROM mobile_sales
    GROUP BY Year, Month
)

SELECT
    Year,
    Month,
    Revenue,
    SUM(Revenue) OVER
    (
        ORDER BY Year, Month
    ) AS Cumulative_Revenue
FROM MonthlyRevenue;

/*==============================================================================
Question 4
Calculate each brand's percentage contribution to total revenue.
==============================================================================*/

WITH BrandRevenue AS
(
    SELECT
        Brand,
        SUM(Units_Sold * Price_Per_Unit) AS Revenue
    FROM mobile_sales
    GROUP BY Brand
)

SELECT
    Brand,
    Revenue,
    ROUND
    (
        Revenue * 100.0 /
        SUM(Revenue) OVER(),
        2
    ) AS Revenue_Percentage
FROM BrandRevenue
ORDER BY Revenue DESC;

/*==============================================================================
Question 5
Calculate Month-over-Month (MoM) revenue growth.
==============================================================================*/

WITH MonthlyRevenue AS
(
    SELECT
        Year,
        Month,
        SUM(Units_Sold * Price_Per_Unit) AS Revenue
    FROM mobile_sales
    GROUP BY Year, Month
)

SELECT
    Year,
    Month,
    Revenue,
    LAG(Revenue) OVER(ORDER BY Year, Month) AS Previous_Month_Revenue,
    ROUND(
        (Revenue - LAG(Revenue) OVER(ORDER BY Year, Month))
        * 100.0 /
        NULLIF(LAG(Revenue) OVER(ORDER BY Year, Month), 0),
        2
    ) AS MoM_Growth_Percentage
FROM MonthlyRevenue;
