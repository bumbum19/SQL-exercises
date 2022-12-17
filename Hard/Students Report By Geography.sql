/*
Question: 618
Table: Student

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| name        | varchar |
| continent   | varchar |
+-------------+---------+
There is no primary key for this table. It may contain duplicate rows.
Each row of this table indicates the name of a student and the continent they came from.

 

A school has students from Asia, Europe, and America.

Write an SQL query to pivot the continent column in the Student table so that each name is sorted alphabetically and displayed underneath its corresponding continent. The output headers should be America, Asia, and Europe, respectively.

The test cases are generated so that the student number from America is not less than either Asia or Europe.

The query result format is in the following example.

 

Example 1:

Input: 
Student table:
+--------+-----------+
| name   | continent |
+--------+-----------+
| Jane   | America   |
| Pascal | Europe    |
| Xi     | Asia      |
| Jack   | America   |
+--------+-----------+
Output: 
+---------+------+--------+
| America | Asia | Europe |
+---------+------+--------+
| Jack    | Xi   | Pascal |
| Jane    | null | null   |
+---------+------+--------+

 

Follow up: If it is unknown which continent has the most students, could you write a query to generate the student report?
*/

# Solution


WITH cte_America AS
(SELECT CASE WHEN continent='America'THEN name ELSE NULL END AS  America, 
 ROW_NUMBER() OVER 
  (ORDER BY  CASE WHEN continent='America'THEN name ELSE 'zzz' END  ) AS ranking FROM student),
cte_Asia AS
(SELECT CASE WHEN continent='Asia' THEN name ELSE NULL END AS  Asia, 
 ROW_NUMBER() OVER 
  (ORDER BY   CASE WHEN continent='Asia 'THEN name ELSE 'zzz' END   ) AS  ranking FROM student),
 cte_Europe AS
(SELECT CASE WHEN continent='Europe'THEN name ELSE NULL END AS  Europe, 
 ROW_NUMBER() OVER 
    (ORDER BY    CASE WHEN continent='Europe'THEN name ELSE 'zzz' END  ) AS  ranking FROM student)


SELECT 
America, 
Asia, 
Europe 
FROM cte_America
JOIN cte_Asia 
    USING (ranking)
JOIN cte_Europe
    USING (ranking)
WHERE America IS NOT NULL 
OR Asia IS NOT NULL
OR Europe IS NOT NULL;


