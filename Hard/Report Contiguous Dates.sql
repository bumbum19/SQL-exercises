/*
Question: 1225
Table: Failed

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| fail_date    | date    |
+--------------+---------+
fail_date is the primary key for this table.
This table contains the days of failed tasks.

 

Table: Succeeded

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| success_date | date    |
+--------------+---------+
success_date is the primary key for this table.
This table contains the days of succeeded tasks.

 

A system is running one task every day. Every task is independent of the previous tasks. The tasks can fail or succeed.

Write an SQL query to generate a report of period_state for each continuous interval of days in the period from 2019-01-01 to 2019-12-31.

period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks in this interval succeeded. Interval of days are retrieved as start_date and end_date.

Return the result table ordered by start_date.

The query result format is in the following example.

 

Example 1:

Input: 
Failed table:
+-------------------+
| fail_date         |
+-------------------+
| 2018-12-28        |
| 2018-12-29        |
| 2019-01-04        |
| 2019-01-05        |
+-------------------+
Succeeded table:
+-------------------+
| success_date      |
+-------------------+
| 2018-12-30        |
| 2018-12-31        |
| 2019-01-01        |
| 2019-01-02        |
| 2019-01-03        |
| 2019-01-06        |
+-------------------+
Output: 
+--------------+--------------+--------------+
| period_state | start_date   | end_date     |
+--------------+--------------+--------------+
| succeeded    | 2019-01-01   | 2019-01-03   |
| failed       | 2019-01-04   | 2019-01-05   |
| succeeded    | 2019-01-06   | 2019-01-06   |
+--------------+--------------+--------------+
Explanation: 
The report ignored the system state in 2018 as we care about the system in the period 2019-01-01 to 2019-12-31.
From 2019-01-01 to 2019-01-03 all tasks succeeded and the system state was "succeeded".
From 2019-01-04 to 2019-01-05 all tasks failed and the system state was "failed".
From 2019-01-06 to 2019-01-06 all tasks succeeded and the system state was "succeeded".

*/

# Solution

-- MySQL

WITH states AS
(SELECT fail_date AS date, 'failed' AS  period_state FROM failed 
 UNION ALL 
 SELECT success_date, 'succeeded' FROM succeeded ),

ranking AS
(SELECT date, period_state, 
 RANK() OVER 
    (PARTITION BY period_state 
     ORDER BY date) AS rnk FROM states 
 WHERE date >=  '2019-01-01'  
 AND date < '2020-01-01' 
 ),

cte AS 
(
 SELECT r1.period_state AS  period_state, 
 r1.date AS  start_date, 
 MAX(r2.date) AS end_date 
 FROM ranking r1 
 CROSS JOIN ranking r2 
 WHERE r1.rnk <= r2.rnk 
 AND r2.rnk - r1.rnk = DATEDIFF(r2.date,r1.date) 
 AND r1.period_state  = r2.period_state 
 GROUP BY r1.period_state, r1.date
 )

SELECT 
period_state, 
MIN(start_date) AS start_date, 
end_date FROM cte 
GROUP BY period_state, end_date 
ORDER BY end_date;


-- MS SQL Server

WITH states AS
(SELECT fail_date AS date, 'failed' AS  period_state FROM failed 
 UNION ALL 
 SELECT success_date, 'succeeded' FROM succeeded ),

ranking AS
(SELECT date, period_state, 
 RANK() OVER 
    (PARTITION BY period_state 
     ORDER BY date) AS rnk FROM states 
 WHERE date >=  '2019-01-01'  
 AND date < '2020-01-01' 
 ),

cte AS 
(
 SELECT r1.period_state AS  period_state, 
 r1.date AS  start_date, 
 MAX(r2.date) AS end_date 
 FROM ranking r1 
 CROSS JOIN ranking r2 
 WHERE r1.rnk <= r2.rnk 
 AND r2.rnk - r1.rnk = DATEDIFF(DAY,r1.date,r2.date) 
 AND r1.period_state  = r2.period_state 
 GROUP BY r1.period_state, r1.date
 )

SELECT 
period_state, 
MIN(start_date) AS start_date, 
end_date FROM cte 
GROUP BY period_state, end_date 
ORDER BY end_date;
