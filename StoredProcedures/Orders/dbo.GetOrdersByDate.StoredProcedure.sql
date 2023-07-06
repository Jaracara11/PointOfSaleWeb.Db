USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[GetOrdersByDate]    Script Date: 7/6/2023 1:48:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   ALTER PROCEDURE [dbo].[GetOrdersByDate]
   @InitialDate DateTime,
   @FinalDate Datetime
   AS BEGIN
SELECT 
       OrderID,
       [User],
	   OrderTotal,
	   OrderDate
FROM Orders WITH (NOLOCK)
WHERE OrderDate BETWEEN @InitialDate AND @FinalDate
ORDER BY OrderDate DESC;
END