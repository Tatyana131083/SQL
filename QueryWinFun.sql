USE [AdventureWorks2016CTP3];

SELECT ShipMethodID, YEAR(OrderDate), COUNT(*) AS COUNT
, SUM(COUNT(*)) OVER (PARTITION BY ShipMethodID) AS SUM
, AVG(COUNT(*)) OVER (PARTITION BY ShipMethodID) AS AVG
, MAX(COUNT(*)) OVER (PARTITION BY ShipMethodID) AS MAX
, SUM(COUNT(*)) OVER() AS GRAND
FROM Sales.SalesOrderHeader
GROUP BY ShipMethodID, YEAR(OrderDate)
ORDER BY  ShipMethodID, YEAR(OrderDate)

--нарастающий итог продаж по двум покупателям
SELECT CustomerID, SalesOrderID,
CONVERT(DATE, OrderDate) AS OrderDate,
[SubTotal],
--сумма нарастающим итогом
SUM(SubTotal) OVER (PARTITION BY CustomerID
	ORDER BY OrderDate, SalesOrderID
	ROWS BETWEEN UNBOUNDED PRECEDING
		AND CURRENT ROW) AS 'Running Total'
FROM Sales.SalesOrderHeader
WHERE CustomerID IN (11000, 11001); 
-------------------------------------------------
--rank specify ordering of rows within a prtition
--dense_rank ** include ties, not gaps
--ntitle  **return number of the group
--rank ** include ties, not gaps
--row_number **return row's number
--use OVER with ORDER BY
-------------------------------------------------
SELECT CustomerID, SalesOrderID, SubTotal,
RANK() OVER(ORDER BY SubTotal) AS RANK,
DENSE_RANK() OVER(ORDER BY SubTotal) AS DENSE_RANK,
NTILE(4) OVER(ORDER BY SubTotal) AS NTILE,
ROW_NUMBER() OVER(ORDER BY SubTotal) AS ROW_NUMBER
FROM Sales.SalesOrderHeader
WHERE CustomerID IN (11000, 11001, 11002, 11003)
ORDER BY SubTotal, CustomerID, SalesOrderID
--------------------------------------------
--OFFSET functions
--return a value from a row in a certain offset
--from the current row
--comparisons between rows without self-join
--LAG **returns value from a row  before current row
--LEAD **returns value from a row  after current row
--FIRST_VALUE **first value in the window frame
--LAST_VALUE
----------------------------------------------------
SELECT CustomerID, SalesOrderID, SubTotal,
LAG(SubTotal) OVER(PARTITION BY CustomerID
	ORDER BY OrderDate, SalesOrderID) AS PREVIOUS,
LEAD(SubTotal) OVER(PARTITION BY CustomerID
	ORDER BY OrderDate, SalesOrderID) AS NEXT
FROM Sales.SalesOrderHeader
WHERE CustomerID IN (11000, 11001, 11002, 11003, 11004)
ORDER BY CustomerID, SalesOrderID, SubTotal;

--orders ranked by value from each customer
SELECT CustomerID, SalesOrderID, SubTotal
,RANK() OVER (PARTITION BY CustomerID
			 ORDER BY SubTotal DESC) AS RANK
FROM Sales.SalesOrderHeader
ORDER BY CustomerID, SubTotal DESC, SalesOrderID;
------------------------------------------
------Windows Functions
--allow rows to return their separate identity
--OVER defines set of rows to work with
--filtering is done at the individual row (WHERE)
--one result perunderlying row
------GROUPED BY
--performed on group
--used to arrange rows in groups
--filtering is done at entire group(HAVING)
--one result per group