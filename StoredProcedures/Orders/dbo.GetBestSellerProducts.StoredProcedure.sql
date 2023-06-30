USE [POS]
GO
/****** Object: StoredProcedure [dbo].[GetBestSellerProduct] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetBestSellerProducts]
AS
BEGIN
    DECLARE @ProductIDs TABLE (ProductID INT);
    DECLARE @TotalQuantitySolds TABLE (ProductID INT, TotalQuantitySold INT);
    DECLARE @ProductNames TABLE (ProductID INT, ProductName NVARCHAR(50));
    DECLARE @ProductDescriptions TABLE (ProductID INT, ProductDescription NVARCHAR(100));

    INSERT INTO @ProductIDs (ProductID)
    SELECT TOP 5 WITH TIES
        JSON_VALUE(p.value, '$.ProductID') AS ProductID
    FROM Orders o
    CROSS APPLY OPENJSON(o.Products) p
    GROUP BY JSON_VALUE(p.value, '$.ProductID')
    ORDER BY SUM(CAST(JSON_VALUE(p.value, '$.ProductQuantity') AS INT)) DESC;

    INSERT INTO @TotalQuantitySolds (ProductID, TotalQuantitySold)
    SELECT p.ProductID, SUM(CAST(JSON_VALUE(oj.value, '$.ProductQuantity') AS INT)) AS TotalQuantitySold
    FROM Orders o
    CROSS APPLY OPENJSON(o.Products) oj
    INNER JOIN @ProductIDs p ON JSON_VALUE(oj.value, '$.ProductID') = p.ProductID
    GROUP BY p.ProductID;

    INSERT INTO @ProductNames (ProductID, ProductName)
    SELECT p.ProductID, p.ProductName
    FROM @ProductIDs i
    INNER JOIN Products p ON i.ProductID = p.ProductID;

    INSERT INTO @ProductDescriptions (ProductID, ProductDescription)
    SELECT p.ProductID, p.ProductDescription
    FROM @ProductIDs i
    INNER JOIN Products p ON i.ProductID = p.ProductID;

    SELECT pn.ProductName, pd.ProductDescription, tq.TotalQuantitySold
    FROM @ProductNames pn
    INNER JOIN @ProductDescriptions pd ON pn.ProductID = pd.ProductID
    INNER JOIN @TotalQuantitySolds tq ON pn.ProductID = tq.ProductID;
END
