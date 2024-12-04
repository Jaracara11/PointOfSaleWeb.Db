USE db10814;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    CREATE PROCEDURE [dbo].[sp_GetProductById] 
    @ProductId NVARCHAR(50) 
    AS BEGIN
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
   WHERE ProductID = @ProductId
END