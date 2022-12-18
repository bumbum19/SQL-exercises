/*
Question: 2494
Table: HallEvents

+-------------+------+
| Column Name | Type |
+-------------+------+
| hall_id     | int  |
| start_day   | date |
| end_day     | date |
+-------------+------+
There is no primary key in this table. It may contain duplicates.
Each row of this table indicates the start day and end day of an event and the hall in which the event is held.

 

Write an SQL query to merge all the overlapping events that are held in the same hall. Two events overlap if they have at least one day in common.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
HallEvents table:
+---------+------------+------------+
| hall_id | start_day  | end_day    |
+---------+------------+------------+
| 1       | 2023-01-13 | 2023-01-14 |
| 1       | 2023-01-14 | 2023-01-17 |
| 1       | 2023-01-18 | 2023-01-25 |
| 2       | 2022-12-09 | 2022-12-23 |
| 2       | 2022-12-13 | 2022-12-17 |
| 3       | 2022-12-01 | 2023-01-30 |
+---------+------------+------------+
Output: 
+---------+------------+------------+
| hall_id | start_day  | end_day    |
+---------+------------+------------+
| 1       | 2023-01-13 | 2023-01-17 |
| 1       | 2023-01-18 | 2023-01-25 |
| 2       | 2022-12-09 | 2022-12-23 |
| 3       | 2022-12-01 | 2023-01-30 |
+---------+------------+------------+
Explanation: There are three halls.
Hall 1:
- The two events ["2023-01-13", "2023-01-14"] and ["2023-01-14", "2023-01-17"] overlap. We merge them in one event ["2023-01-13", "2023-01-17"].
- The event ["2023-01-18", "2023-01-25"] does not overlap with any other event, so we leave it as it is.
Hall 2:
- The two events ["2022-12-09", "2022-12-23"] and ["2022-12-13", "2022-12-17"] overlap. We merge them in one event ["2022-12-09", "2022-12-23"].
Hall 3:
- The hall has only one event, so we return it. Note that we only consider the events of each hall separately.

*/


# Solution 

WITH cte AS

(SELECT hall_id, start_day, 
 MAX(end_day) OVER  
  (PARTITION BY hall_id ORDER BY 
   start_day) AS end_day
 FROM hallevents  ),

cte2 as 
(SELECT hall_id, start_day, 
 LEAD(start_day) over (PARTITION BY hall_id order by start_day) AS next,
end_day FROM t
  order by hall_id, start_day ),
  t3 AS
  
 (SELECT hall_id,start_day,end_day,
 CASE WHEN next <= end_day THEN 1 ELSE 0 END AS ind FROM t2),
 t4 AS 
 (SELECT hall_id, end_day, COALESCE(lag(end_day) over (partition by hall_id order by end_day),'1900-01-01') as prev
 from t3 where ind = 0)

SELECT hall_id, dt.start_day, end_day FROM t4 JOIN LATERAL

(select start_day from hallevents where t4.hall_id = hall_id AND start_day > prev AND 
start_day <= t4.end_day order by start_day LIMIT 1) AS dt;
