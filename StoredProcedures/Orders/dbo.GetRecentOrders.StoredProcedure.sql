USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[GetRecentOrders]    Script Date: 7/1/2023 9:05:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   CREATE PROCEDURE [dbo].[GetRecentOrders] AS BEGIN
SELECT TOP 5 
       [User],
	   OrderID,
	   OrderTotal, 
	   OrderDate 
FROM Orders WITH (NOLOCK) 
ORDER BY OrderDate DESC;
END