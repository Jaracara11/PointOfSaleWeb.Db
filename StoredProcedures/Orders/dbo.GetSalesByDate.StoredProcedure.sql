USE [POS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetSalesByDate]
@InitialDate DateTime,
@FinalDate Datetime
AS BEGIN
    SELECT
        SUM(OrderTotal) AS TotalSales
    FROM Orders WITH (NOLOCK)
    WHERE OrderDate BETWEEN @InitialDate AND @FinalDate
    GROUP BY OrderDate
    ORDER BY OrderDate;
END
