USE db10814;
GO
CREATE PROCEDURE sp_GetAllProducts
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        p.ProductID,
        p.ProductName,
        p.ProductDescription,
        p.ProductPrice,
        p.ProductCost,
        p.ProductStock,
        p.ProductCategoryID,
        c.CategoryID AS CategoryID,
        c.CategoryName
    FROM 
        dbo.Products p
    INNER JOIN 
        dbo.Categories c ON p.ProductCategoryID = c.CategoryID
    ORDER BY 
        p.ProductName;
END;
GO