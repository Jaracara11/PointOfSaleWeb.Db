USE [db10814]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UpdateProduct] 
    @ProductID NVARCHAR(50),
    @ProductName NVARCHAR(100),
    @ProductDescription NVARCHAR(255),
    @ProductStock INT,
    @ProductCost DECIMAL(18, 2),
    @ProductPrice DECIMAL(18, 2),
    @ProductCategoryID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorMessage NVARCHAR(255);

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductID] = @ProductID)
    BEGIN
        SET @ErrorMessage = 'Product does not exist!';
        GOTO ErrorHandler;
    END;

    IF EXISTS (
        SELECT 1 
        FROM [dbo].[Products] 
        WHERE [ProductName] = @ProductName 
          AND [ProductID] <> @ProductID
    )
    BEGIN
        SET @ErrorMessage = 'Product name already exists!';
        GOTO ErrorHandler;
    END;

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Categories] WHERE [CategoryID] = @ProductCategoryID)
    BEGIN
        SET @ErrorMessage = 'Product category does not exist!';
        GOTO ErrorHandler;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [dbo].[Products]
        SET 
            ProductName = @ProductName,
            ProductDescription = @ProductDescription,
            ProductPrice = @ProductPrice,
            ProductCost = @ProductCost,
            ProductStock = @ProductStock,
            ProductCategoryID = @ProductCategoryID
        WHERE 
            ProductID = @ProductID;

        COMMIT TRANSACTION;

        SELECT 
            p.ProductID,
            p.ProductName,
            p.ProductDescription,
            p.ProductStock,
            p.ProductCost,
            p.ProductPrice,
            c.CategoryID, 
            c.CategoryName 
        FROM [dbo].[Products] p
        INNER JOIN [dbo].[Categories] c ON p.ProductCategoryID = c.CategoryID
        WHERE p.ProductID = @ProductID;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

    RETURN;

ErrorHandler:
    THROW 50000, @ErrorMessage, 1;
END;
GO