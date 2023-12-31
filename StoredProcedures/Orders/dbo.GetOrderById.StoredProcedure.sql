USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[GetOrderById]    Script Date: 10/3/2023 6:32:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetOrderById] 
    @OrderId UNIQUEIDENTIFIER
AS 
BEGIN
SET NOCOUNT ON;
    SELECT
        Orders.OrderID,
        CONCAT(U.FirstName, ' ', U.LastName) AS [User],
        Orders.OrderSubTotal,
        CAST(Orders.Discount * Orders.OrderSubTotal AS DECIMAL(18,2)) AS Discount,
        Orders.OrderTotal,
        Orders.OrderDate,
		Orders.OrderCancelled,
        (
            SELECT
                ProductName,
                ProductDescription,
                ProductQuantity,
                ProductPrice,
                C.CategoryName AS ProductCategoryName
            FROM
                Orders
                CROSS APPLY OPENJSON(Orders.Products) WITH (
                    ProductID [nvarchar](50),
                    ProductQuantity int
                ) AS ProductInfo
                JOIN Products AS P ON ProductInfo.ProductID = P.ProductID
                JOIN Categories AS C ON P.ProductCategoryID = C.CategoryID
            WHERE
                Orders.OrderID = @OrderId
            FOR JSON PATH
        ) AS Products
    FROM
        Orders
		INNER JOIN Users AS U ON Orders.[User] = U.Username
    WHERE
        OrderID = @OrderId;
END
