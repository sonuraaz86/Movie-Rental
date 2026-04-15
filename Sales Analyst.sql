
#Customer Behavior and Segmentation
SELECT * FROM capstone.categories;
WITH CustomerStats AS (
    SELECT 
        CustomerID, 
        COUNT(OrderID) AS OrderCount, 
        SUM(UnitPrice * Quantity * (1 - Discount)) AS TotalSpent
    FROM Orders o
    JOIN Order_Details od ON o.OrderID = od.OrderID
    GROUP BY CustomerID
)
SELECT 
    AVG(OrderCount) AS AvgOrdersPerCustomer,
    (SELECT COUNT(*) FROM CustomerStats WHERE TotalSpent > 5000 AND OrderCount > 5) AS HighValueRepeatCount
FROM CustomerStats;

#Customer Clustering (Spend, Count, Category)
SELECT * FROM capstone.categories;
SELECT 
    CustomerID,
    SUM(UnitPrice * Quantity) AS TotalSpend,
    COUNT(DISTINCT OrderID) AS OrderCount,
    CASE 
        WHEN SUM(UnitPrice * Quantity) > 10000 THEN 'Platinum'
        WHEN SUM(UnitPrice * Quantity) BETWEEN 5000 AND 10000 THEN 'Gold'
        ELSE 'Silver'
    END AS CustomerSegment
FROM Order_Details od
JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY CustomerID;

#Product and Revenue Analysis
#Revenue Contribution by Category
SELECT * FROM capstone.categories;
SELECT 
    c.CategoryName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalRevenue,
    COUNT(od.OrderID) AS TotalUnitsSold
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
JOIN Order_Details od ON p.ProductID = od.ProductID
GROUP BY c.CategoryName
ORDER BY TotalRevenue DESC;

#Pricing, Stock, and Sales Correlation
SELECT * FROM capstone.categories;
SELECT 
    p.ProductName,
    p.UnitPrice,
    p.UnitsInStock,
    SUM(od.Quantity) AS UnitsSold,
    (p.UnitPrice * SUM(od.Quantity)) AS RevenuePerformance
FROM Products p
LEFT JOIN Order_Details od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock
ORDER BY UnitsSold DESC;

# Employee and Workforce Distribution
#Geographic and Title-wise Distribution

SELECT * FROM capstone.categories;
SELECT 
    Country, 
    City, 
    Title, 
    COUNT(EmployeeID) AS EmployeeCount
FROM Employees
GROUP BY Country, City, Title
ORDER BY Country, EmployeeCount DESC;

#Hiring Trends over Time
SELECT * FROM capstone.categories;
SELECT 
    strftime('%Y', HireDate) AS HireYear, 
    Title, 
    COUNT(*) AS HiresCount
FROM Employees
GROUP BY HireYear, Title
ORDER BY HireYear DESC;

#Supplier and Supply Chain Logistics
#Regional Supplier Trends & Categories

SELECT * FROM capstone.categories;
SELECT 
    s.Country,
    c.CategoryName,
    COUNT(p.ProductID) AS ProductCount,
    AVG(p.UnitPrice) AS AvgProductPrice
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY s.Country, c.CategoryName
ORDER BY s.Country;
# Seasonality and Anomalies
# Monthly Demand Trends

SELECT * FROM capstone.categories;
SELECT 
    strftime('%Y-%m', OrderDate) AS Month,
    COUNT(OrderID) AS TotalOrders,
    ROUND(SUM(UnitPrice * Quantity), 2) AS MonthlyRevenue
FROM Orders o
JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY Month
ORDER BY Month;

#Identifying Sales Anomalies
SELECT * FROM capstone.categories;
WITH MonthlySales AS (
    SELECT strftime('%Y-%m', OrderDate) AS Month, SUM(UnitPrice * Quantity) AS Rev
    FROM Orders o JOIN Order_Details od ON o.OrderID = od.OrderID
    GROUP BY Month
)
SELECT Month, Rev 
FROM MonthlySales 
WHERE Rev > (SELECT AVG(Rev) * 2 FROM MonthlySales);
