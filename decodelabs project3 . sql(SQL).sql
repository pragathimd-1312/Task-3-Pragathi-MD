-- DecodeLabs Data Analytics Project 3 - SQL Data Analysis
-- Database: MySQL 8.x
-- Dataset: 1,200 e-commerce orders, 14 columns

CREATE DATABASE IF NOT EXISTS decodelabs_project3;
USE decodelabs_project3;

DROP TABLE IF EXISTS ecommerce_orders;
CREATE TABLE ecommerce_orders (
  OrderID VARCHAR(20) PRIMARY KEY,
  Date DATETIME NOT NULL,
  CustomerID VARCHAR(20) NOT NULL,
  Product VARCHAR(50) NOT NULL,
  Quantity INT NOT NULL,
  UnitPrice DECIMAL(10,2) NOT NULL,
  ShippingAddress VARCHAR(100) NOT NULL,
  PaymentMethod VARCHAR(30) NOT NULL,
  OrderStatus VARCHAR(20) NOT NULL,
  TrackingNumber VARCHAR(30) NOT NULL,
  ItemsInCart INT NOT NULL,
  CouponCode VARCHAR(30) NULL,
  ReferralSource VARCHAR(30) NOT NULL,
  TotalPrice DECIMAL(12,2) NOT NULL
);

-- Load the 1,200 source records. NULL is used for missing CouponCode values.
Select * from ecommerce_orders;

-- ============================================================
-- PROJECT QUERIES
-- ============================================================


-- ============================================================
-- PROJECT 3: CORE SQL ANALYSIS (LinkedIn-style scope)
-- Covers: SELECT, WHERE, ORDER BY, GROUP BY, COUNT, SUM, AVG
-- Focus: sales/orders, product performance, aggregation/filtering,
--        basic data-quality preparation and business insights.
-- ============================================================

-- 1. SELECT: View the main order and sales fields
SELECT OrderID, Date, Product, Quantity, UnitPrice, OrderStatus, TotalPrice
FROM ecommerce_orders
LIMIT 20;

-- 2. WHERE: Filter delivered orders
SELECT OrderID, Product, Quantity, TotalPrice, OrderStatus
FROM ecommerce_orders
WHERE OrderStatus = 'Delivered';

-- 3. WHERE + ORDER BY: Find high-value orders
SELECT OrderID, Product, Quantity, UnitPrice, TotalPrice
FROM ecommerce_orders
WHERE TotalPrice >= 2000
ORDER BY TotalPrice DESC;

-- 4. ORDER BY: Top 10 orders by sales value
SELECT OrderID, Product, TotalPrice
FROM ecommerce_orders
ORDER BY TotalPrice DESC
LIMIT 10;

-- 5. GROUP BY + COUNT + SUM + AVG: Product performance
SELECT Product,
       COUNT(*) AS OrderCount,
       SUM(Quantity) AS UnitsSold,
       SUM(TotalPrice) AS TotalSales,
       AVG(TotalPrice) AS AverageOrderValue
FROM ecommerce_orders
GROUP BY Product
ORDER BY TotalSales DESC;

-- 6. GROUP BY + COUNT + SUM + AVG: Order-status analysis
SELECT OrderStatus,
       COUNT(*) AS OrderCount,
       SUM(TotalPrice) AS TotalSales,
       AVG(TotalPrice) AS AverageOrderValue
FROM ecommerce_orders
GROUP BY OrderStatus
ORDER BY OrderCount DESC;

-- 7. GROUP BY + COUNT + SUM + AVG: Payment-method analysis
SELECT PaymentMethod,
       COUNT(*) AS OrderCount,
       SUM(TotalPrice) AS TotalSales,
       AVG(TotalPrice) AS AverageOrderValue
FROM ecommerce_orders
GROUP BY PaymentMethod
ORDER BY TotalSales DESC;

-- 8. Basic data-quality / preparation check
SELECT COUNT(*) AS TotalRows,
       COUNT(DISTINCT OrderID) AS UniqueOrderIDs,
       SUM(CASE WHEN CouponCode IS NULL THEN 1 ELSE 0 END) AS MissingCouponCodes
FROM ecommerce_orders;

-- 9. HAVING: Keep products whose total sales exceed 150,000
SELECT Product,
       COUNT(*) AS OrderCount,
       SUM(TotalPrice) AS TotalSales
FROM ecommerce_orders
GROUP BY Product
HAVING SUM(TotalPrice) > 150000
ORDER BY TotalSales DESC;

