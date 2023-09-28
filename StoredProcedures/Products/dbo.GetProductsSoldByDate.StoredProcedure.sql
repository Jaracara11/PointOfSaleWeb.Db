DECLARE @InitialDate Datetime = '2023-09-28';
DECLARE @FinalDate Datetime = '2023-09-28';

DECLARE @ProductData TABLE (
    ProductID varchar(50),
    ProductQuantity INT,
    OrderDate DATE,
    ProductName VARCHAR(50),
    ProductPrice DECIMAL(10, 2),
    Discount DECIMAL(10, 2)
);

INSERT INTO @ProductData (ProductID, ProductQuantity, OrderDate, ProductName, ProductPrice, Discount)
SELECT
    JSON_VALUE(product.value, '$.ProductID') AS ProductID,
    JSON_VALUE(product.value, '$.ProductQuantity') AS ProductQuantity,
    OrderDate,
    p.ProductName,
    p.ProductPrice,
    Discount
FROM orders
CROSS APPLY OPENJSON(products) AS product
JOIN Products p ON JSON_VALUE(product.value, '$.ProductID') = p.ProductID;

SELECT 
    ProductID,
    ProductName,
	SUM(ProductQuantity) AS TotalQuantity,
    ProductPrice AS UnitPrice,   
    SUM(ProductPrice * ProductQuantity) AS TotalPrice,
    MAX(Discount) AS Discount
FROM @ProductData
WHERE OrderDate BETWEEN @InitialDate AND @FinalDate
GROUP BY ProductID, ProductName, ProductPrice;
