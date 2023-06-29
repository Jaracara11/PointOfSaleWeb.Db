USE [POS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   CREATE PROCEDURE [dbo].[GetRecentOrders] AS BEGIN
SELECT
   CategoryID,
   CategoryName
FROM
   Categories WITH (NOLOCK)
ORDER BY
   CategoryName ASC;

SELECT TOP 5 
       [User], 
	   Products, 
	   OrderTotal, 
	   OrderDate 
FROM Orders WITH (NOLOCK) 
ORDER BY OrderDate DESC;
END
