/* 
Question: 1767
Table: Tasks

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| task_id        | int     |
| subtasks_count | int     |
+----------------+---------+
task_id is the primary key for this table.
Each row in this table indicates that task_id was divided into subtasks_count subtasks labeled from 1 to subtasks_count.
It is guaranteed that 2 <= subtasks_count <= 20.

 

Table: Executed

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| task_id       | int     |
| subtask_id    | int     |
+---------------+---------+
(task_id, subtask_id) is the primary key for this table.
Each row in this table indicates that for the task task_id, the subtask with ID subtask_id was executed successfully.
It is guaranteed that subtask_id <= subtasks_count for each task_id.

 

Write an SQL query to report the IDs of the missing subtasks for each task_id.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Tasks table:
+---------+----------------+
| task_id | subtasks_count |
+---------+----------------+
| 1       | 3              |
| 2       | 2              |
| 3       | 4              |
+---------+----------------+
Executed table:
+---------+------------+
| task_id | subtask_id |
+---------+------------+
| 1       | 2          |
| 3       | 1          |
| 3       | 2          |
| 3       | 3          |
| 3       | 4          |
+---------+------------+
Output: 
+---------+------------+
| task_id | subtask_id |
+---------+------------+
| 1       | 1          |
| 1       | 3          |
| 2       | 1          |
| 2       | 2          |
+---------+------------+
Explanation: 
Task 1 was divided into 3 subtasks (1, 2, 3). Only subtask 2 was executed successfully, so we include (1, 1) and (1, 3) in the answer.
Task 2 was divided into 2 subtasks (1, 2). No subtask was executed successfully, so we include (2, 1) and (2, 2) in the answer.
Task 3 was divided into 4 subtasks (1, 2, 3, 4). All of the subtasks were executed successfully.

 */
 
 
# Solution

-- MySQL
 
WITH RECURSIVE cte  AS
(
SELECT 1 AS subtask_id
UNION ALL
SELECT subtask_id + 1 FROM cte WHERE subtask_id < 
        (SELECT MAX(subtasks_count) 
        FROM tasks)
)

SELECT 
t.task_id, 
cte.subtask_id FROM tasks t 
JOIN cte 
    ON subtask_id <= subtasks_count
LEFT JOIN executed e 
    ON t.task_id = e.task_id 
    AND cte.subtask_id= e.subtask_id 
WHERE e.task_id IS NULL;

-- MS SQL Server


WITH cte(subtask_id)  AS
(
SELECT 1 
UNION ALL
SELECT subtask_id + 1 FROM cte WHERE subtask_id < 
        20
)

SELECT 
t.task_id, 
cte.subtask_id FROM tasks t 
JOIN cte 
    ON subtask_id <= subtasks_count
EXCEPT 
SELECT task_id, subtask_id 
FROM executed;

-- Oracle 

WITH  cte (subtask_id) AS
(
SELECT 1 FROM dual
UNION ALL
SELECT subtask_id + 1 FROM cte WHERE subtask_id < 
        (SELECT MAX(subtasks_count) 
        FROM tasks)
)

SELECT 
t.task_id, 
cte.subtask_id FROM tasks t 
JOIN cte 
 ON subtask_id <= subtasks_count
LEFT JOIN executed e 
 ON t.task_id = e.task_id 
 AND cte.subtask_id= e.subtask_id 
WHERE e.task_id IS NULL;
 
 
