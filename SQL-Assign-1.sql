--1. Inner Joins: Employee and Department
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);


INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance');

INSERT INTO Employees (EmployeeID, Name, DepartmentID)
VALUES
(101, 'Alice', 1),
(102, 'Bob', 2),
(103, 'Charlie', 2),
(104, 'David', 3),
(105, 'Eva', 1);

SELECT E.Name AS EmployeeName,D.DepartmentName
FROM Employees E
INNER JOIN Departments D ON E.DepartmentID = D.DepartmentID;


SELECT E.Name AS EmployeeName,D.DepartmentName
FROM Employees E
INNER JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName IN ('IT', 'HR');


--###############################################################################################################
--2. Left Joins: Product Inventory
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    CategoryID INT
);

INSERT INTO Categories (CategoryID, CategoryName)
VALUES 
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Books');

INSERT INTO Products (ProductID, ProductName, CategoryID)
VALUES
(201, 'Laptop', 1),
(202, 'T-Shirt', 2),
(203, 'Novel', 3),
(204, 'Headphones', 1),
(205, 'Water Bottle', NULL); 

SELECT P.ProductName,C.CategoryName
FROM Products P
LEFT JOIN Categories C ON P.CategoryID = C.CategoryID;

SELECT P.ProductName,C.CategoryName
FROM Products P
LEFT JOIN Categories C ON P.CategoryID = C.CategoryID
ORDER BY C.CategoryName;


--#################################################################################################################
--3. Right Joins: Sales Data
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    CustomerID INT
);

INSERT INTO Customers (CustomerID, CustomerName)
VALUES 
(1, 'John'),
(2, 'Alice'),
(3, 'Bob');

INSERT INTO Orders (OrderID, OrderDate, CustomerID)
VALUES
(301, '2025-04-01', 1),
(302, '2025-04-02', 2),
(303, '2025-04-03', NULL),  
(304, '2025-04-04', 4);     

SELECT O.OrderDate,C.CustomerName
FROM Customers C
RIGHT JOIN Orders O ON C.CustomerID = O.CustomerID;

SELECT O.OrderID,O.OrderDate,C.CustomerName
FROM Customers C
RIGHT JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE C.CustomerName IS NULL;


--#################################################################################################################
--4. Aggregate Functions: Sales Analysis
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleAmount DECIMAL(10, 2),
    SaleDate DATE
);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleAmount, SaleDate)
VALUES
(401, 1, 2, 200.00, '2025-04-01'),
(402, 1, 1, 100.00, '2025-04-02'),
(403, 2, 3, 450.00, '2025-04-03'),
(404, 3, 1, 300.00, '2025-04-04'),
(405, 2, 2, 250.00, '2025-04-05');

SELECT SUM(SaleAmount) AS TotalSales FROM Sales;

SELECT AVG(SaleAmount) AS AverageSales FROM Sales;

SELECT COUNT(SaleID) AS NumberOfSales FROM Sales;

SELECT MAX(SaleAmount) AS MaxSale,MIN(SaleAmount) AS MinSale
FROM Sales;

SELECT ProductID,SUM(SaleAmount) AS TotalSales,AVG(SaleAmount) AS AverageSales,COUNT(SaleID) AS NumberOfSales,
MAX(SaleAmount) AS MaxSale,MIN(SaleAmount) AS MinSale
FROM Sales
GROUP BY ProductID;


--#################################################################################################################
--5. HAVING and GROUP BY Clauses: Employee Performance
CREATE TABLE Performance (
    EmployeeID INT,
    Month VARCHAR(20),
    SalesAmount DECIMAL(10, 2)
);


INSERT INTO Performance (EmployeeID, Month, SalesAmount)
VALUES
(101, 'January', 2000.00),
(101, 'February', 2500.00),
(101, 'March', 1000.00),
(102, 'January', 3000.00),
(102, 'February', 3200.00),
(103, 'January', 1500.00),
(103, 'February', 1400.00),
(103, 'March', 1300.00);

SELECT EmployeeID,SUM(SalesAmount) AS TotalSales
FROM Performance
GROUP BY EmployeeID;


SELECT EmployeeID,SUM(SalesAmount) AS TotalSales
FROM Performance
GROUP BY EmployeeID
HAVING SUM(SalesAmount) > 5000;


SELECT EmployeeID,SUM(SalesAmount) AS TotalSales,AVG(SalesAmount) AS AverageMonthlySales
FROM Performance
GROUP BY EmployeeID
HAVING SUM(SalesAmount) > 5000;




