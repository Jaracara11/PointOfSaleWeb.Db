USE [POS]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    CREATE PROCEDURE [dbo].[GetOrderById] 
	@OrderId NVARCHAR(50) AS BEGIN
SELECT
    OrderID,
    [User],
    Products,
    OrderSubTotal,
    Discount,
    OrderTotal,
    OrderDate
FROM
    Orders WITH (NOLOCK)
WHERE
    OrderID = @OrderId
END
