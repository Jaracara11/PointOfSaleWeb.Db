USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[GetBestSellerProduct]    Script Date: 6/30/2023 11:35:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetBestSellerProduct]
AS
BEGIN
    DECLARE @ProductID INT;
    DECLARE @TotalQuantitySold INT;
    DECLARE @ProductName NVARCHAR(50);
    DECLARE @ProductDescription NVARCHAR(100);

    WITH TopProduct AS (
        SELECT TOP 1 WITH TIES
            JSON_VALUE(value, '$.ProductID') AS ProductID,
            SUM(CAST(JSON_VALUE(value, '$.ProductQuantity') AS INT)) AS TotalQuantitySold
        FROM Orders
        CROSS APPLY OPENJSON(Products)
        GROUP BY JSON_VALUE(value, '$.ProductID')
        ORDER BY TotalQuantitySold DESC
    )
    SELECT @ProductID = ProductID, @TotalQuantitySold = TotalQuantitySold
    FROM TopProduct;

    SELECT @ProductName = ProductName, @ProductDescription = ProductDescription
    FROM Products
    WHERE ProductID = @ProductID;

    SELECT @ProductName AS ProductName, @ProductDescription AS ProductDescription, @TotalQuantitySold AS TotalQuantitySold;

	 SELECT @ProductName AS ProductName,
           @ProductDescription AS ProductDescription,
           ISNULL(@TotalQuantitySold, 0) AS TotalQuantitySold;
END








