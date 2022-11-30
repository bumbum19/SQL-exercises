/*
Question: 2159
Table: Data

+-------------+------+
| Column Name | Type |
+-------------+------+
| first_col   | int  |
| second_col  | int  |
+-------------+------+
There is no primary key for this table and it may contain duplicates.

 

Write an SQL query to independently:

    order first_col in ascending order.
    order second_col in descending order.

The query result format is in the following example.

 

Example 1:

Input: 
Data table:
+-----------+------------+
| first_col | second_col |
+-----------+------------+
| 4         | 2          |
| 2         | 3          |
| 3         | 1          |
| 1         | 4          |
+-----------+------------+
Output: 
+-----------+------------+
| first_col | second_col |
+-----------+------------+
| 1         | 4          |
| 2         | 3          |
| 3         | 2          |
| 4         | 1          |
+-----------+------------+

*/

# Solution

WITH t AS 
(SELECT first_col, ROW_NUMBER() OVER w ranking FROM data WINDOW w AS (ORDER BY first_col)),
t2 AS 
(SELECT second_col, ROW_NUMBER() OVER w ranking FROM data WINDOW w AS (ORDER BY second_col DESC))

SELECT first_col, second_col FROM t  NATURAL JOIN t2 
