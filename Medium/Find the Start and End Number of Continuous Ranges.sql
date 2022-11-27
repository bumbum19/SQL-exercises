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

WITH t AS 
(SELECT log_id, RANK() OVER w 'rank' FROM logs  WINDOW w AS (ORDER BY log_id)),
t2 AS (SELECT s2.log_id start_id, MAX(s1.log_id) end_id  
FROM t s1 JOIN t s2 ON s1.log_id >= s2.log_id AND  s1.log_id-s2.log_id = s1.rank-s2.rank GROUP BY 1 ORDER BY 1)

SELECT MIN(start_id) start_id, end_id FROM t2 GROUP BY 2 ORDER BY 1
