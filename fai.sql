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
-- SOLUTION: Use a scalar aggregate to count the number of rows in the Order_tab
-- table where values for the attribute SO_DATE are strings that end in "2019" 
-- (determined by using the % wildcard).
SELECT count(*) as "Orders during 2019"
FROM Order_Tab
WHERE SO_DATE LIKE '%2019';

-- QUESTION 3: Create an inventory report of all bicycles (ITEM_NAME that 
-- includes “Bicycle”) and # of quantity on hand (QTY_ON_HAND). 
-- (See query below this one for potential alternate answer)
-- SOLUTION: Select the ItemName and QuantityOnHand in the Inventory_Tab
-- table where values for the attribute ItemName are strings that end in "Bicycle".
SELECT ItemName as "Bicycle Name", QuantityOnHand as "Quantity"
FROM Inventory_Tab
WHERE ItemName LIKE '%Bicycle'
ORDER BY ItemName;

-- QUESTION 3 ALTERNATE: Create an inventory report of all bicycles (ITEM_NAME 
-- that includes “Bicycle”) and # of quantity on hand (QTY_ON_HAND). 
-- (If you ARE supposed to COMBINE the rows for 20 in. Bicycles)
-- SOLUTION: Select the ItemName and QuantityOnHand (using the SUM() function) 
-- in the Inventory_Tab table where values for the attribute ItemName are strings
-- that end in "Bicycle". Group the results by ItemName.
SELECT ItemName as "Bicycle Name", SUM(QuantityOnHand) as "Quantity"
FROM Inventory_Tab
WHERE ItemName LIKE '%Bicycle'
GROUP BY ItemName
ORDER BY ItemName;

-- QUESTION 4: List all sales persons and their Year-to-Date sales performance 
-- (sum of SALES_YTD of each SALES_PERSON) using vector aggregate.
-- SOLUTION: Select the ABCSalesPerson and YearToDateSales for each Salesperson
-- (using the SUM() function) in the Customer_Tab table. Group the results by 
-- ABCSalesPerson to have the results output as a vector aggregate.
SELECT ABCSalesPerson as "Salesperson", SUM(YTDSales) as "Year to Date Sales"
FROM Customer_Tab
GROUP BY ABCSalesPerson
ORDER BY ABCSalesPerson;

-- QUESTION 5: List all states with the number of customers.
-- SOLUTION: Select the CustomerState and the number of customers in each state
-- (using the COUNT() function) in the Customer_Tab table. Group the results by 
-- CustomerState to have the results output as a vector aggregate that will list
-- the number of customers for each state.
SELECT CustomerState as "State", COUNT(*) as "Number of Customers"
FROM Customer_Tab
GROUP BY CustomerState
ORDER BY CustomerState;

-- QUESTION 6: List all items (ITEM_NAME) with quantity on hand (Qty_On_Hand) 
-- and the number of units sold (Qty_Ordered).
-- SOLUTION: Select ItemName and QuantityOnHand from the Inventory_Tab table,
-- as well as Quantity from the Order_Line_Tab table. Use the SUM() function to
-- calculate the number of units sold for each item. Use the COALESCE() function
-- to have an item's number of units sold (i.e., Quantity) display as 0 if none 
-- of any single item has not been sold yet. Specify ItemName and QuantityOnHand
-- in the GROUP BY clause to have the results of SUM() be displayed as a vector 
-- aggregate. Join the Inventory_Tab and Order_Line_Tab tables using one Left 
-- Outer Join operation to join the tables on the corresponding PK-FK attribute
-- and return all inventory products in the results even if any particular
-- product have not been sold yet.
SELECT inv.ItemName as "Item Name", inv.QuantityOnHand as "Quantity On QuantityOnHand",
COALESCE(SUM(ordl.Quantity),0) as "Number of Units Sold"
FROM Inventory_Tab inv LEFT OUTER JOIN Order_Line_Tab ordl ON
inv.item_number = ordl.item_number
GROUP BY inv.ItemName, inv.QuantityOnHand
ORDER BY inv.ItemName;

-- QUESTION 7: List CUST_CODE, CUST_NAME, CUST_CITY, CUST_STATE, and SO_NUMBER 
-- for all customers in NY, CA, TX, and RI. The list includes customer information
-- even for those customers who have not made an order.
-- SOLUTION: Select CUST_CODE, CustomerName, CustomerCity, and CustomerState from
-- the Customer_Tab table, as well as SO_NUMBER from the Order_Tab table. Join 
-- the Inventory_Tab and Order_Tab tables using one Left Outer Join operation to
-- join the tables on the corresponding PK-FK attribute and return all Customers
-- in the results even if any particular customer has not made an order yet. Use
-- the WHERE clause to only return rows pertaining to Customers from NY, CA, TX 
-- and RI.
SELECT cus.CUST_CODE as "Customer Code", cus.CustomerName as "Customer Name", 
cus.CustomerCity as "Customer Town/City", cus.CustomerState as "Customer State",
ord.SO_NUMBER as "Order Number"
FROM Customer_Tab cus LEFT OUTER JOIN Order_Tab ord ON
cus.CUST_CODE = ord.CUST_CODE 
WHERE cus.CustomerState IN ('NY', 'CA', 'TX', 'RI')
ORDER BY cus.CUST_CODE;

-- QUESTION 8: Create a list of products that have not been ordered. The list 
-- should show ITEM_NUMBER, ITEM_NAME, and UNIT_PRICE.
-- SOLUTION: Select Item_Number, ItemName, and UnitPrice from the Inventory_Tab 
-- table. Join the Inventory_Tab and Order_Line_Tab tables using one Left Outer 
-- Join operation to join the tables on the corresponding PK-FK attribute and 
-- return all inventory products in the results even if any particular product 
-- has not been ordered yet. Use the HAVING clause to only return groups of rows
-- for products that have not been sold yet (as determined through a use of the
-- SUM() and COALESCE() functions).
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
-- SOLUTION: Select CustomerName from the Customer_Tab table, SO_NUMBER and 
-- SO_DATE from the Order_Tab table, ITEM_NUMBER from the Inventory_Tab table,
-- Quantity from the Order_Line_Tab table, and SHIPMENT_NUMBER from the 
-- Sales_Tab table. Use four outer joins to join five table to return all
-- information for orders that both have and have not been shipped. Use the 
-- WHERE clause to only return rows where the CUST_CODE is equal to 'ETC'
-- (Which is the CUST_CODE corresponding to Bikes Et Cetera).
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
-- SOLUTION: Select ItemName and UnitPrice from the Inventory_Tab table, as
-- well as the average UnitPrice from the Inventory_Tab through the combined use
-- of a non-correlated subquery in the FROM clause and the AVG() function. Use
-- the WHERE clause to only return rows where the UnitPrice is greater than (>)
-- the average UnitPrice that was calculated in the subquery. Use the ORDER BY
-- clause to sort the list by UnitPrice.
SELECT ItemName as "Item Name", UnitPrice as "Unit Price", "Average Price"
FROM Inventory_Tab, (SELECT AVG(UnitPrice) as "Average Price" FROM Inventory_Tab)
Where UnitPrice > "Average Price"
ORDER BY UnitPrice;

-- QUESTION 11: Write a SQL to create a summary report of performance of each 
-- SALES_PERSON as shown below. There are 5 SALES_PERSONs and each SALES_PERSON 
-- is responsible for more than two states exclusively. The report MUST include 
-- SALES_PERSON, CUST_STATE, and sum of order amount (SUM(QTY_ORDERED x SALES_PRICE)),
-- and should be ordered by SALES_PERSON and CUST_STATE.
-- SOLUTION: Select ABCSalesPerson and CustomerState from the Customer_Tab table,
-- as well as the sum of order amount (UnitPrice x Quantity) through use of the SUM() 
-- function using attributes from both the Order_Line_Tab table and Inventory_Tab
-- table. Join four tables using three inner joins to be able to compute Quantity
-- (from the Order_Line_Tab) multiplied by UnitPrice (from the Inventory_Tab) for
-- each respective ABCSalesPerson within each respective CustomerState. Use the 
-- ORDER BY clause to first sort the list by ABCSalesPerson and then sort the 
-- list by CustomerState.
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
-- SOLUTION: Select CustomerName from the Customer_Tab table, SO_DATE from the 
-- Order_Tab table, the number of orders by counting the number of SO_NUMBERs
-- in the Order_Line_Tab table using COUNT(), and the sum of order amount 
-- (UnitPrice x Quantity) through use of the SUM() function using attributes from
-- both the Order_Line_Tab table and Inventory_Tab. Convert SO_DATE to a 'YYYY' 
-- format by calling the TO_CHAR() function. Join four tables using three inner 
-- joins to be able to compute Quantity (from the Order_Line_Tab) multiplied by 
-- UnitPrice (from the Inventory_Tab) for each respective CustomerName. Use the 
-- WHERE clause to only return rows where CustomerState is in ('NY', 'CA', 'TX',
-- 'RI') and YEAR is within a selected 3-year period (2017-2019).
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
-- SOLUTION: Select ITEM_NUMBER from the Inventory_Tab table and the sum of 
-- order amount (UnitPrice x Quantity) through use of the SUM() function using 
-- attributes from both the Order_Line_Tab table and Inventory_Tab. Join two
-- tables using one inner join operation to join Inventory_Tab on Order_Line_Tab
-- using corresponding PK-FK pairs. Since an aggregate function (SUM()) is being
-- used, group the results by Item_Number. Use the HAVING clause to only return
-- groups of rows where the sum of order amount (i.e., SUM(UnitPrice x Quantity))
-- is equal to (=) the output a non-correlated subquery that will return the 
-- maximum sum of order amount using the MAX() function. Within the subquery,
-- perform an inner join operation and specify the GROUP BY clause identically to
-- how they are specified in the outer query.
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
