CREATE PROCEDURE [dbo].[GetOrderById] 
    @OrderId UNIQUEIDENTIFIER
AS 
BEGIN
    SELECT
        Orders.OrderID,
        Orders.[User],
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
    WHERE
        OrderID = @OrderId;
END
