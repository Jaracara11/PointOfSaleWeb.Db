USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[GetProductsSoldByDate]    Script Date: 1/25/2024 11:33:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetProductsSoldByDate]
    @InitialDate DateTime,
    @FinalDate DateTime
AS
BEGIN
    SET NOCOUNT ON;

	SET @InitialDate = DATEADD(DAY, DATEDIFF(DAY, 0, @InitialDate), 0)
    SET @FinalDate = DATEADD(MINUTE, -1, DATEADD(DAY, DATEDIFF(DAY, 0, @FinalDate) + 1, 0))

    DECLARE @OrderData TABLE (
        OrderID UNIQUEIDENTIFIER,
        ProductID NVARCHAR(50),
        ProductQuantity INT,
        OrderDate DATE,
        ProductName NVARCHAR(50),
        ProductDescription NVARCHAR(100),
        ProductUnitPrice DECIMAL(10, 2),
        ProductSubtotalPrice DECIMAL(10, 2),
        Discount DECIMAL(10, 2),
        Total DECIMAL(10, 2)
    );

    INSERT INTO @OrderData (OrderID, ProductID, ProductQuantity, OrderDate, ProductName, ProductDescription, ProductUnitPrice, ProductSubtotalPrice, Discount, Total)
    SELECT
        OrderID,
        JSON_VALUE(product.value, '$.ProductID') AS ProductID,
        JSON_VALUE(product.value, '$.ProductQuantity') AS ProductQuantity,
        OrderDate,
        p.ProductName,
        p.ProductDescription,
        p.ProductPrice AS ProductUnitPrice,
        ProductSubtotalPrice = (SELECT p.ProductPrice * JSON_VALUE(product.value, '$.ProductQuantity')),
        Discount = (SELECT Discount * p.ProductPrice * JSON_VALUE(product.value, '$.ProductQuantity')),
        Total = (SELECT (p.ProductPrice * JSON_VALUE(product.value, '$.ProductQuantity')) - ISNULL((Discount * p.ProductPrice * JSON_VALUE(product.value, '$.ProductQuantity')), 0))
    FROM orders
    CROSS APPLY OPENJSON(products) AS product
    JOIN Products p ON JSON_VALUE(product.value, '$.ProductID') = p.ProductID;

    SELECT
        ProductID,
        ProductName,
        ProductDescription,
        SUM(ProductQuantity) AS TotalUnitsSold,
        SUM(Total) AS TotalSold
    FROM @OrderData
    WHERE OrderDate BETWEEN @InitialDate AND @FinalDate
    GROUP BY ProductID, ProductName, ProductDescription
    ORDER BY ProductName;
END;