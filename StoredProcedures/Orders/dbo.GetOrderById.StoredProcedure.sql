USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[GetOrderById]    Script Date: 7/2/2023 11:11:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    ALTER PROCEDURE [dbo].[GetOrderById] 
	@OrderId UNIQUEIDENTIFIER AS BEGIN
SELECT
    Orders.OrderID,
    Orders.[User],
	P.ProductName,
    P.ProductDescription,
    ProductInfo.ProductQuantity,
    P.ProductPrice,
    C.CategoryName AS ProductCategoryName,
	Orders.OrderSubTotal,
	CAST(Orders.Discount * Orders.OrderSubTotal AS DECIMAL(18,2)) AS Discount,
	Orders.OrderTotal,
	Orders.OrderDate
FROM
    Orders WITH (NOLOCK)
    CROSS APPLY OPENJSON(Orders.Products) WITH (
        ProductID int,
        ProductQuantity int
    ) AS ProductInfo
    JOIN Products AS P WITH (NOLOCK) ON ProductInfo.ProductID = P.ProductID
    JOIN Categories AS C WITH (NOLOCK) ON P.ProductCategoryID = C.CategoryID
WHERE
    Orders.OrderID = @OrderId;
END 