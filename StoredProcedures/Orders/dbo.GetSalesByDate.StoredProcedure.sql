USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[GetSalesByDate]    Script Date: 7/7/2023 8:06:37 AM ******/
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
    WHERE OrderDate BETWEEN @InitialDate AND @FinalDate;
END
