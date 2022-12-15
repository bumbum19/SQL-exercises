/*
Question: 2292
Table: Orders

+---------------+------+
| Column Name   | Type |
+---------------+------+
| order_id      | int  |
| product_id    | int  |
| quantity      | int  |
| purchase_date | date |
+---------------+------+
order_id is the primary key for this table.
Each row in this table contains the ID of an order, the id of the product purchased, the quantity, and the purchase date.

 

Write an SQL query to report the IDs of all the products that were ordered three or more times in two consecutive years.

Return the result table in any order.

The query result format is shown in the following example.

 

Example 1:

Input: 
Orders table:
+----------+------------+----------+---------------+
| order_id | product_id | quantity | purchase_date |
+----------+------------+----------+---------------+
| 1        | 1          | 7        | 2020-03-16    |
| 2        | 1          | 4        | 2020-12-02    |
| 3        | 1          | 7        | 2020-05-10    |
| 4        | 1          | 6        | 2021-12-23    |
| 5        | 1          | 5        | 2021-05-21    |
| 6        | 1          | 6        | 2021-10-11    |
| 7        | 2          | 6        | 2022-10-11    |
+----------+------------+----------+---------------+
Output: 
+------------+
| product_id |
+------------+
| 1          |
+------------+
Explanation: 
Product 1 was ordered in 2020 three times and in 2021 three times. Since it was ordered three times in two consecutive years, we include it in the answer.
Product 2 was ordered one time in 2022. We do not include it in the answer.

*/

# Solution

-- MySQL, MS SQL Server

WITH cte AS
(SELECT product_id, 
 YEAR(purchase_date) AS current_year, 
 lead(YEAR(purchase_date)) OVER 
    (PARTITION BY product_id 
    ORDER BY YEAR(purchase_date) ) AS next_year
FROM orders 
GROUP BY product_id, YEAR(purchase_date) 
HAVING COUNT(*) >=3
)

SELECT 
DISTINCT product_id 
FROM cte 
WHERE next_year - current_year = 1;

-- Oracle, MySQL


WITH cte AS
(SELECT product_id, 
 EXTRACT(YEAR FROM purchase_date) AS current_year, 
 lead(EXTRACT(YEAR FROM purchase_date)) OVER 
    (PARTITION BY product_id 
    ORDER BY EXTRACT(YEAR FROM purchase_date) ) AS next_year
FROM orders 
GROUP BY product_id, EXTRACT(YEAR FROM purchase_date) 
HAVING COUNT(*) >=3
)

SELECT 
DISTINCT product_id 
FROM cte 
WHERE next_year - current_year = 1;


