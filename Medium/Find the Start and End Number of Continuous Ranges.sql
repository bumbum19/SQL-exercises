/*
Question: 1285
Table: Logs

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| log_id        | int     |
+---------------+---------+
log_id is the primary key for this table.
Each row of this table contains the ID in a log Table.

 

Write an SQL query to find the start and end number of continuous ranges in the table Logs.

Return the result table ordered by start_id.

The query result format is in the following example.

 

Example 1:

Input: 
Logs table:
+------------+
| log_id     |
+------------+
| 1          |
| 2          |
| 3          |
| 7          |
| 8          |
| 10         |
+------------+
Output: 
+------------+--------------+
| start_id   | end_id       |
+------------+--------------+
| 1          | 3            |
| 7          | 8            |
| 10         | 10           |
+------------+--------------+
Explanation: 
The result table should contain all ranges in table Logs.
From 1 to 3 is contained in the table.
From 4 to 6 is missing in the table
From 7 to 8 is contained in the table.
Number 9 is missing from the table.
Number 10 is contained in the table.

*/

# Solution

WITH ranking AS 
(
  SELECT log_id, 
  RANK() OVER (ORDER BY log_id) AS rate
  FROM logs  
),
max_range AS 
(

  SELECT 
  r1.log_id AS start_id, 
  MAX(r2.log_id) AS end_id  
  FROM ranking r1 JOIN ranking r2 
    ON r1.log_id <= r2.log_id 
    AND  r2.log_id - r1.log_id = r2.rate - r1.rate
  GROUP BY r1.log_id 
  ORDER BY start_id
)

SELECT 
MIN(start_id) AS start_id, 
end_id 
FROM max_range
GROUP BY end_id 
ORDER BY start_id;

