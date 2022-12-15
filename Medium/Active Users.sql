/*
Question: 1454
Table: Accounts

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key for this table.
This table contains the account id and the user name of each account.

 

Table: Logins

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| login_date    | date    |
+---------------+---------+
There is no primary key for this table, it may contain duplicates.
This table contains the account id of the user who logged in and the login date. A user may log in multiple times in the day.

 

Active users are those who logged in to their accounts for five or more consecutive days.

Write an SQL query to find the id and the name of active users.

Return the result table ordered by id.

The query result format is in the following example.

 

Example 1:

Input: 
Accounts table:
+----+----------+
| id | name     |
+----+----------+
| 1  | Winston  |
| 7  | Jonathan |
+----+----------+
Logins table:
+----+------------+
| id | login_date |
+----+------------+
| 7  | 2020-05-30 |
| 1  | 2020-05-30 |
| 7  | 2020-05-31 |
| 7  | 2020-06-01 |
| 7  | 2020-06-02 |
| 7  | 2020-06-02 |
| 7  | 2020-06-03 |
| 1  | 2020-06-07 |
| 7  | 2020-06-10 |
+----+------------+
Output: 
+----+----------+
| id | name     |
+----+----------+
| 7  | Jonathan |
+----+----------+
Explanation: 
User Winston with id = 1 logged in 2 times only in 2 different days, so, Winston is not an active user.
User Jonathan with id = 7 logged in 7 times in 6 different days, five of them were consecutive days, so, Jonathan is an active user.

*/

# Solution

-- MySQL

WITH cte AS 
(
 SELECT id, login_date, 
 LAG(login_date,4) OVER 
    (PARTITION BY id 
     ORDER BY login_date) AS prev 
 FROM logins 
 GROUP BY id, login_date
)

SELECT
DISTINCT a.id, 
name 
FROM accounts a
JOIN cte 
  ON a.id = cte.id
WHERE DATEDIFF(login_date,prev) = 4 
ORDER BY id;

-- MS SQL Server

WITH cte AS 
(
 SELECT id, login_date, 
 LAG(login_date,4) OVER 
    (PARTITION BY id 
     ORDER BY login_date) AS prev 
 FROM logins 
 GROUP BY id, login_date
)

SELECT
DISTINCT a.id, 
name 
FROM accounts a
JOIN cte 
  ON a.id = cte.id
WHERE DATEDIFF(DAY, prev, login_date) = 4 
ORDER BY id;

-- Oracle

WITH cte AS 
(
 SELECT id, login_date, 
 LAG(login_date,4) OVER 
    (PARTITION BY id 
     ORDER BY login_date) AS prev 
 FROM logins 
 GROUP BY id, login_date
)

SELECT
DISTINCT a.id, 
name 
FROM accounts a
JOIN cte 
  ON a.id = cte.id
WHERE login_date - prev = 4 
ORDER BY id;



