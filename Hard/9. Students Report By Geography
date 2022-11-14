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
 */
 
 
 # Solution
 
 WITH t1 AS
(SELECT IF(continent='America',name,NULL) America, 
ROW_NUMBER() OVER (ORDER BY  IF(continent='America',name,'zzz')   ) ranking FROM student),

t2 AS
(SELECT IF(continent='Asia',name,NULL) Asia, 
ROW_NUMBER() OVER (ORDER BY  IF(continent='Asia',name,'zzz')   ) ranking FROM student),

t3 AS
(SELECT IF(continent='Europe',name,NULL) Europe, 
ROW_NUMBER() OVER (ORDER BY  IF(continent='Europe',name,'zzz')   ) ranking FROM student)


SELECT America,Asia, Europe FROM t1 NATURAL JOIN t2 NATURAL JOIN t3 WHERE America IS NOT NULL OR Asia IS NOT NULL OR 
Europe IS NOT NULL 
