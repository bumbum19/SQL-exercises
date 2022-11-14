/* 
Question: 1384
Table: Product

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| product_name  | varchar |
+---------------+---------+
product_id is the primary key for this table.
product_name is the name of the product.

 

Table: Sales

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| product_id          | int     |
| period_start        | date    |
| period_end          | date    |
| average_daily_sales | int     |
+---------------------+---------+
product_id is the primary key for this table. 
period_start and period_end indicate the start and end date for the sales period, and both dates are inclusive.
The average_daily_sales column holds the average daily sales amount of the items for the period.
The dates of the sales years are between 2018 to 2020.

 

Write an SQL query to report the total sales amount of each item for each year, with corresponding product_name, product_id, product_name, and report_year.

Return the result table ordered by product_id and report_year.

The query result format is in the following example.

 

Example 1:

Input: 
Product table:
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 1          | LC Phone     |
| 2          | LC T-Shirt   |
| 3          | LC Keychain  |
+------------+--------------+
Sales table:
+------------+--------------+-------------+---------------------+
| product_id | period_start | period_end  | average_daily_sales |
+------------+--------------+-------------+---------------------+
| 1          | 2019-01-25   | 2019-02-28  | 100                 |
| 2          | 2018-12-01   | 2020-01-01  | 10                  |
| 3          | 2019-12-01   | 2020-01-31  | 1                   |
+------------+--------------+-------------+---------------------+
Output: 
+------------+--------------+-------------+--------------+
| product_id | product_name | report_year | total_amount |
+------------+--------------+-------------+--------------+
| 1          | LC Phone     |    2019     | 3500         |
| 2          | LC T-Shirt   |    2018     | 310          |
| 2          | LC T-Shirt   |    2019     | 3650         |
| 2          | LC T-Shirt   |    2020     | 10           |
| 3          | LC Keychain  |    2019     | 31           |
| 3          | LC Keychain  |    2020     | 31           |
+------------+--------------+-------------+--------------+
Explanation: 
LC Phone was sold for the period of 2019-01-25 to 2019-02-28, and there are 35 days for this period. Total amount 35*100 = 3500. 
LC T-shirt was sold for the period of 2018-12-01 to 2020-01-01, and there are 31, 365, 1 days for years 2018, 2019 and 2020 respectively.
LC Keychain was sold for the period of 2019-12-01 to 2020-01-31, and there are 31, 31 days for years 2019 and 2020 respectively.
*/

# Solution 

WITH t AS 
(SELECT 2018 report_year UNION SELECT 2019 report_year UNION SELECT 2020 report_year
)

SELECT product_id, product_name, CAST(report_year AS char) report_year ,SUM(CASE WHEN YEAR(period_start) = report_year AND  YEAR(period_end) = report_year
THEN DATEDIFF(period_end,period_start)+1
WHEN YEAR(period_start) = report_year THEN 365-DAYOFYEAR(period_start)+1
WHEN YEAR(period_end) = report_year THEN DAYOFYEAR(period_end)
ELSE IF(report_year=2019 AND YEAR(period_start)=2018
AND YEAR(period_end)=2020,365,0) END *average_daily_sales ) total_amount
FROM (t,sales) 
NATURAL JOIN product
GROUP BY 1,2,3
HAVING total_amount > 0 ORDER BY 1,3
