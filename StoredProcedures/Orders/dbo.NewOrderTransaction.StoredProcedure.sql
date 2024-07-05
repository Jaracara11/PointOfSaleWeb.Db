USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[NewOrderTransaction]    Script Date: 7/3/2023 4:54:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[NewOrderTransaction]
    @User NVARCHAR(25),
    @Products NVARCHAR(MAX),
    @Discount DECIMAL(18, 2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Users WHERE Username = @User)
    BEGIN
        THROW 51000, 'User does not exist!', 1;
    END 

    DECLARE @UserRoleID INT;
    SELECT @UserRoleID = UserRoleID FROM Users WITH (NOLOCK) WHERE Username = @User;

    IF (@UserRoleID = 0 OR @UserRoleID IS NULL)
    BEGIN
        THROW 51000, 'User does not have permission to perform sales operations.', 1;
    END 

    DECLARE @DiscountValid DECIMAL(18, 2) = NULL;

    IF @Discount IS NOT NULL
    BEGIN
       SELECT @DiscountValid = DiscountAmount
       FROM Discounts WITH (NOLOCK)
       WHERE UserRoleID = @UserRoleID AND DiscountAmount = @Discount;
    END

    IF @DiscountValid IS NULL AND @Discount IS NOT NULL
    BEGIN
        THROW 50002, 'Invalid discount amount, please try again.', 1;
    END

    CREATE TABLE #ProductQuantities
    (
        ProductID NVARCHAR(50),
        ProductQuantity INT
    );

    INSERT INTO #ProductQuantities (ProductID, ProductQuantity)
    SELECT JSON_VALUE(p.Value, '$.ProductID') AS ProductID,
           JSON_VALUE(p.Value, '$.ProductQuantity') AS ProductQuantity
    FROM OPENJSON(@Products) AS p;

    IF EXISTS (
        SELECT 1
        FROM #ProductQuantities pq
        INNER JOIN Products p ON pq.ProductID = p.ProductID
        WHERE pq.ProductQuantity > p.ProductStock
    )
    BEGIN
        THROW 50001, 'Product quantity exceeds its stock, please update your cart.', 1;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @OrderID UNIQUEIDENTIFIER = NEWID();
        DECLARE @OrderSubTotal DECIMAL(18, 2) = 0;
        DECLARE @OrderTotal DECIMAL(18, 2) = 0;
        DECLARE @OrderDate DATETIME = GETDATE();
        
        SELECT @OrderSubTotal = SUM(pq.ProductQuantity * p.ProductPrice)
        FROM #ProductQuantities pq
        INNER JOIN Products p ON pq.ProductID = p.ProductID;

        IF @Discount IS NOT NULL
        BEGIN
            SET @OrderTotal = @OrderSubTotal - (@OrderSubTotal * @Discount / 100);
        END
        ELSE
        BEGIN
            SET @OrderTotal = @OrderSubTotal;
        END

        INSERT INTO Orders (OrderID, [User], Products, OrderSubTotal, Discount, OrderTotal, OrderDate)
        VALUES (@OrderID, @User, @Products, @OrderSubTotal, @Discount, @OrderTotal, @OrderDate);

        UPDATE Products
        SET ProductStock = ProductStock - pq.ProductQuantity
        FROM #ProductQuantities pq
        WHERE Products.ProductID = pq.ProductID;

        COMMIT TRANSACTION;

        EXEC [dbo].[GetOrderById] @OrderId = @OrderID;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END