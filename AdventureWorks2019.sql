Use AdventureWorks2019

--Retrieve the names and email addresses of all employees, including their job titles.
SELECT  
    concat(p.FirstName, p.LastName) As Names, 
    e.JobTitle, 
    ea.EmailAddress
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
LEFT JOIN Person.EmailAddress ea ON p.BusinessEntityID = ea.BusinessEntityID;

--Find the total number of products in the database
SELECT COUNT(*) AS TotalProducts 
FROM Production.Product;

--List the total sales amount for each customer
SELECT 
    c.CustomerID, 
    concat(p.FirstName, p.LastName) As Names,  
    SUM(sod.LineTotal) AS TotalSales
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY c.CustomerID, p.FirstName, p.LastName;

--Calculate the average list price of all products
SELECT AVG(ListPrice) AS AverageListPrice 
FROM Production.Product;

--Calculate the average, minimum, and maximum list price for each product category
SELECT 
    pc.Name AS Category, 
    AVG(p.ListPrice) AS AvgPrice, 
    MIN(p.ListPrice) AS MinPrice, 
    MAX(p.ListPrice) AS MaxPrice
FROM Production.Product p
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name;

--Find the departments with more than 10 employees
SELECT d.Name AS Department, COUNT(e.BusinessEntityID) AS EmployeeCount
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
GROUP BY d.Name
HAVING COUNT(e.BusinessEntityID) > 10;

--List the products that have never been sold
SELECT p.ProductID, p.Name
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL;

--Find employees hired in the year 2019
SELECT 
    e.BusinessEntityID, 
    p.FirstName, 
    p.LastName, 
    e.HireDate
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
WHERE YEAR(e.HireDate) = 2019;

--List the first names and last names of customers in uppercase
SELECT 
    UPPER(p.FirstName) AS FirstName, 
    UPPER(p.LastName) AS LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID;

--Retrieve Sales Order ID, Product Name, Order Quantity, and Salesperson's Name
SELECT 
    soh.SalesOrderID, 
    p.Name AS ProductName, 
    sod.OrderQty, 
    pp.FirstName + ' ' + pp.LastName AS SalesPerson
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
Join person.person pp ON sp.BusinessEntityID = pp.BusinessEntityID;

--Find employees who have sold products that were never sold by any other employee
SELECT DISTINCT sp.BusinessEntityID, p.FirstName, p.LastName
FROM Sales.SalesPerson sp
JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
Join person.person p ON sp.BusinessEntityID = p.BusinessEntityID
WHERE sod.ProductID NOT IN (
    SELECT sod2.ProductID 
    FROM Sales.SalesOrderHeader soh2
    JOIN Sales.SalesOrderDetail sod2 ON soh2.SalesOrderID = sod2.SalesOrderID
    WHERE soh2.SalesPersonID <> sp.BusinessEntityID
);

--List the average salary of employees per department (include departments with no employees)
SELECT d.Name AS Department, 
       COALESCE(AVG(e.Rate), 0) AS AvgSalary
FROM HumanResources.Department d
LEFT JOIN HumanResources.EmployeeDepartmentHistory edh ON d.DepartmentID = edh.DepartmentID
LEFT JOIN HumanResources.EmployeePayHistory e ON edh.BusinessEntityID = e.BusinessEntityID
GROUP BY d.Name;
