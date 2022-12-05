/*
Question: 1127
Table: Spending

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| spend_date  | date    |
| platform    | enum    | 
| amount      | int     |
+-------------+---------+
The table logs the history of the spending of users that make purchases from an online shopping website that has a desktop and a mobile application.
(user_id, spend_date, platform) is the primary key of this table.
The platform column is an ENUM type of ('desktop', 'mobile').

 

Write an SQL query to find the total number of users and the total amount spent using the mobile only, the desktop only, and both mobile and desktop together for each date.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Spending table:
+---------+------------+----------+--------+
| user_id | spend_date | platform | amount |
+---------+------------+----------+--------+
| 1       | 2019-07-01 | mobile   | 100    |
| 1       | 2019-07-01 | desktop  | 100    |
| 2       | 2019-07-01 | mobile   | 100    |
| 2       | 2019-07-02 | mobile   | 100    |
| 3       | 2019-07-01 | desktop  | 100    |
| 3       | 2019-07-02 | desktop  | 100    |
+---------+------------+----------+--------+
Output: 
+------------+----------+--------------+-------------+
| spend_date | platform | total_amount | total_users |
+------------+----------+--------------+-------------+
| 2019-07-01 | desktop  | 100          | 1           |
| 2019-07-01 | mobile   | 100          | 1           |
| 2019-07-01 | both     | 200          | 1           |
| 2019-07-02 | desktop  | 100          | 1           |
| 2019-07-02 | mobile   | 100          | 1           |
| 2019-07-02 | both     | 0            | 0           |
+------------+----------+--------------+-------------+ 
Explanation: 
On 2019-07-01, user 1 purchased using both desktop and mobile, user 2 purchased using mobile only and user 3 purchased using desktop only.
On 2019-07-02, user 2 purchased using mobile only, user 3 purchased using desktop only and no one purchased using both platforms.

*/

# Solution


WITH t1 AS 
(SELECT DISTINCT spend_date FROM spending),
t2 AS 
(SELECT 'desktop,mobile' platforms UNION SELECT 
'desktop' platforms UNION SELECT 'mobile' platforms),
t3 AS
(SELECT user_id, spend_date, GROUP_CONCAT(platform ORDER BY platform) platforms FROM spending 
GROUP BY 1,2)

SELECT spend_date, IF(platforms='desktop,mobile','both',platforms) platform,
IFNULL(SUM(amount),0) total_amount,
COUNT(DISTINCT user_id) total_users 
FROM spending NATURAL RIGHT JOIN (t3 NATURAL RIGHT JOIN (t1,t2))
GROUP BY 1,2





