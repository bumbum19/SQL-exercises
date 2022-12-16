/* 
Question: 2153

Table: Buses

+--------------+------+
| Column Name  | Type |
+--------------+------+
| bus_id       | int  |
| arrival_time | int  |
| capacity     | int  |
+--------------+------+
bus_id is the primary key column for this table.
Each row of this table contains information about the arrival time of a bus at the LeetCode station and its capacity (the number of empty seats it has).
No two buses will arrive at the same time and all bus capacities will be positive integers.

 

Table: Passengers

+--------------+------+
| Column Name  | Type |
+--------------+------+
| passenger_id | int  |
| arrival_time | int  |
+--------------+------+
passenger_id is the primary key column for this table.
Each row of this table contains information about the arrival time of a passenger at the LeetCode station.

 

Buses and passengers arrive at the LeetCode station. If a bus arrives at the station at a time tbus and a passenger arrived at a time tpassenger where tpassenger <= tbus and the passenger did not catch any bus, the passenger will use that bus. In addition, each bus has a capacity. If at the moment the bus arrives at the station there are more passengers waiting than its capacity capacity, only capacity passengers will use the bus.

Write an SQL query to report the number of users that used each bus.

Return the result table ordered by bus_id in ascending order.

The query result format is in the following example.

 

Example 1:

Input: 
Buses table:
+--------+--------------+----------+
| bus_id | arrival_time | capacity |
+--------+--------------+----------+
| 1      | 2            | 1        |
| 2      | 4            | 10       |
| 3      | 7            | 2        |
+--------+--------------+----------+
Passengers table:
+--------------+--------------+
| passenger_id | arrival_time |
+--------------+--------------+
| 11           | 1            |
| 12           | 1            |
| 13           | 5            |
| 14           | 6            |
| 15           | 7            |
+--------------+--------------+
Output: 
+--------+----------------+
| bus_id | passengers_cnt |
+--------+----------------+
| 1      | 1              |
| 2      | 1              |
| 3      | 2              |
+--------+----------------+
Explanation: 
- Passenger 11 arrives at time 1.
- Passenger 12 arrives at time 1.
- Bus 1 arrives at time 2 and collects passenger 11 as it has one empty seat.

- Bus 2 arrives at time 4 and collects passenger 12 as it has ten empty seats.

- Passenger 12 arrives at time 5.
- Passenger 13 arrives at time 6.
- Passenger 14 arrives at time 7.
- Bus 3 arrives at time 7 and collects passengers 12 and 13 as it has two empty seats.

 */
 
 
 # Solution
 
WITH RECURSIVE  cte AS 
(SELECT passenger_id, 
 MIN(b.arrival_time) AS  arrival_time 
 FROM buses b
 JOIN passengers p 
 ON  p.arrival_time <= b.arrival_time 
 GROUP BY passenger_id
 ),

cte2 AS 
(SELECT bus_id, buses.arrival_time AS bus_arrival, 
 COUNT(cte.arrival_time) AS max_passengers_cnt, capacity
FROM buses  
LEFT JOIN cte
    USING (arrival_time)
GROUP BY bus_id, bus_arrival, capacity 
ORDER BY bus_id
),

cte3 AS 
(SELECT bus_id, bus_arrival, max_passengers_cnt, capacity, 
 LAG(max_passengers_cnt-capacity) OVER 
    (ORDER BY bus_arrival) AS cnt, 
 LAG(bus_id) OVER 
    (ORDER BY bus_arrival) AS last_bus
FROM cte2 ),

cte4(bus_id, cnt2)
AS
(SELECT bus_id, 0  FROM cte3 WHERE cnt IS NULL
 UNION ALL
 SELECT cte3.bus_id,  CASE WHEN  cnt2 + cte3.cnt < 0 THEN 0
                      ELSE cnt2+cte3.cnt END 
 FROM cte4   
 JOIN cte3 
    ON cte3.last_bus = cte4.bus_id 

)

SELECT bus_id, 
LEAST(cnt2+max_passengers_cnt,capacity) AS passengers_cnt  
FROM cte4 
JOIN cte3 
    USING(bus_id)
ORDER BY bus_id;







