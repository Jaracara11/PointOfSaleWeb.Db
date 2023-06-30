USE [POS]
GO
/****** Object: StoredProcedure [dbo].[GetTotalSalesOfTheDay] Script Date: 6/30/2023 8:16:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetTotalSalesOfTheDay] AS 
BEGIN
    DECLARE @TotalSalesOfTheDay DECIMAL(18, 2) = NULL;

    SELECT @TotalSalesOfTheDay = SUM(OrderTotal)
    FROM orders WITH (NOLOCK)
    WHERE CONVERT(DATE, OrderDate) = CONVERT(DATE, GETDATE());

    SELECT ISNULL(@TotalSalesOfTheDay, 0) AS TotalSalesOfTheDay;
END