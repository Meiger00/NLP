-- QUESTION 1: Show the number of records in each table
-- SOLUTION: Use a scalar aggregate to count the number of rows for each table.
SELECT count(*) as "Number of Records in Customer Table"
FROM Customer_Tab;
SELECT count(*) as "Number of Records in Order Table"
FROM Order_Tab;
SELECT count(*) as "Number of Records in Sales Table"
FROM Sales_Tab;
SELECT count(*) as "Number of Records in Inventory Table"
FROM Inventory_Tab;
SELECT count(*) as "Number of Records in Sales Line Table"
FROM Sales_Line_Tab;
SELECT count(*) as "Number of Records in Order Line Table"
FROM Order_Line_Tab;

-- QUESTION 2: How many orders did the company receive in 2019?
SELECT count(*) as "Orders during 2019"
FROM Order_Tab
WHERE SO_DATE LIKE '%2019';

-- QUESTION 3: Create an inventory report of all bicycles (ITEM_NAME that 
-- includes “Bicycle”) and # of quantity on hand (QTY_ON_HAND). 
SELECT ItemName as "Bicycle Name", QuantityOnHand as "Quantity"
FROM Inventory_Tab
WHERE ItemName LIKE '%Bicycle'
ORDER BY ItemName;

-- QUESTION 4: List all sales persons and their Year-to-Date sales performance 
-- (sum of SALES_YTD of each SALES_PERSON) using vector aggregate.
SELECT ABCSalesPerson as "Salesperson", SUM(YTDSales) as "Year to Date Sales"
FROM Customer_Tab
GROUP BY ABCSalesPerson
ORDER BY ABCSalesPerson;

-- QUESTION 5: List all states with the number of customers.
SELECT CustomerState as "State", COUNT(*) as "Number of Customers"
FROM Customer_Tab
GROUP BY CustomerState
ORDER BY CustomerState;

-- QUESTION 6: List all items (ITEM_NAME) with quantity on hand (Qty_On_Hand) 
-- and the number of units sold (Qty_Ordered).
SELECT inv.ItemName as "Item Name", inv.QuantityOnHand as "Quantity On QuantityOnHand",
COALESCE(SUM(ordl.Quantity),0) as "Number of Units Sold"
FROM Inventory_Tab inv LEFT OUTER JOIN Order_Line_Tab ordl ON
inv.item_number = ordl.item_number
GROUP BY inv.ItemName, inv.QuantityOnHand
ORDER BY inv.ItemName;

-- QUESTION 7: List CUST_CODE, CUST_NAME, CUST_CITY, CUST_STATE, and SO_NUMBER 
-- for all customers in NY, CA, TX, and RI. The list includes customer information
-- even for those customers who have not made an order.
SELECT cus.CUST_CODE as "Customer Code", cus.CustomerName as "Customer Name", 
cus.CustomerCity as "Customer Town/City", cus.CustomerState as "Customer State",
ord.SO_NUMBER as "Order Number"
FROM Customer_Tab cus LEFT OUTER JOIN Order_Tab ord ON
cus.CUST_CODE = ord.CUST_CODE 
WHERE cus.CustomerState IN ('NY', 'CA', 'TX', 'RI')
ORDER BY cus.CUST_CODE;

-- QUESTION 8: Create a list of products that have not been ordered. The list 
-- should show ITEM_NUMBER, ITEM_NAME, and UNIT_PRICE.
SELECT inv.item_number as "Item Number", inv.ItemName as "Item Name",
inv.UnitPrice as "Unit Price"
FROM Inventory_Tab inv LEFT OUTER JOIN Order_Line_Tab ordl ON
inv.item_number = ordl.item_number
GROUP BY inv.ItemName, inv.item_number, inv.UnitPrice
HAVING COALESCE(SUM(ordl.Quantity),0) = 0
ORDER BY inv.ItemName;

-- QUESTION 9: Show all order and shipping information related to 'Bikes Et Cetera'.
-- Note that there are some orders that have not been shipped. The list must 
-- include all order information whether or not they are shipped (use an outer 
-- join). The result should show CUST_NAME, SO_NUMBER, SO_DATE, ITEM_NUMBER, 
-- QTY_ORDERED, and SHIPMENT_NUMBER. The result should be ordered by CUST_NAME, 
-- and SO_NUMBER.
SELECT cus.CustomerName as "Customer Name", ord.SO_NUMBER as "Order Number", 
ord.SO_DATE as "Order Date", inv.ITEM_NUMBER as "Item Number", 
ordl.Quantity as "Quantity", sal.SHIPMENT_NUMBER as "Shipment Number"
FROM customer_tab cus LEFT OUTER JOIN order_tab ord ON cus.CUST_CODE = ord.CUST_CODE
LEFT OUTER JOIN order_line_tab ordl ON ord.SO_NUMBER = ordl.SO_NUMBER
LEFT OUTER JOIN inventory_tab inv ON ordl.ITEM_NUMBER = inv.ITEM_NUMBER
LEFT OUTER JOIN sales_tab sal ON sal.CUST_CODE = cus.CUST_CODE
WHERE ord.CUST_CODE = 'ETC'
ORDER BY cus.CustomerName, ord.SO_NUMBER;

-- QUESTION 10: Which ITEMs have a unit price that is higher than the average 
-- unit price? Create a list of those items including ITEM_NAME, UNIT_PRICE, and
-- AVG_UNIT_PRICE, and sort the list by unit price.
SELECT ItemName as "Item Name", UnitPrice as "Unit Price", "Average Price"
FROM Inventory_Tab, (SELECT AVG(UnitPrice) as "Average Price" FROM Inventory_Tab)
Where UnitPrice > "Average Price"
ORDER BY UnitPrice;

-- QUESTION 11: Write a SQL to create a summary report of performance of each 
-- SALES_PERSON as shown below. There are 5 SALES_PERSONs and each SALES_PERSON 
-- is responsible for more than two states exclusively. The report MUST include 
-- SALES_PERSON, CUST_STATE, and sum of order amount (SUM(QTY_ORDERED x SALES_PRICE)),
-- and should be ordered by SALES_PERSON and CUST_STATE.
SELECT cus.ABCSalesPerson AS "SALES PERSON", cus.CustomerState AS "STATE",
SUM(ordl.quantity*inv.unitprice) as "Total Order Amount($)"
FROM order_tab ord INNER JOIN order_line_tab ordl ON
ord.SO_NUMBER = ordl.SO_NUMBER
INNER JOIN customer_tab cus ON cus.CUST_CODE = ord.CUST_CODE
INNER JOIN inventory_tab inv ON inv.ITEM_NUMBER = ordl.ITEM_NUMBER
GROUP BY cus.ABCSalesPerson, cus.CustomerState
ORDER BY cus.ABCSalesPerson, cus.CustomerState;

-- QUESTION 12: Write a SQL to generate an order summary report in the four 
-- states ('NY', 'CA', 'TX', 'RI') for 3-year data period. The report should 
-- include CUST_NAME, YEAR, SUM of order amount, and # of order transactions as
-- shown below. To get YEAR from SO_DATE, use “TO_CHAR(SO_DATE, 'YYYY')”.
SELECT cus.CustomerName as "Customer Name", 
TO_CHAR(ord.SO_DATE, 'YYYY') as "Year",
SUM(ordl.Quantity*inv.UnitPrice) as "Total Order Amount($)", 
COUNT(ordl.SO_NUMBER) as "# of Orders"
FROM order_tab ord INNER JOIN order_line_tab ordl ON
ord.SO_NUMBER = ordl.SO_NUMBER
INNER JOIN customer_tab cus ON cus.CUST_CODE = ord.CUST_CODE
INNER JOIN inventory_tab inv ON inv.ITEM_NUMBER = ordl.ITEM_NUMBER
WHERE (cus.CustomerState IN ('NY', 'CA', 'TX', 'RI')) AND
((TO_CHAR(ord.SO_DATE, 'YYYY') >= 2017 AND
TO_CHAR(ord.SO_DATE, 'YYYY') < 2020))
GROUP BY cus.CustomerName, TO_CHAR(ord.SO_DATE, 'YYYY')
ORDER BY cus.CustomerName;

-- QUESTION 13: Which item has been sold most in terms of sales revenue 
--(Quantity Ordered X Sales Price)? Show ITEM_NUMBER and sales revenue of the 
-- item. Use a subquery.
SELECT inv.ITEM_NUMBER as "Item Number", 
SUM(ordl.Quantity*inv.UnitPrice) as "Sales Revenue"
FROM Inventory_Tab inv INNER JOIN order_line_tab ordl ON
inv.ITEM_NUMBER = ordl.ITEM_NUMBER
GROUP BY inv.ITEM_NUMBER
HAVING SUM(ordl.Quantity*inv.UnitPrice) = 
(SELECT MAX(SUM(ordl.Quantity*inv.UnitPrice))
FROM Inventory_Tab inv INNER JOIN order_line_tab ordl ON
inv.ITEM_NUMBER = ordl.ITEM_NUMBER
GROUP BY inv.ITEM_NUMBER);
