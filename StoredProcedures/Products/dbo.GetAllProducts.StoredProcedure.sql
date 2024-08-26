USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[GetAllProducts]    Script Date: 8/26/2024 8:24:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetAllProducts]
AS
BEGIN
   SELECT
       p.ProductID,
       p.ProductName,
       p.ProductDescription,
       p.ProductStock,
       p.ProductCost,
       p.ProductPrice,
       c.CategoryID,
       c.CategoryName
   FROM
       Products p WITH (NOLOCK)
   INNER JOIN
       Categories c WITH (NOLOCK) ON p.ProductCategoryID = c.CategoryID
   ORDER BY
       p.ProductName ASC;
END