USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[GetOrderById]    Script Date: 7/2/2023 9:30:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    CREATE PROCEDURE [dbo].[GetOrderById] 
	@OrderId UNIQUEIDENTIFIER AS BEGIN
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