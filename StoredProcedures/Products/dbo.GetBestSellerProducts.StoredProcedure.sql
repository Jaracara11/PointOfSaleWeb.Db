USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[GetBestSellerProducts]    Script Date: 10/8/2023 11:51:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetBestSellerProducts]
AS
BEGIN
    SELECT TOP 5
    p.ProductName,
    p.ProductDescription,
    SUM(CAST(j.ProductQuantity AS INT)) AS TotalQuantitySold
FROM Orders o
CROSS APPLY OPENJSON(o.Products) WITH (
    ProductID NVARCHAR(50) '$.ProductID',
    ProductQuantity INT '$.ProductQuantity'
) AS j
INNER JOIN Products p ON j.ProductID = p.ProductID
GROUP BY p.ProductName, p.ProductDescription
ORDER BY TotalQuantitySold DESC;
END