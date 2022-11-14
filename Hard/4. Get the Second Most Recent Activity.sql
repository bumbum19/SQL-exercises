/* 
Question: 1369
Table: UserActivity

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| username      | varchar |
| activity      | varchar |
| startDate     | Date    |
| endDate       | Date    |
+---------------+---------+
There is no primary key for this table. It may contain duplicates.
This table contains information about the activity performed by each user in a period of time.
A person with username performed an activity from startDate to endDate.

 

Write an SQL query to show the second most recent activity of each user.

If the user only has one activity, return that one. A user cannot perform more than one activity at the same time.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
UserActivity table:
+------------+--------------+-------------+-------------+
| username   | activity     | startDate   | endDate     |
+------------+--------------+-------------+-------------+
| Alice      | Travel       | 2020-02-12  | 2020-02-20  |
| Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
| Alice      | Travel       | 2020-02-24  | 2020-02-28  |
| Bob        | Travel       | 2020-02-11  | 2020-02-18  |
+------------+--------------+-------------+-------------+
Output: 
+------------+--------------+-------------+-------------+
| username   | activity     | startDate   | endDate     |
+------------+--------------+-------------+-------------+
| Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
| Bob        | Travel       | 2020-02-11  | 2020-02-18  |
+------------+--------------+-------------+-------------+
Explanation: 
The most recent activity of Alice is Travel from 2020-02-24 to 2020-02-28, before that she was dancing from 2020-02-21 to 2020-02-23.
Bob only has one record, we just take that one.

 */
# Solution

WITH t AS 
(SELECT *, NTH_VALUE(enddate,2) OVER (PARTITION BY username ORDER BY enddate DESC ) second_last,
COUNT(*) OVER (PARTITION BY username) count_user
FROM UserActivity )

SELECT username, activity, startDate, endDate FROM t WHERE count_user=1 OR 
endDate = second_last
