/* 
Question: 2362
Table: Products

+-------------+------+
| Column Name | Type |
+-------------+------+
| product_id  | int  |
| price       | int  |
+-------------+------+
product_id is the primary key for this table.
Each row in this table shows the ID of a product and the price of one unit.

 

Table: Purchases

+-------------+------+
| Column Name | Type |
+-------------+------+
| invoice_id  | int  |
| product_id  | int  |
| quantity    | int  |
+-------------+------+
(invoice_id, product_id) is the primary key for this table.
Each row in this table shows the quantity ordered from one product in an invoice. 

 

Write an SQL query to show the details of the invoice with the highest price. If two or more invoices have the same price, return the details of the one with the smallest invoice_id.

Return the result table in any order.

The query result format is shown in the following example.

 

Example 1:

Input: 
Products table:
+------------+-------+
| product_id | price |
+------------+-------+
| 1          | 100   |
| 2          | 200   |
+------------+-------+
Purchases table:
+------------+------------+----------+
| invoice_id | product_id | quantity |
+------------+------------+----------+
| 1          | 1          | 2        |
| 3          | 2          | 1        |
| 2          | 2          | 3        |
| 2          | 1          | 4        |
| 4          | 1          | 10       |
+------------+------------+----------+
Output: 
+------------+----------+-------+
| product_id | quantity | price |
+------------+----------+-------+
| 2          | 3        | 600   |
| 1          | 4        | 400   |
+------------+----------+-------+
Explanation: 
Invoice 1: price = (2 * 100) = $200
Invoice 2: price = (4 * 100) + (3 * 200) = $1000
Invoice 3: price = (1 * 200) = $200
Invoice 4: price = (10 * 100) = $1000

The highest price is $1000, and the invoices with the highest prices are 2 and 4. We return the details of the one with the smallest ID, which is invoice 2.

 */
 
 
 # Solution:
 WITH t AS 
(SELECT invoice_id, product_id, quantity, quantity*price price, SUM(quantity*price) OVER w total
FROM purchases NATURAL JOIN  products
WINDOW w AS (PARTITION BY invoice_id)),
t2 AS 
(SELECT * FROM t WHERE total = (SELECT MAX(total) FROM t))

SELECT product_id, quantity, price FROM t2 WHERE invoice_id = (SELECT MIN(invoice_id) FROM t2)

 
