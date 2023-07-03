USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[GetOrderById]    Script Date: 7/3/2023 4:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetOrderById] 
    @OrderId UNIQUEIDENTIFIER
AS 
BEGIN
    SELECT
        Orders.OrderID,
        CONCAT(U.FirstName, ' ', U.LastName) AS [User],
        Orders.OrderSubTotal,
        CAST(Orders.Discount * Orders.OrderSubTotal AS DECIMAL(18,2)) AS Discount,
        Orders.OrderTotal,
        Orders.OrderDate,
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
                    ProductID int,
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
