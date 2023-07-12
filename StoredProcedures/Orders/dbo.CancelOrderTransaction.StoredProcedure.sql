USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[CancelOrderTransaction]    Script Date: 7/12/2023 8:47:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CancelOrderTransaction]
    @OrderID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderID = @OrderID)
        BEGIN
            THROW 50003, 'Order not found!', 1;
        END

        DECLARE @ProductQuantities TABLE
        (
            ProductID INT,
            ProductQuantity INT
        );

        INSERT INTO @ProductQuantities (ProductID, ProductQuantity)
        SELECT JSON_VALUE(p.Value, '$.ProductID') AS ProductID,
               JSON_VALUE(p.Value, '$.ProductQuantity') AS ProductQuantity
        FROM Orders
        CROSS APPLY OPENJSON(Products) AS p;

		UPDATE p
        SET ProductStock = p.ProductStock + pq.ProductQuantity
        FROM @ProductQuantities pq
        INNER JOIN Products p ON pq.ProductID = p.ProductID;

        UPDATE Orders
        SET OrderTotal = 0,
            OrderCancelled = 1
        WHERE OrderID = @OrderID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END
