USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[GetRecentOrders]    Script Date: 7/5/2023 8:05:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   CREATE PROCEDURE [dbo].[GetOrdersByDate]
   @InitialDate DateTime,
   @FinalDate Datetime
   AS BEGIN
SELECT 
       OrderID,
       [User],
	   OrderTotal
FROM Orders WITH (NOLOCK)
WHERE OrderDate BETWEEN @InitialDate AND @FinalDate
ORDER BY OrderDate DESC;
END
