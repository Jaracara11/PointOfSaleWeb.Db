USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[GetRecentOrders]    Script Date: 6/29/2023 12:53:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   CREATE PROCEDURE [dbo].[GetRecentOrders] AS BEGIN
SELECT TOP 5 
       [User], 
	   Products, 
	   OrderTotal, 
	   OrderDate 
FROM Orders WITH (NOLOCK) 
ORDER BY OrderDate DESC;
END