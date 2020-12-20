-- STAGE 1: Draw an ER Diagram showing all entities and relationship among six tables.
-- (NOTE: ERD will be contained in a file outside of this script)

-------------------------------------------------------------------------------

-- STAGE 2: Create a manufacturing industry database as shown in Figure 5-10

-- Six separate queries that each drop a different table made during previous 
-- queries to prevent errors
DROP TABLE Order_Line_Tab;
DROP TABLE Sales_Line_Tab;
DROP TABLE Inventory_Tab;
DROP TABLE Sales_Tab;
DROP TABLE Order_Tab;
DROP TABLE Customer_Tab;

-- Step 1a: Create the Customer table
-- Creates a new table called "Customer_Tab" using attributes belonging
-- to the Customer entity as seen in the ER Diagram from Project Phase 1. 
-- The query also establishes the attribute CUST_CODE as the PK for the new 
-- table. Check constraints were added to prevent illegal values from being
-- added to columns pertaining to dollar amounts.
CREATE TABLE Customer_Tab
(CUST_CODE VARCHAR2(10) NOT NULL,
CustomerName VARCHAR2(50) NOT NULL,
CustomerCity VARCHAR2(20) NOT NULL,
CustomerState CHAR(2) NOT NULL,
CreditLimit NUMBER(10,2) NOT NULL
CHECK (CreditLimit >= 0),
YTDSales NUMBER(10,2) NOT NULL
CHECK (YTDSales >= 0),
ABCSalesPerson VARCHAR2(40) NOT NULL,
CONSTRAINT Customer_Primary PRIMARY KEY (CUST_CODE));

-- Step 1b: Create the Order table
-- Creates a new table called "Order_Tab" using attributes belonging
-- to the Order entity as seen in the ER Diagram from Project Phase 1. 
-- The query establishes the attribute SO_NUMBER as the PK for the new 
-- table, also establishing CUST_CODE from the "Customer_Tab" table as a FK.
CREATE TABLE Order_Tab
(SO_NUMBER NUMBER(11,0) NOT NULL,
CUST_CODE VARCHAR2(10) NOT NULL,
CustomerInformation VARCHAR2(15) NOT NULL,
SO_DATE DATE DEFAULT SYSDATE NOT NULL,
CONSTRAINT Order_Primary PRIMARY KEY (SO_NUMBER),
CONSTRAINT Order_Foreign FOREIGN KEY (CUST_CODE) 
REFERENCES Customer_Tab(CUST_CODE));

-- Step 1c: Create the Sales table
-- Creates a new table called "Sales_Tab" using attributes belonging
-- to the Sales entity as seen in the ER Diagram from Project Phase 1. 
-- The query establishes the attribute SHIPMENT_NUMBER as the PK for the new 
-- table, also establishing CUST_CODE from the "Customer_Tab" table as a FK.
CREATE TABLE Sales_Tab
(SHIPMENT_NUMBER NUMBER(15,0) NOT NULL,
InvoiceNumber INTEGER NOT NULL,
OrderID NUMBER(11,0) NOT NULL,
CUST_CODE VARCHAR2(10) NOT NULL,
CONSTRAINT Sales_Primary PRIMARY KEY (SHIPMENT_NUMBER),
CONSTRAINT Sales_Foreign FOREIGN KEY (CUST_CODE) 
REFERENCES Customer_Tab(CUST_CODE));

-- Step 1d: Create the Inventory table
-- Creates a new table called "Inventory_Tab" using attributes belonging
-- to the Inventory entity as seen in the ER Diagram from Project Phase 1. 
-- The query also establishes the attribute ITEM_NUMBER as the PK for the new 
-- table. Check constraints were added to prevent illegal values from being
-- added to columns pertaining to quantities or dollar amounts.
CREATE TABLE Inventory_Tab
(ITEM_NUMBER VARCHAR2(10) NOT NULL,
ItemName VARCHAR2(50) NOT NULL,
QuantityOnHand INTEGER NOT NULL
CHECK (QuantityOnHand >= 0),
UnitCost NUMBER(8,2) NOT NULL
CHECK (UnitCost >= 0),
UnitPrice NUMBER(8,2) NOT NULL
CHECK (UnitPrice >= 0),
CONSTRAINT Inventory_Primary PRIMARY KEY (ITEM_NUMBER));

-- Step 1e: Create the Sales Line table
-- Creates a new table called "Sales_Line_Tab" using attributes belonging
-- to the Sales Line Associative entity as seen in the ER Diagram from Project 
-- Phase 1. The query establishes the attributes SHIPMENT_NUMBER and 
-- ITEM_NUMBER as the composite PK for the new table, also establishing 
-- the same attributes as the FKs. Check constraints were added to prevent 
-- illegal values from being added to columns pertaining to quantities.
CREATE TABLE Sales_Line_Tab
(SHIPMENT_NUMBER NUMBER(15,0) NOT NULL,
ITEM_NUMBER VARCHAR2(10) NOT NULL,
PackageQuantity INTEGER NOT NULL
CHECK (PackageQuantity >= 0),
CONSTRAINT Sales_Line_Primary PRIMARY KEY (SHIPMENT_NUMBER, ITEM_NUMBER),
CONSTRAINT Sales_Line_Foreign1 FOREIGN KEY (SHIPMENT_NUMBER) 
REFERENCES Sales_Tab(SHIPMENT_NUMBER),
CONSTRAINT Sales_Line_Foreign2 FOREIGN KEY (ITEM_NUMBER) 
REFERENCES Inventory_Tab(ITEM_NUMBER));

-- Step 1f: Create the Order Line table
-- Creates a new table called "Order_Line_Tab" using attributes belonging
-- to the Order Line Associative entity as seen in the ER Diagram from Project 
-- Phase 1. The query establishes the attributes SO_NUMBER and ITEM_NUMBER as 
-- the composite PK for the new table, also establishing the same attributes as 
-- the FKs. Check constraints were added to prevent illegal values from being 
-- added to columns pertaining to quantities.
CREATE TABLE Order_Line_Tab
(SO_NUMBER NUMBER(11,0) NOT NULL,
ITEM_NUMBER VARCHAR2(10) NOT NULL,
Quantity INTEGER NOT NULL
CHECK (Quantity >= 0),
CONSTRAINT Order_Line_Primary PRIMARY KEY (SO_NUMBER, ITEM_NUMBER),
CONSTRAINT Order_Line_Foreign1 FOREIGN KEY (SO_NUMBER) 
REFERENCES Order_Tab(SO_NUMBER),
CONSTRAINT Order_Line_Foreign2 FOREIGN KEY (ITEM_NUMBER) 
REFERENCES Inventory_Tab(ITEM_NUMBER));

-------------------------------------------------------------------------------

-- STAGE 3: Populate all tables with data.

-- Six separate queries that each drop all rows from a different table made 
-- during previous queries
DELETE FROM Order_Line_Tab;
DELETE FROM Sales_Line_Tab;
DELETE FROM Inventory_Tab;
DELETE FROM Sales_Tab;
DELETE FROM Order_Tab;
DELETE FROM Customer_Tab;

-- 15 separate queries that each insert a row into the table called 
-- "Customer_Tab",  cumulatively inserting 15 rows into the table.
INSERT INTO Customer_Tab VALUES ('ETC', 'Bikes Et Cetera', 
'Elgin', 'IL',  10000.00, 9561.55, 'Wilke');
INSERT INTO Customer_Tab VALUES ('IBS', 'Inter. Bicycle Sales', 
'New York', 'NY', 5000.00, 4191.18, 'Breitenstein');
INSERT INTO Customer_Tab VALUES ('RODEBYKE', 'Rodebyke Bic. & Mopeds', 
 'San Jose', 'CA', 2000.00, 1142.50, 'Goodall');
INSERT INTO Customer_Tab VALUES ('STANS', 'Stan"s Cyclery', 
 'Hawthorne', 'NJ', 10000.00, 8330.00, 'Garcia');
INSERT INTO Customer_Tab VALUES ('WHEEL', 'Wheelaway Cycle Center', 
'Campbell', 'OH', 10000.00, 6854.00, 'Garcia');
INSERT INTO Customer_Tab VALUES ('KANYE', 'Kanye Bikes West', 
 'Brooklyn', 'NY', 1000.00, 200.00, 'Breitenstein'); 
INSERT INTO Customer_Tab VALUES ('BUSTER', 'Buster Cycles', 
 'Boston', 'MA', 9500.00, 5100.98, 'Wilke'); 
INSERT INTO Customer_Tab VALUES ('CARTER', 'Carter Cycles & Sons', 
 'Seattle', 'WA', 20000.00, 11821.60, 'Missy'); 
INSERT INTO Customer_Tab VALUES ('MARSHALL', 'Marshall Wheels', 
 'Detroit', 'MI', 1000.00, 200.00, 'Goodall'); 
INSERT INTO Customer_Tab VALUES ('OCEAN', 'Ocean Cycles', 
 'Los Angeles', 'CA', 10000.00, 2531.14, 'Goodall'); 
INSERT INTO Customer_Tab VALUES ('KENDRICK', 'Kendrick Knows Bikes', 
'Austin', 'TX', 500.00, 20.25, 'Wilke'); 
INSERT INTO Customer_Tab VALUES ('MY', 'My Biker', 
'Newport', 'RI', 4500.00, 876.92, 'Breitenstein'); 
INSERT INTO Customer_Tab VALUES ('DWAYNE', 'Dwayne Trick Rides',
 'Cherry Hill', 'NJ', 1500.00, 283.50, 'Garcia');
INSERT INTO Customer_Tab VALUES ('YOUNG', 'Young Cyclers', 
 'Miami', 'FL', 2000.00, 548.33, 'Missy'); 
INSERT INTO Customer_Tab VALUES ('MARAJ', 'Maraj Velocipedes',
'Phoenix', 'AZ', 20000.00, 13120.78, 'Missy'); 

-- 17 separate queries that each insert a row into the table called 
-- "Order_Tab", cumulatively inserting 17 rows into the table. Note that each 
-- row inserted into "Order_Tab" needs to reference a FK value (CUST_CODE) 
-- already in the "Customer_Tab" table to prevent the query from throwing an 
-- error.
INSERT INTO Order_Tab VALUES (1010, 'WHEEL', '453', '06/12/2005');
INSERT INTO Order_Tab VALUES (1011, 'ETC', '347', '06/12/2005');
INSERT INTO Order_Tab VALUES (1012, 'WHEEL', '56-6', '06/12/2005');
INSERT INTO Order_Tab VALUES (1013, 'IBS', '3422', '06/12/2005');
INSERT INTO Order_Tab VALUES (1014, 'ETC', '778', '06/12/2005');
INSERT INTO Order_Tab VALUES (1015, 'WHEEL', '5673', '06/12/2006');
INSERT INTO Order_Tab VALUES (1016, 'ETC', '3345', '06/12/2006');
INSERT INTO Order_Tab VALUES (12345, 'KANYE', '100', '01/01/2017'); 
INSERT INTO Order_Tab VALUES (23456, 'BUSTER', '200', '03/08/2019'); 
INSERT INTO Order_Tab VALUES (34567, 'CARTER', '300', '05/02/2019'); 
INSERT INTO Order_Tab VALUES (45678, 'MARSHALL', '400', '07/03/2019'); 
INSERT INTO Order_Tab VALUES (56789, 'OCEAN', '500', '11/05/2019'); 
INSERT INTO Order_Tab VALUES (12346, 'KENDRICK', '110', '01/10/2019'); 
INSERT INTO Order_Tab VALUES (23457, 'MY', '210', '02/10/2020'); 
INSERT INTO Order_Tab VALUES (34568, 'DWAYNE', '310', '01/02/2020'); 
INSERT INTO Order_Tab VALUES (45679, 'YOUNG', '410', '02/03/2020'); 
INSERT INTO Order_Tab VALUES (56780, 'MARAJ', '510', '03/30/2020');
UPDATE Order_Tab SET SO_DATE = '03/25/2017' WHERE SO_DATE LIKE '%05';
UPDATE Order_Tab SET SO_DATE = '04/18/2017' WHERE SO_DATE LIKE '%06';

-- 12 separate queries that each insert a row into the table called 
-- "Sales_Tab", cumulatively inserting 12 rows into the table. Note that each 
-- row inserted into "Sales_Tab" needs to reference a FK value (CUST_CODE) 
-- already in the "Customer_Tab" table to prevent the query from throwing an 
-- error.
INSERT INTO Sales_Tab VALUES (021207028, 35, 1011, 'ETC');
INSERT INTO Sales_Tab VALUES (021207042, 36, 1012, 'WHEEL');
INSERT INTO Sales_Tab VALUES (021201001, 37, 12345, 'KANYE'); 
INSERT INTO Sales_Tab VALUES (021201002, 38, 23456, 'BUSTER'); 
INSERT INTO Sales_Tab VALUES (021201003, 39, 34567, 'CARTER'); 
INSERT INTO Sales_Tab VALUES (021201004, 40, 45678, 'MARSHALL'); 
INSERT INTO Sales_Tab VALUES (021201005, 41, 56789, 'OCEAN'); 
INSERT INTO Sales_Tab VALUES (021201006, 42, 12345, 'KENDRICK'); 
INSERT INTO Sales_Tab VALUES (021201007, 43, 23456, 'MY'); 
INSERT INTO Sales_Tab VALUES (021201008, 44, 34567, 'DWAYNE'); 
INSERT INTO Sales_Tab VALUES (021201009, 45, 45678, 'YOUNG'); 
INSERT INTO Sales_Tab VALUES (021201000, 45, 56789, 'MARAJ'); 

-- 17 separate queries that each insert a row into the table called 
-- "Inventory_Tab",  cumulatively inserting 17 rows into the table.
INSERT INTO Inventory_Tab VALUES ('1000-1', '20 in. Bicycle', 247, 55.00, 137.50);
INSERT INTO Inventory_Tab VALUES ('1001-1', '26 in. Bicycle', 103, 60.00, 150.00); 
INSERT INTO Inventory_Tab VALUES ('1002-1', '24 in. Bicycle', 484, 60.00, 150.00); 
INSERT INTO Inventory_Tab VALUES ('1003-1', '20 in. Bicycle', 4, 24.37, 60.93); 
INSERT INTO Inventory_Tab VALUES ('1280-054', 'Kickstand', 72, 6.50, 16.25);
INSERT INTO Inventory_Tab VALUES ('2010-0050', 'Formed Handlebar', 90, 4.47, 11.25);
INSERT INTO Inventory_Tab VALUES ('3050-2197', 'Pedal', 23, 0.75, 1.88);
INSERT INTO Inventory_Tab VALUES ('3961-1010', 'Tire, 26 in.', 42, 1.45, 3.13);
INSERT INTO Inventory_Tab VALUES ('3961-1041', 'Tire Tube, 26 in.', 19, 1.25, 3.13);
INSERT INTO Inventory_Tab VALUES ('3965-1050', 'Spoke Reflector', 232, 0.29, 0.63);
INSERT INTO Inventory_Tab VALUES ('3965-1041', 'Spoke Reflector Light', 100, 3.13, 4.99);
INSERT INTO Inventory_Tab VALUES ('3970-1011', 'Wheel, 26 in.', 211, 10.50, 25.00);
INSERT INTO Inventory_Tab VALUES ('1000-017', 'Bicycle Seat', 25, 10.99, 29.99); 
INSERT INTO Inventory_Tab VALUES ('2200-144', 'Bicycle Rack', 16, 21.25, 65.99); 
INSERT INTO Inventory_Tab VALUES ('4391-235', 'Bicycle Horn', 7, 3.75, 8.99); 
INSERT INTO Inventory_Tab VALUES ('1292-238', 'Bicycle Lock', 62, 9.50, 29.99); 
INSERT INTO Inventory_Tab VALUES ('1827-229', 'Water Bottle Holder', 84, 4.25, 14.99); 

-- 13 separate queries that each insert a row into the table called 
-- "Sales_Line_Tab", cumulatively inserting 13 rows into the table. Note that 
-- each row inserted into "Sales_Line_Tab" needs to reference FK values 
-- (SHIPMENT_NUMBER, ITEM_NUMBER) already in the respective "Sales_Tab" and 
-- "Inventory_Tab" tables, respectively, to prevent the query from throwing an 
-- error.
INSERT INTO Sales_Line_Tab VALUES (021207028, '1001-1', 8); 
INSERT INTO Sales_Line_Tab VALUES (021207028, '1002-1', 4); 
INSERT INTO Sales_Line_Tab VALUES (021207042, '1001-1', 5); 
INSERT INTO Sales_Line_Tab VALUES (021201001, '1000-017', 3); 
INSERT INTO Sales_Line_Tab VALUES (021201002, '2200-144', 6); 
INSERT INTO Sales_Line_Tab VALUES (021201003, '4391-235', 1); 
INSERT INTO Sales_Line_Tab VALUES (021201004, '1292-238', 12); 
INSERT INTO Sales_Line_Tab VALUES (021201005, '1827-229', 14); 
INSERT INTO Sales_Line_Tab VALUES (021201006, '1000-017', 2); 
INSERT INTO Sales_Line_Tab VALUES (021201007, '2200-144', 5); 
INSERT INTO Sales_Line_Tab VALUES (021201008, '4391-235', 2); 
INSERT INTO Sales_Line_Tab VALUES (021201009, '1292-238', 13); 
INSERT INTO Sales_Line_Tab VALUES (021201000, '1827-229', 15); 

-- 23 separate queries that each insert a row into the table called 
-- "Order_Line_Tab", cumulatively inserting 23 rows into the table. Note that 
-- each row inserted into "Order_Line_Tab" needs to reference FK values 
-- (SO_NUMBER, ITEM_NUMBER) already in the respective "Sales_Tab" and 
-- "Inventory_Tab" tables, respectively, to prevent the query from throwing an 
-- error.
INSERT INTO Order_Line_Tab VALUES (1010, '1000-1', 5);
INSERT INTO Order_Line_Tab VALUES (1010, '2010-0050', 2);
INSERT INTO Order_Line_Tab VALUES (1011, '1001-1', 10);
INSERT INTO Order_Line_Tab VALUES (1011, '1002-1', 5);
INSERT INTO Order_Line_Tab VALUES (1012, '1003-1', 5);
INSERT INTO Order_Line_Tab VALUES (1012, '1001-1', 10);
INSERT INTO Order_Line_Tab VALUES (1013, '1001-1', 50);
INSERT INTO Order_Line_Tab VALUES (1014, '1003-1', 25);
INSERT INTO Order_Line_Tab VALUES (1015, '1003-1', 25);
INSERT INTO Order_Line_Tab VALUES (1016, '1003-1', 25);
INSERT INTO Order_Line_Tab VALUES (1016, '3965-1050', 50);
INSERT INTO Order_Line_Tab VALUES (1016, '3965-1041', 5);
INSERT INTO Order_Line_Tab VALUES (1016, '1000-1', 4);
INSERT INTO Order_Line_Tab VALUES (12345, '1000-017', 3); 
INSERT INTO Order_Line_Tab VALUES (23456, '2200-144', 6); 
INSERT INTO Order_Line_Tab VALUES (34567, '4391-235', 1); 
INSERT INTO Order_Line_Tab VALUES (45678, '1292-238', 12); 
INSERT INTO Order_Line_Tab VALUES (56789, '1827-229', 14); 
INSERT INTO Order_Line_Tab VALUES (12346, '1000-017', 2); 
INSERT INTO Order_Line_Tab VALUES (23457, '2200-144', 5); 
INSERT INTO Order_Line_Tab VALUES (34568, '4391-235', 2); 
INSERT INTO Order_Line_Tab VALUES (45679, '1292-238', 13); 
INSERT INTO Order_Line_Tab VALUES (56780, '1827-229', 15); 

-------------------------------------------------------------------------------

-- STAGE 4: Data import

-- Six queries that grant users within the BUS456_09 schema the ability to 
-- use the SELECT statement to query data from the BUS456_01 schema
GRANT SELECT ON customer_tab TO BUS456_09;
GRANT SELECT ON order_tab TO BUS456_09;
GRANT SELECT ON sales_tab TO BUS456_09;
GRANT SELECT ON inventory_tab TO BUS456_09;
GRANT SELECT ON order_line_tab TO BUS456_09;
GRANT SELECT ON sales_line_tab TO BUS456_09;

-- Customer (PK = CUST_CODE)
-- One query that will insert all rows from our partner group's table into the 
-- Customer_tab table that do not have a CUST_CODE value equal to that among any
-- of the rows that are currently in our table. A non-correlated subquery is used
-- in the WHERE clause to compare CUST_CODE among rows in our partner group's
-- table versus our table.
INSERT INTO BUS456_01.customer_tab
SELECT *
FROM BUS456_09.Customer_t
WHERE Customer_t.CustomerCode NOT IN (select CUST_CODE from BUS456_01.customer_tab);

-- Order (PK = SO_NUMBER)
-- One query that will insert all rows from our partner group's table into the 
-- Order_tab table that do not have a SO_NUMBER value equal to that among any
-- of the rows that are currently in our table. A non-correlated subquery is used
-- in the WHERE clause to compare SO_NUMBER among rows in our partner group's
-- table versus our table.
INSERT INTO BUS456_01.order_tab
SELECT *
FROM BUS456_09.order_t
WHERE SO_NUMBER NOT IN (SELECT SO_NUMBER from BUS456_01.order_tab);

-- Sales (PK = Shipment_Number)
-- One query that will insert all rows from our partner group's table into the 
-- Sales_tab table that do not have a SHIPMENT_NUMBER value equal to that among 
-- any of the rows that are currently in our table. A non-correlated subquery is
-- used in the WHERE clause to compare SHIPMENT_NUMBER among rows in our partner 
-- group's table versus our table.
INSERT INTO BUS456_01.sales_tab
SELECT *
FROM BUS456_09.Sales_t
WHERE SHIPMENTNUMBER NOT IN (SELECT SHIPMENT_NUMBER from BUS456_01.sales_tab);

-- Inventory (PK = Item_Number)
-- One query that will insert all rows from our partner group's table into the 
-- Inventory_tab table that do not have an ITEM_NUMBER value equal to that among 
-- any of the rows that are currently in our table. A non-correlated subquery is
-- used in the WHERE clause to compare ITEM_NUMBER among rows in our partner 
-- group's table versus our table.
INSERT INTO BUS456_01.inventory_tab
SELECT *
FROM BUS456_09.Inventory_t
WHERE PRODUCTNUMBER NOT IN (SELECT ITEM_NUMBER from BUS456_01.inventory_tab);

-- Sales Line Inventory (Composite PK = (Shipment_Number, Item_Number))
-- One query that will insert all rows from our partner group's table into the 
-- Sales_line_tab table that do not have both an ITEM_NUMBER and SHIPMENT_NUMBER
-- value, respectively, equal to that among any of the rows that are currently 
-- in our table. Two non-correlated subqueries are used in the WHERE clause to 
-- compare ITEM_NUMBER and SHIPMENT_NUMBER, respectively, among rows in our 
-- partner group's table versus our table.
INSERT INTO BUS456_01.sales_line_tab
SELECT *
FROM BUS456_09.salesline
WHERE PRODUCTNUMBER NOT IN (SELECT ITEM_NUMBER from BUS456_01.sales_line_tab)
OR SHIPMENTNUMBER NOT IN (SELECT SHIPMENT_NUMBER from BUS456_01.sales_line_tab);

-- Order Line (Composite PK = (SO_Number, Item_Number))
-- One query that will insert all rows from our partner group's table into the 
-- Order_line_tab table that do not have both an ITEM_NUMBER and SO_NUMBER
-- value, respectively, equal to that among any of the rows that are currently 
-- in our table. Two non-correlated subqueries are used in the WHERE clause to 
-- compare ITEM_NUMBER and SO_NUMBER, respectively, among rows in our 
-- partner group's table versus our table.
INSERT INTO BUS456_01.order_line_tab
SELECT *
FROM BUS456_09.orderline
WHERE PRODUCTNUMBER NOT IN (SELECT ITEM_NUMBER from BUS456_01.order_line_tab)
OR SO_NUMBER NOT IN (SELECT SO_NUMBER from BUS456_01.order_line_tab);

-------------------------------------------------------------------------------

-- STAGE 5: Write SQL queries to answer the following questions.

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
-- SOLUTION: Select the ItemName and QuantityOnHand in the Inventory_Tab
-- table where values for the attribute ItemName are strings that end in "Bicycle".
SELECT ItemName as "Bicycle Name", QuantityOnHand as "Quantity"
FROM Inventory_Tab
WHERE ItemName LIKE '%Bicycle'
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
