--#######################################################################################################
--1.Write a SQL query to locate those salespeople who do not live in the same city where their customers live and have received a 
--commission of more than 12% from the company. Return Customer Name, customer city, Salesman, salesman city, commission.
SELECT DISTINCT
    CONCAT(p1.FirstName, ' ', p1.LastName) AS CustomerFullName,
    cust_address.City AS CustomerCity,
    CONCAT(p.FirstName, ' ', p.LastName) AS SalespersonFullName,
    sp_address.City AS SalespersonCity,
    sp.CommissionPct * 1000 AS SalesCommission
FROM Sales.SalesOrderHeader AS soh
    INNER JOIN Sales.Customer AS c 
        ON soh.CustomerID = c.CustomerID
    INNER JOIN Sales.SalesPerson AS sp 
        ON soh.SalesPersonID = sp.BusinessEntityID
    INNER JOIN Person.Person AS p 
        ON sp.BusinessEntityID = p.BusinessEntityID
    INNER JOIN Person.Person AS p1 
        ON c.PersonID = p1.BusinessEntityID
    -- Customer Address
    INNER JOIN Person.BusinessEntityAddress AS cust_bea 
        ON c.StoreID = cust_bea.BusinessEntityID
    INNER JOIN Person.Address AS cust_address 
        ON cust_bea.AddressID = cust_address.AddressID
    -- Salesperson Address
    INNER JOIN Person.BusinessEntityAddress AS sp_bea 
        ON sp.BusinessEntityID = sp_bea.BusinessEntityID
    INNER JOIN Person.Address AS sp_address 
        ON sp_bea.AddressID = sp_address.AddressID
WHERE cust_address.City <> sp_address.City
  AND sp.CommissionPct > 0.012;



--#############################################################################################
--2.To list every salesperson, along with the customer's name, city, grade, order number, date, and amount, create a SQL query.
-- Requirement for choosing the salesmen's list:
-- Salespeople who work for one or more clients, or  Salespeople who haven't joined any clients yet.
-- Requirements for choosing a customer list:
-- placed one or more orders with their salesman, or  didn't place any orders.

SELECT DISTINCT
    sp.BusinessEntityID AS SalespersonID,
    CONCAT(pp.FirstName, ' ', pp.LastName) AS SalespersonFullName,
    c.CustomerID,
    ISNULL(CONCAT(ppc.FirstName, ' ', ppc.LastName), s.Name) AS CustomerFullName,
    a.City AS CustomerCity,
    soh.SalesOrderID AS OrderNumber,
    soh.OrderDate AS OrderDate,
    soh.TotalDue AS OrderAmount
FROM Sales.SalesPerson AS sp
    LEFT JOIN Person.Person AS pp 
        ON sp.BusinessEntityID = pp.BusinessEntityID
    LEFT JOIN Sales.SalesOrderHeader AS soh 
        ON sp.BusinessEntityID = soh.SalesPersonID
    LEFT JOIN Sales.Customer AS c 
        ON soh.CustomerID = c.CustomerID
    LEFT JOIN Person.Person AS ppc 
        ON c.PersonID = ppc.BusinessEntityID
    LEFT JOIN Sales.Store AS s 
        ON c.StoreID = s.BusinessEntityID
    LEFT JOIN Person.BusinessEntityAddress AS bea 
        ON (
            (c.PersonID IS NOT NULL AND bea.BusinessEntityID = c.PersonID) OR
            (c.StoreID IS NOT NULL AND bea.BusinessEntityID = c.StoreID)
        )
    LEFT JOIN Person.Address AS a 
        ON bea.AddressID = a.AddressID
ORDER BY 
    SalespersonFullName,
    CustomerFullName,
    soh.OrderDate;

--#########################################################################################
--3.Write a SQL query to calculate the difference between the maximum salary and the salary of all the employees who work in the department of ID 80.
-- Return job title, employee name and salary difference.

SELECT 
    e.JobTitle AS JobTitle,
    CONCAT(p.FirstName, ' ', p.LastName) AS EmployeeFullName,
    (
        (
            SELECT MAX(eph2.Rate)
            FROM HumanResources.EmployeePayHistory AS eph2
            JOIN HumanResources.EmployeeDepartmentHistory AS edh2 
                ON eph2.BusinessEntityID = edh2.BusinessEntityID
            WHERE edh2.DepartmentID = 1
        ) - eph.Rate
    ) AS SalaryDifference
FROM HumanResources.Employee AS e
    JOIN HumanResources.EmployeeDepartmentHistory AS edh 
        ON e.BusinessEntityID = edh.BusinessEntityID
    JOIN HumanResources.Department AS d 
        ON edh.DepartmentID = d.DepartmentID
    JOIN HumanResources.EmployeePayHistory AS eph 
        ON e.BusinessEntityID = eph.BusinessEntityID
    JOIN Person.Person AS p 
        ON e.BusinessEntityID = p.BusinessEntityID
WHERE d.DepartmentID = 1
ORDER BY EmployeeFullName;





--################################################################################
--4.Create a SQL query to compare employees' year-to-date sales. 
-- Return TerritoryName, SalesYTD, BusinessEntityID, and Sales from the prior year (PrevRepSales). 
-- The results are sorted by territorial name in ascending order.

SELECT 
    st.Name AS TerritoryName,
    sp.SalesYTD,
    sp.BusinessEntityID,
    sp.SalesLastYear AS PrevRepSales
FROM Sales.SalesPerson sp
JOIN Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID
ORDER BY st.Name ASC;




--5.################################################################################
--Write a SQL query to find those orders where the order amount exists between 500 and 2000. 
--Return ord_no, purch_amt, cust_name, city.
SELECT 
    soh.SalesOrderID AS ord_no,
    soh.TotalDue AS purch_amt,
    p.FirstName + ' ' + ISNULL(p.MiddleName + ' ', '') + p.LastName AS cust_name,
    a.City AS city, soh.TotalDue
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.BusinessEntityAddress bea ON c.CustomerID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
WHERE soh.TotalDue BETWEEN 500 AND 2000;



--###################################################################################
--6.To find out if any of the current customers have placed an order or not, create a 
-- report using the following SQL statement: customer name, city, order number, order date,
-- and order amount in ascending order based on the order date.
SELECT 
    p.FirstName + ' ' + ISNULL(p.MiddleName + ' ', '') + p.LastName AS CustomerName,
    a.City AS City,
    soh.SalesOrderID AS OrderNumber,
    soh.OrderDate,
    soh.TotalDue AS OrderAmount
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.BusinessEntityAddress bea ON c.CustomerID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
ORDER BY soh.OrderDate ASC;


--##################################################################################
--7.Create a SQL query that will return all employees with "Sales" at the start of their job titles. 
-- Return the columns for job title, last name, middle name, and first name.

SELECT 
    e.JobTitle,
    p.LastName,
    p.MiddleName,
    p.FirstName
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.JobTitle LIKE 'Sales%';
