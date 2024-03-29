CREATE DATABASE IF NOT EXISTS ORG;
USE ORG;

CREATE TABLE IF NOT EXISTS Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(255),
    Email VARCHAR(255),
    JoinDate DATE
);
SELECT*FROM Customers
INSERT INTO Customers (CustomerID, Name, Email, JoinDate) VALUES
(1, 'John Doe', 'johndoe@example.com', '2020-01-10'),
(2, 'Jane Smith', 'janesmith@example.com', '2020-01-15'),
(3, 'Paul Walker',  'paulwalker@example.com', '2020-01-25'),
(4, 'Dominic Torretto', 'dominictorretto@example.com','2020-02-05'),
(5, 'Chris Louis', 'chrislouis@example.com','2020-02-10'),
(6, 'Kristen Hanby','kristenhanby@example.com','2020-02-15'),
(7, 'Vin Disel','vindisel@example.com','2020-02-20'),
(8, 'Arthur Smith','arthursmith@example.com','2020-02-25'),
(9, 'Alex Jhonson','alexjhonson@example.com','2020-02-27'),
(10, 'Alice Johnson', 'alicejohnson@example.com', '2020-03-05');

select*from Customers

CREATE TABLE IF NOT EXISTS Products (
    ProductID INT PRIMARY KEY,
    Name VARCHAR(255),
    Category VARCHAR(255),
    Price DECIMAL(10, 2)
);
select*from Products
INSERT INTO Products (ProductID, Name, Category, Price) VALUES
(1, 'Laptop', 'Electronics', 999.99),
(2, 'Smartphone', 'Electronics', 499.99),
(3, 'Tablet','Electronics',699.99),
(4, 'Desktop Computer','Electronics',1000.00),
(5, 'Television','Electronics',1111.99),
(6, 'Digital Cameras','Electronics',399.99),
(7, 'Game Console','Electronics',1499.99),
(8, 'Vaccunm','Electronics',799.99),
(9, 'Washing Machine','Electronics',1699.99),
(10, 'Desk Lamp', 'Home Decor', 29.99);
select*from Products

CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
select*from orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)VALUES
(1, 1, '2020-02-15', 1499.98),
(2, 2, '2020-02-17', 499.99),
(3, 3, '2020-02-19', 1199.99),
(4, 4, '2020-02-22', 1399.99),
(5, 5, '2020-02-25', 399.99),
(6, 6, '2020-03-05', 699.99),
(7, 7, '2020-03-10', 899.99),
(8, 8, '2020-03-15', 999.99),
(9, 9, '2020-03-25', 99.99),
(10, 10, '2020-03-21', 78.99);
select*from orders

CREATE TABLE IF NOT EXISTS OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PricePerUnit DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
select*from OrderDetails 
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity,PricePerUnit) VALUES
(1, 1, 1, 1, 999.99),
(2, 2, 2, 1, 499.99),
(3, 3, 3, 1, 599.99),
(4, 4, 4, 2, 1299.99),
(5, 5, 5, 3, 299.99),
(6, 6, 6, 1, 39.99),
(7, 7, 7, 1, 49.99),
(8, 8, 8, 4, 799.99),
(9, 9, 9, 5, 1499.99),
(10, 10, 10, 2, 29.99);
select*from OrderDetails

1. Basic Queries:

1.1. List all customers.
ANS
	SELECT * FROM Customers;

1.2. Show all products in the 'Electronics' category.
ANS 
	SELECT * FROM Products WHERE Category = 'Electronics';
    
1.3. Find the total number of orders placed.
ANS
	SELECT COUNT(*) AS TotalOrders FROM Orders;

1.4. Display the details of the most recent order.
ANS
	SELECT * FROM Orders ORDER BY OrderDate DESC LIMIT 1;

2. Joins and Relationships:

2.1. List all products along with the names of the customers who ordered them.
ANS
	SELECT P.*, C.Name AS CustomerName
FROM Products P
JOIN OrderDetails OD ON P.ProductID = OD.ProductID
JOIN Orders O ON OD.OrderID = O.OrderID
JOIN Customers C ON O.CustomerID = C.CustomerID;

2.2. Show orders that include more than one product.
ANS 
	SELECT O.*FROM Orders O
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderID
HAVING COUNT(OD.ProductID) > 1;

2.3. Find the total sales amount for each customer.
ANS
	SELECT C.CustomerID, C.Name AS CustomerName, SUM(O.TotalAmount) AS TotalSales
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.Name;

3. Aggregation and Grouping:

3.1. Calculate the total revenue generated by each product category.
ANS
	SELECT Category, SUM(Price) AS TotalRevenue
FROM Products
GROUP BY Category;

3.2. Determine the average order value.
ANS
	SELECT AVG(TotalAmount) AS AverageOrderValue
FROM Orders;

3.3. Find the month with the highest number of orders.
ANS
	SELECT MONTH(OrderDate) AS OrderMonth, COUNT(*) AS OrderCount
FROM Orders
GROUP BY OrderMonth
ORDER BY OrderCount DESC
LIMIT 1;

4. Subqueries and Nested Queries:

4.1. Identify customers who have not placed any orders.
ANS
	SELECT *FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders);

4.2. Find products that have never been ordered.
ANS 
	SELECT *FROM Products
WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM OrderDetails);

4.3. Show the top 3 best-selling products.
ANS
SELECT P.*, SUM(OD.Quantity) AS TotalSold
FROM Products P
JOIN OrderDetails OD ON P.ProductID = OD.ProductID
GROUP BY P.ProductID
ORDER BY TotalSold DESC
LIMIT 3;

5. Date and Time Functions:

5.1. List orders placed in the last month.
ANS
	SELECT*FROM Orders
WHERE OrderDate >= CURDATE() - INTERVAL 1 MONTH;

5.2. Determine the oldest customer in terms of membership duration.
ANS
	SELECT *FROM Customers
ORDER BY JoinDate
LIMIT 1;

6. Advanced Queries:

6.1. Rank customers based on their total spending.
ANS
	SELECT C.CustomerID, C.Name AS CustomerName, SUM(O.TotalAmount) AS TotalSpending,
RANK() OVER (ORDER BY SUM(O.TotalAmount) DESC) AS SpendingRank
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.Name
ORDER BY TotalSpending DESC;

6.2. Identify the most popular product category.
ANS
	SELECT Category, COUNT(*) AS ProductCount
FROM Products
GROUP BY Category
ORDER BY ProductCount DESC
LIMIT 1;

6.3. Calculate the month-over-month growth rate in sales.
ANS
	SELECT MONTH(OrderDate) AS OrderMonth,
SUM(TotalAmount) AS MonthlySales,
(SUM(TotalAmount) - LAG(SUM(TotalAmount), 1, 0) OVER (ORDER BY MONTH(OrderDate))) / LAG(SUM(TotalAmount), 1, 1) OVER (ORDER BY MONTH(OrderDate)) * 100 AS GrowthRate
FROM Orders
GROUP BY OrderMonth;

7. Data Manipulation and Updates:

7.1. Add a new customer to the Customers table.
ANS
	INSERT INTO Customers (CustomerID, Name, Email, JoinDate) VALUES
 (11, 'Swayam Pacharne', 'swayampacharne@example.com', '2024-01-12');
select*from Customers

7.2. Update the price of a specific product.
ANS
	UPDATE Products
SET Price = 599.99
WHERE ProductID = 3;
select*from Products














