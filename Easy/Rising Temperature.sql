/*
Question: 197
Table: Weather

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the primary key for this table.
This table contains information about the temperature on a certain day.

 

Write an SQL query to find all dates' Id with higher temperatures compared to its previous dates (yesterday).

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Weather table:
+----+------------+-------------+
| id | recordDate | temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+
Output: 
+----+
| id |
+----+
| 2  |
| 4  |
+----+
Explanation: 
In 2015-01-02, the temperature was higher than the previous day (10 -> 25).
In 2015-01-04, the temperature was higher than the previous day (20 -> 30).
*/

# Solution

-- MySQL

WITH lag_weather AS
(
 SELECT id, recordDate, temperature, 
 LAG(temperature) OVER (ORDER BY recordDate) AS temp_lag, 
 LAG(recordDate) OVER (ORDER BY recordDate) AS date_lag
FROM weather 
)
SELECT 
id 
FROM lag_weather 
WHERE temperature > temp_lag 
AND DATEDIFF(recordDate,date_lag) = 1;


-- MS SQL Server

WITH lag_weather AS
(
 SELECT id, recordDate, temperature, 
 LAG(temperature) OVER (ORDER BY recordDate) AS temp_lag, 
 LAG(recordDate) OVER (ORDER BY recordDate) AS date_lag
FROM weather 
)
SELECT 
id
FROM lag_weather 
WHERE temperature > temp_lag 
AND DATEDIFF(DAY,recordDate,date_lag) = -1;

-- Oracle

WITH lag_weather AS
(
 SELECT id, recordDate, temperature, 
 LAG(temperature) OVER (ORDER BY recordDate) AS temp_lag, 
 LAG(recordDate) OVER (ORDER BY recordDate) AS date_lag
FROM weather 
)
SELECT 
id 
FROM lag_weather 
WHERE temperature > temp_lag 
AND recordDate-date_lag = 1;
