/* 
Question: 2173
Table: Matches

+-------------+------+
| Column Name | Type |
+-------------+------+
| player_id   | int  |
| match_day   | date |
| result      | enum |
+-------------+------+
(player_id, match_day) is the primary key for this table.
Each row of this table contains the ID of a player, the day of the match they played, and the result of that match.
The result column is an ENUM type of ('Win', 'Draw', 'Lose').

 

The winning streak of a player is the number of consecutive wins uninterrupted by draws or losses.

Write an SQL query to count the longest winning streak for each player.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Matches table:
+-----------+------------+--------+
| player_id | match_day  | result |
+-----------+------------+--------+
| 1         | 2022-01-17 | Win    |
| 1         | 2022-01-18 | Win    |
| 1         | 2022-01-25 | Win    |
| 1         | 2022-01-31 | Draw   |
| 1         | 2022-02-08 | Win    |
| 2         | 2022-02-06 | Lose   |
| 2         | 2022-02-08 | Lose   |
| 3         | 2022-03-30 | Win    |
+-----------+------------+--------+
Output: 
+-----------+----------------+
| player_id | longest_streak |
+-----------+----------------+
| 1         | 3              |
| 2         | 0              |
| 3         | 1              |
+-----------+----------------+
Explanation: 
Player 1:
From 2022-01-17 to 2022-01-25, player 1 won 3 consecutive matches.
On 2022-01-31, player 1 had a draw.
On 2022-02-08, player 1 won a match.
The longest winning streak was 3 matches.

Player 2:
From 2022-02-06 to 2022-02-08, player 2 lost 2 consecutive matches.
The longest winning streak was 0 matches.

Player 3:
On 2022-03-30, player 3 won a match.
The longest winning streak was 1 match.
 */
 
 # Solution
 
 WITH t AS
(SELECT player_id, match_day, IF(result='Win',1,0) result, 
IF( NOT LAG(result) OVER w = 'Win',0,1 ) dummy FROM matches 
WINDOW w AS (PARTITION BY player_id ORDER BY match_day) ),

t2 AS 
(SELECT player_id, match_day, result, ROW_NUMBER() OVER w -SUM(result) OVER w block  FROM t 
WHERE NOT(result=0 AND dummy =0)
WINDOW w AS (PARTITION BY player_id ORDER BY match_day)),

t3 AS 
(SELECT player_id, block, SUM(result) streak  FROM t2 GROUP BY 1,2)

SELECT player_id, MAX(streak) longest_streak FROM t3 GROUP BY 1
