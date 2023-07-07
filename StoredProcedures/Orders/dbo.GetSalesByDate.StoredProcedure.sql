USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[GetSalesByDate]    Script Date: 7/7/2023 8:06:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetSalesByDate]
@InitialDate DateTime,
@FinalDate Datetime
AS BEGIN
	DECLARE @TotalSales decimal(18, 2);

	SELECT @TotalSales = SUM(OrderTotal)
	FROM Orders WITH (NOLOCK)
	WHERE OrderDate BETWEEN @InitialDate AND @FinalDate;

	SELECT ISNULL(@TotalSales, 0);
END
