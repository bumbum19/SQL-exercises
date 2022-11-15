/* 
Question: 571
Table: Numbers

+-------------+------+
| Column Name | Type |
+-------------+------+
| num         | int  |
| frequency   | int  |
+-------------+------+
num is the primary key for this table.
Each row of this table shows the frequency of a number in the database.

 

The median is the value separating the higher half from the lower half of a data sample.

Write an SQL query to report the median of all the numbers in the database after decompressing the Numbers table. Round the median to one decimal point.

The query result format is in the following example.

 

Example 1:

Input: 
Numbers table:
+-----+-----------+
| num | frequency |
+-----+-----------+
| 0   | 7         |
| 1   | 1         |
| 2   | 3         |
| 3   | 1         |
+-----+-----------+
Output: 
+--------+
| median |
+--------+
| 0.0    |
+--------+
Explanation: 
If we decompress the Numbers table, we will get [0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3], so the median is (0 + 0) / 2 = 0.

 */
 
 
 # Solution 
 
WITH t AS
(SELECT num, IFNULL(SUM(frequency) OVER (ORDER BY num RANGE BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0) start, 
SUM(frequency) OVER (ROWS UNBOUNDED PRECEDING) finish,
SUM(frequency) OVER () size
FROM numbers)


SELECT ROUND(AVG(IF(FLOOR((size+1)/2)  BETWEEN start+1 AND finish OR 
CEIL((size+1)/2)  BETWEEN start+1 AND finish,num,NULL)),1) median FROM t

