-- ============================ --
-- Part A - Database and Tables --
-- ============================ --

/* A1. Create a database called Cus_Orders. */

 USE master;

 IF EXISTS (SELECT * FROM sysdatabases WHERE name = 'Cus_Orders')
 BEGIN
	RAISERROR('Dropping existing Cus_Orders database...', 0, 1)
	DROP DATABASE Cus_Orders
END
GO

PRINT('A1: Creating Cus_Orders database...');
GO

CREATE DATABASE Cus_Orders;
GO

USE Cus_Orders;
GO

/* A2. Create a user-defined data types, for all similar Primary Key
attribute columns. */

PRINT('A2: Creating charidtype data type...');
GO

CREATE TYPE charidtype FROM char(5) NOT NULL;
GO

PRINT('A2: Creating intidtype data type...');
GO

CREATE TYPE intidtype FROM int NOT NULL;
GO

/* A3. Create the tables customers, orders, order_details, products,
shippers, suppliers, and titles. */

PRINT('A3: Creating customers table...');
GO

CREATE TABLE customers
(
	customer_id		charidtype,
	name			varchar(50) NOT NULL,
	contact_name	varchar(30),
	title_id		char(3) NOT NULL,
	address			varchar(50),
	city			varchar(20),
	region			varchar(15),
	country_code	varchar(10),
	country			varchar(15),
	phone			varchar(20),
	fax				varchar(20)
);
GO

PRINT('A3: Creating orders table...');
GO

CREATE TABLE orders
(
	order_id				intidtype,
	customer_id				charidtype,
	employee_id				int NOT NULL,
	shiping_name			varchar(50),
	shipping_address		varchar(50),
	shipping_city			varchar(20),
	shipping_region			varchar(15),
	shipping_country_code	varchar(10),
	shipping_country		varchar(15),
	shipper_id				int NOT NULL,
	order_date				datetime,
	required_date			datetime,
	shipped_date			datetime,
	freight_charge			money
);
GO

PRINT('A3: Creating order_details table...');
GO

CREATE TABLE order_details
(
	order_id		intidtype,
	product_id		intidtype,
	quantity		int NOT NULL,
	discount		float NOT NULL
);
GO

PRINT('A3: Creating products table...');
GO

CREATE TABLE products
(
	product_id			intidtype,
	supplier_id			int NOT NULL,
	name				varchar(40) NOT NULL,
	alternate_name		varchar(40),
	quantity_per_unit	varchar(25),
	unit_price			money,
	quantity_in_stock	int,
	units_on_order		int,
	reorder_level		int
);
GO

PRINT('A3: Creating shippers table...');
GO

CREATE TABLE shippers
(
	shipper_id		int IDENTITY(1, 1) NOT NULL,
	name			varchar(20) NOT NULL
);

PRINT('A3: Creating suppliers table...');
GO

CREATE TABLE suppliers
(
	supplier_id		int IDENTITY(1, 1) NOT NULL,
	name			varchar(40) NOT NULL,
	address			varchar(30),
	city			varchar(20),
	province		char(2)
);
GO

PRINT('A3: Creating titles table...');
GO

CREATE TABLE titles
(
	title_id		char(3) NOT NULL,
	description		varchar(35) NOT NULL
);
GO

/* A4. Set the primary keys and foreign keys for the tables. */

PRINT('A4: Setting PK on customers...');
GO

ALTER TABLE customers
ADD PRIMARY KEY (customer_id);
GO

PRINT('A4: Setting PK on orders...');
GO

ALTER TABLE orders
ADD PRIMARY KEY (order_id);
GO

PRINT('A4: Setting composite PK on order_details...');
GO

ALTER TABLE order_details
ADD PRIMARY KEY (order_id, product_id);
GO

PRINT('A4: Setting PK on products...');
GO

ALTER TABLE products
ADD PRIMARY KEY (product_id);
GO

PRINT('A4: Setting PK on shippers...');
GO

ALTER TABLE shippers
ADD PRIMARY KEY (shipper_id);
GO

PRINT('A4: Setting PK on suppliers...');
GO

ALTER TABLE suppliers
ADD PRIMARY KEY (supplier_id);
GO

PRINT('A4: Setting PK on titles...');
GO

ALTER TABLE titles
ADD PRIMARY KEY (title_id);
GO

PRINT('A4: Setting FK fk_titles_customers on customers...');
GO

ALTER TABLE customers
ADD CONSTRAINT fk_titles_customers
FOREIGN KEY (title_id)
REFERENCES titles(title_id);
GO

PRINT('A4: Setting FK fk_customers_orders on orders...');
GO

ALTER TABLE orders
ADD CONSTRAINT fk_customers_orders
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);
GO

PRINT('A4: Setting FK fk_shippers_orders on orders...');
GO

ALTER TABLE orders
ADD CONSTRAINT fk_shippers_orders
FOREIGN KEY (shipper_id)
REFERENCES shippers(shipper_id);
GO

PRINT('A4: Setting FK fk_orders_orderdetails on order_details...');
GO

ALTER TABLE order_details
ADD CONSTRAINT fk_orders_orderdetails
FOREIGN KEY (order_id)
REFERENCES orders(order_id);
GO

PRINT('A4: Setting FK fk_products_orderdetails on order_details...');
GO

ALTER TABLE order_details
ADD CONSTRAINT fk_products_orderdetails
FOREIGN KEY (product_id)
REFERENCES products(product_id);
GO

PRINT('A4: Setting FK fk_suppliers_products on products...');
GO

ALTER TABLE products
ADD CONSTRAINT fk_suppliers_products
FOREIGN KEY (supplier_id)
REFERENCES suppliers(supplier_id);
GO

/* A5. Set the constraints. */

PRINT('A5: Setting contraint default_customers_country on customers..');
GO

ALTER TABLE customers
ADD CONSTRAINT default_customers_country
DEFAULT ('Canada') FOR country;
GO

PRINT('A5: Setting constraint default_orders_date on orders...');
GO

ALTER TABLE orders
ADD CONSTRAINT default_orders_date
DEFAULT DATEADD(DAY, 10, GETDATE()) FOR required_date;
GO

PRINT('A5: Setting constraint ck_orderdetails_qty on order_details...');
GO

ALTER TABLE order_details
ADD CONSTRAINT check_orderdetails_qty
CHECK (quantity >= 1);
GO

PRINT('A5: Setting constraint ck_products_reorderlvl on products..');
GO

ALTER TABLE products
ADD CONSTRAINT ck_products_reorderlvl
CHECK (reorder_level >= 1);
GO

PRINT('A5: Setting constraint ck_products_qtyinstock on products...');
GO

ALTER TABLE products
ADD CONSTRAINT ck_products_qtyinstock
CHECK (quantity_in_stock <= 150);
GO

PRINT('A5: Setting constraint default_suppliers_prov on suppliers..');
GO

ALTER TABLE suppliers
ADD CONSTRAINT default_suppliers_prov
DEFAULT ('BC') FOR province;
GO

/* A6. Load the data into your created tables. */

PRINT('A6: Inserting data into titles...');
GO

BULK INSERT titles 
FROM 'C:\TextFiles\titles.txt' 
WITH (
        CODEPAGE=1252,                  
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	 );

PRINT('A6: Inserting data into suppliers...');
GO

BULK INSERT suppliers 
FROM 'C:\TextFiles\suppliers.txt' 
WITH (  
        CODEPAGE=1252,               
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  );

PRINT('A6: Inserting data into shippers...');
GO

BULK INSERT shippers 
FROM 'C:\TextFiles\shippers.txt' 
WITH (
        CODEPAGE=1252,            
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  );

PRINT('A6: Inserting data into customers...');
GO

BULK INSERT customers 
FROM 'C:\TextFiles\customers.txt' 
WITH (
        CODEPAGE=1252,            
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  );

PRINT('A6: Inserting data into products...');
GO

BULK INSERT products 
FROM 'C:\TextFiles\products.txt' 
WITH (
        CODEPAGE=1252,             
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  );

PRINT('A6: Inserting data in order_details..');
GO

BULK INSERT order_details 
FROM 'C:\TextFiles\order_details.txt'  
WITH (
        CODEPAGE=1252,              
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  );

PRINT('A6: Inserting data in orders...');
GO

BULK INSERT orders 
FROM 'C:\TextFiles\orders.txt' 
WITH (
        CODEPAGE=1252,             
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  );

PRINT('END OF PART A');
GO

-- ======================= --
-- Part B - SQL Statements --
-- ======================= --

/* B1. List the customer id, name, city, and country from the customer table.
Order the result by the customer id. */
	
SELECT  customer_id AS 'Customer Id',
		name AS 'Name',
		city AS 'City',
		country AS 'Country'
FROM customers
ORDER BY customer_id;
GO

/* B2. Add a new column called active to the customers table using the ALTER statement.
The only valid values are 1 or 0. Default should be 1. */

PRINT('Inserting column active into customers..');
GO

ALTER TABLE customers
ADD active int NOT NULL
DEFAULT 1;
GO

PRINT('Setting constraint cK_active on customers..');
GO

ALTER TABLE customers
ADD CONSTRAINT ck_active
CHECK (active IN (0, 1));
GO

/* B3. List all the orders where the order date is between January 1 and December 31, 2001. */

SELECT  orders.order_id AS 'Order Id',
		products.name AS 'Product Name',
		customers.name AS 'Customer Name',
		CONVERT(char(11), orders.order_date, 100) AS 'Order Date',
		CONVERT(char(11), DATEADD(DAY, 7, orders.order_date), 100) AS 'New Shipped Date',
		(order_details.quantity * products.unit_price) AS 'Order Cost'
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
INNER JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.product_id
WHERE order_date BETWEEN 'Jan 1 2001' AND 'Dec 31 2001';
GO

/* B4. List all the orders that have not been shipped. */

SELECT  customers.customer_id AS 'Customer Id',
		customers.name AS 'Name',
		customers.phone AS 'Phone',
		orders.order_id AS 'Order Id',
		CONVERT(char(11), orders.order_date, 100) AS 'Order Date'
FROM customers
INNER JOIN orders ON customers.customer_id = orders.customer_id
WHERE orders.shipped_date IS NULL
ORDER BY customers.name;
GO

/* B5. List all the customers where the region is NULL. */

SELECT  customers.customer_id AS 'Customer Id',
		customers.name AS 'Name',
		customers.city AS 'City',
		titles.description AS 'Description'
FROM customers
INNER JOIN titles ON customers.title_id = titles.title_id;

/* 6. List the products where the reorder level is higher than the quantity in stock. */

SELECT  suppliers.name,
		products.name,
		products.reorder_level,
		products.quantity_in_stock
FROM products
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
WHERE products.reorder_level > products.quantity_in_stock
ORDER BY suppliers.name;

/* 7. Calculate the length in years from January 1, 2008 and when an order was shipped
where the shipped date is not null. */

SELECT  orders.order_id,
		customers.name,
		customers.contact_name,
		CONVERT(char(11), orders.shipped_date, 100) AS 'Shipped Date',
		DATEPART(year, 'Jan 1 2008') - DATEPART(year, orders.shipped_date) AS 'Elapsed'
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
WHERE orders.shipped_date IS NOT NULL
ORDER BY orders.order_id, 'Elapsed';

/* 8. List number of customers with names beginning with each letter of the alphabet.
Ignore customers whose name begins with the letter S. */

SELECT  SUBSTRING(name, 1, 1) AS 'Name',
		COUNT(SUBSTRING(name, 1, 1)) AS 'Total'
FROM customers
WHERE SUBSTRING(name, 1, 1) != 'S'
GROUP BY SUBSTRING(name, 1, 1)
HAVING COUNT(SUBSTRING(name, 1, 1)) > 1;

/* 9. List the order details where the quantity is greater than 100. */

SELECT  order_details.order_id,
		order_details.quantity,
		products.product_id,
		products.reorder_level,
		suppliers.supplier_id
FROM order_details
INNER JOIN products ON order_details.product_id = products.product_id
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
WHERE order_details.quantity > 100
ORDER BY order_details.order_id;

/* List the products which contain tofu or chef in their name. */

SELECT  product_id,
		name,
		quantity_per_unit,
		unit_price
FROM products
WHERE name LIKE '%tofu%' OR name LIKE '%chef%'
ORDER BY name;

-- ===================================================== --
-- Part C - Insert, Update, Delete, and Views Statements --
-- ===================================================== --

 /* 1. Create an employee table. */

 CREATE TABLE employee
 (
	employee_id		int NOT NULL,
	last_name		varchar(30) NOT NULL,
	first_name		varchar(15) NOT NULL,
	address			varchar(30) NOT NULL,
	city			varchar(20),
	province		char(2),
	postal_code		varchar(7),
	phone			varchar(10),
	birth_date		datetime NOT NULL
)

/* 2. The primary key for the employee table should be the employee id. */

ALTER TABLE employee
ADD PRIMARY KEY (employee_id);

/* 3. Load the data into the employee table. Create the relationship 
between employee and orders tables.*/

BULK INSERT employee 
FROM 'C:\TextFiles\employee.txt' 
WITH (         CODEPAGE=1252,            
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	 )

ALTER TABLE orders
ADD CONSTRAINT fk_orders_employee
FOREIGN KEY (employee_id)
REFERENCES employee(employee_id);
GO

/* 4. Add the shipper Quick Express to the shippers table. */

INSERT INTO shippers
VALUES ('Quick Express');
GO

/* 5. Increase the unit price in the products table of all rows with a 
current unity price between $5.00 and $10.00 by 5%. */

UPDATE products
SET unit_price *= 1.05
WHERE unit_price BETWEEN 5 AND 10
GO

/* 6. Change the fax value to Unknown for all rows in the customers table
where the current fax value is NULL. */

UPDATE customers
SET fax = 'Unknown'
WHERE fax IS NULL;
GO

/* 7. Create a view called vw_order_cost to list the cost of the orders. Run
the view for the order ids between 10000 and 10200. */

CREATE VIEW vw_order_cost
AS
SELECT	orders.order_id,
		orders.order_date,
		products.product_id,
		customers.name,
		(order_details.quantity * products.unit_price) AS 'Order Cost'
FROM customers
INNER JOIN orders ON customers.customer_id = orders.customer_id
INNER JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.product_id;
GO

SELECT *
FROM vw_order_cost
WHERE order_id BETWEEN 10000 AND 10200;
GO

/* 8. Create a view called vw_list_employees to list all the employees and
all the columns in the employee table. Run the view for employee ids 5, 7, 
and 9. */

CREATE VIEW vw_list_employees
AS
SELECT *
FROM employee;
GO

SELECT  employee_id,
		last_name + ', ' + first_name AS 'Name',
		CONVERT(char(10), birth_date, 102) AS 'Birth Date'
FROM vw_list_employees
WHERE employee_id IN (5, 7, 9);
GO

/* 9. Create a view called vw_all_orders to list all the orders. Run the view 
for orders shipped from January 1, 2002 and December 31, 2002. */

CREATE VIEW vw_all_orders
AS
SELECT  orders.order_id,
		customers.customer_id,
		customers.name,
		customers.city,
		customers.country,
		orders.shipped_date
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id;
GO

SELECT  order_id,
		customer_id,
		name,
		city,
		country,
		CONVERT(char(11), shipped_date, 100) AS 'Shipped Date'
FROM vw_all_orders
WHERE shipped_date BETWEEN 'Jan 1 2002' AND 'Dec 31 2002'
ORDER BY name, country;
GO

/* 10. Create a view listing the suppliers and the items they have shipped.
Run the view. */

CREATE VIEW vw_all_suppliers
AS
SELECT  suppliers.supplier_id,
		suppliers.name AS 'Supplier',
		products.product_id,
		products.name AS 'Product'
FROM suppliers
INNER JOIN products ON suppliers.supplier_id = products.supplier_id;
GO

SELECT *
FROM vw_all_suppliers;
GO

-- ======================================= --
-- Part D - Stored Procedures and Triggers --
-- ======================================= --

/* 1. Create a stored procedure called sp_customer_city displaying the customers
living in a particular city. Run the procedure displaying customers living in
London. */

CREATE PROCEDURE sp_customer_city
(
	@city	varchar(20)
)
AS
SELECT  customer_id,
		name,
		address,
		city,
		phone
FROM customers
WHERE city = @city;
GO

EXECUTE sp_customer_city 'London';
GO

/* 2. Create a stored procedure called sp_orders_by_date displaying the orders shipped 
between particular dates. Run the procedure displaying orders from January 1, 2003
to June 30, 2003. */

CREATE PROCEDURE sp_orders_by_date
(
	@date1  datetime,
	@date2	datetime
)
AS
SELECT  orders.order_id,
		orders.customer_id,
		customers.name,
		shippers.name,
		orders.shipped_date
FROM customers
INNER JOIN orders ON customers.customer_id = orders.customer_id
INNER JOIN shippers ON orders.shipper_id = shippers.shipper_id
WHERE orders.shipped_date BETWEEN @date1 AND @date2;
GO

EXECUTE sp_orders_by_date 'Jan 1 2003', 'Jun 30 2003';
GO

/* 3. Create a stored procedure called sp_product_listing listing a specified
product ordered during a specified month and year. Run the procedure displaying
a product name containing Jack and the month of the order date is June and the
year is 2001. */

CREATE PROCEDURE sp_product_listing
(
	@product	varchar(40),
	@month		varchar(10),
	@year		int
)
AS
SELECT  products.name,
		products.unit_price,
		products.quantity_in_stock,
		suppliers.name
FROM products
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
INNER JOIN order_details ON products.product_id = order_details.product_id
INNER JOIN orders ON order_details.order_id = orders.order_id
WHERE products.name LIKE @product
AND DATENAME(month, orders.order_date) = @month
AND DATEPART(year, orders.order_date) = @year;
GO

EXECUTE sp_product_listing '%Jack%', 'June', 2001;
GO

/* 4. Create a delete trigger called tr_delete_orders on the orders table to 
display an error message if an order is deleted that has a value in the
order_details table. */

CREATE TRIGGER tr_delete_orders
ON orders
INSTEAD OF DELETE
AS
DECLARE @id int;
SELECT @id = order_id FROM deleted
IF (SELECT COUNT(*) FROM order_details WHERE order_id = @id) > 0
	BEGIN
		PRINT 'No deleting orders with references to order_details table.'
		ROLLBACK TRANSACTION
	END;
GO

DELETE orders
WHERE order_id = 10000;
GO

/* 5. Create an insert and update trigger called tr_check_qty on the order_details
table to only allow orders of products that have a quantity in stock greater than or
equal to the units ordered. */

CREATE TRIGGER tr_check_qty
ON order_details
FOR INSERT, UPDATE
AS

DECLARE @id int,
		@qtyinstock int,
		@orderqty int

SELECT  @id = product_id,
		@orderqty = quantity
FROM deleted

SELECT @qtyinstock = quantity_in_stock
FROM products
WHERE product_id = @id

IF (@orderqty > @qtyinstock)
	BEGIN
		PRINT 'Order quantity cannot exceed quantity in stock.'
		ROLLBACK TRANSACTION
	END
GO

UPDATE order_details
SET quantity = 30
WHERE order_id = '10044'
AND product_id = 7;
GO

/* 6. Create a stored procedure called sp_del_inactive_cust to delete customers
that have no orders. */

CREATE PROCEDURE sp_del_inactive_cust
AS
DELETE FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM orders);
GO

EXECUTE sp_del_inactive_cust;
GO

/* 7. Create a stored procedure called sp_employee_information to display the
employee information for a particular employee. */

CREATE PROCEDURE sp_employee_information
(
	@employeeid int
)
AS
SELECT *
FROM employee
WHERE employee_id = @employeeid;
GO

EXECUTE sp_employee_information 5;
GO

/* 8. Create a stored procedure called sp_reorder_qty to show when the reorder
level substracted from the quantity in stock is less than a specified value. */

CREATE PROCEDURE sp_reorder_qty
(
	@unit int
)
AS
SELECT  products.product_id,
		suppliers.name,
		suppliers.address,
		suppliers.city,
		suppliers.province,
		products.quantity_in_stock,
		products.reorder_level
FROM products
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
WHERE (products.quantity_in_stock - products.reorder_level) < @unit;
GO

EXECUTE sp_reorder_qty 5;
GO

/* 9. Create a stored procedure called sp_unit_prices for the product table
where the unit price is between particular values. */

CREATE PROCEDURE sp_unit_prices
(
	@price1 money,
	@price2 money
)
AS
SELECT  product_id,
		name,
		alternate_name,
		unit_price
FROM products
WHERE unit_price BETWEEN @price1 AND @price2;
GO

EXECUTE sp_unit_prices $5.00, $10.00;