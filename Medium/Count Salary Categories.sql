/*
Question: 1907
Table: Accounts

+-------------+------+
| Column Name | Type |
+-------------+------+
| account_id  | int  |
| income      | int  |
+-------------+------+
account_id is the primary key for this table.
Each row contains information about the monthly income for one bank account.

 

Write an SQL query to report the number of bank accounts of each salary category. The salary categories are:

    "Low Salary": All the salaries strictly less than $20000.
    "Average Salary": All the salaries in the inclusive range [$20000, $50000].
    "High Salary": All the salaries strictly greater than $50000.

The result table must contain all three categories. If there are no accounts in a category, then report 0.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Accounts table:
+------------+--------+
| account_id | income |
+------------+--------+
| 3          | 108939 |
| 2          | 12747  |
| 8          | 87709  |
| 6          | 91796  |
+------------+--------+
Output: 
+----------------+----------------+
| category       | accounts_count |
+----------------+----------------+
| Low Salary     | 1              |
| Average Salary | 0              |
| High Salary    | 3              |
+----------------+----------------+
Explanation: 
Low Salary: Account 2.
Average Salary: No accounts.
High Salary: Accounts 3, 6, and 8.

*/

# Solution

WITH cat(category) AS 
(SELECT "Low Salary"  
 UNION ALL 
 SELECT "Average Salary" 
 UNION ALL 
 SELECT "High Salary" ) ,

cte AS 
(
 SELECT CASE WHEN income < 20000 THEN 'Low Salary' 
    WHEN income <= 50000 THEN 'Average Salary'
    ELSE 'High Salary' END AS category, 
 COUNT(*) AS accounts_count 
 FROM accounts 
 GROUP BY category
)

SELECT category, 
COALESCE(accounts_count,0) AS accounts_count  
FROM cat 
LEFT JOIN cte
    USING (category);


