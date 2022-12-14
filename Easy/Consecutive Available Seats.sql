/* 
Question: 603
Table: Cinema

+-------------+------+
| Column Name | Type |
+-------------+------+
| seat_id     | int  |
| free        | bool |
+-------------+------+
seat_id is an auto-increment primary key column for this table.
Each row of this table indicates whether the ith seat is free or not. 1 means free while 0 means occupied.

 

Write an SQL query to report all the consecutive available seats in the cinema.

Return the result table ordered by seat_id in ascending order.

The test cases are generated so that more than two seats are consecutively available.

The query result format is in the following example.

 

Example 1:

Input: 
Cinema table:
+---------+------+
| seat_id | free |
+---------+------+
| 1       | 1    |
| 2       | 0    |
| 3       | 1    |
| 4       | 1    |
| 5       | 1    |
+---------+------+
Output: 
+---------+
| seat_id |
+---------+
| 3       |
| 4       |
| 5       |
+---------+

 */
 
# Solution
 


WITH seat_neigh 
AS
(SELECT seat_id, free, 
 LEAD(free) OVER (ORDER BY seat_id) AS forward, 
 LAG(free) OVER (ORDER BY seat_id) AS back
 FROM cinema 
 )
SELECT 
seat_id 
FROM seat_neigh 
WHERE free = 1
AND (forward = 1 OR back = 1) 
ORDER BY seat_id;
