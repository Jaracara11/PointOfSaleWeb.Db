USE [db10814]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_AddNewProduct] 
    @ProductID NVARCHAR(50),
    @ProductName NVARCHAR(100),
    @ProductDescription NVARCHAR(255) = NULL,
    @ProductPrice DECIMAL(18, 2),
    @ProductCost DECIMAL(18, 2),
    @ProductStock INT,
    @ProductCategoryID INT 
AS 
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorMessage NVARCHAR(255);

    IF EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductID] = @ProductID)
    BEGIN
        SET @ErrorMessage = 'Product ID already exists!';
        GOTO ErrorHandler;
    END;

    IF EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductName] = @ProductName)
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

        INSERT INTO [dbo].[Products] (
            ProductID,
            ProductName,
            ProductDescription,
            ProductPrice,
            ProductCost,
            ProductStock,
            ProductCategoryID
        )
        VALUES (
            @ProductID,
            @ProductName,
            @ProductDescription,
            @ProductPrice,
            @ProductCost,
            @ProductStock,
            @ProductCategoryID
        );

        COMMIT TRANSACTION;

        EXEC dbo.sp_GetProductById @ProductID = @ProductID;
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