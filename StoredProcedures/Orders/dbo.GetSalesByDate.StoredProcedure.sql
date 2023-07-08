USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[GetSalesByDate]    Script Date: 7/8/2023 8:55:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetSalesByDate]
@InitialDate DateTime,
@FinalDate Datetime
AS BEGIN
    SET @InitialDate = DATEADD(DAY, DATEDIFF(DAY, 0, @InitialDate), 0)
    SET @FinalDate = DATEADD(MINUTE, -1, DATEADD(DAY, DATEDIFF(DAY, 0, @FinalDate) + 1, 0))

	DECLARE @TotalSales decimal(18, 2);

	SELECT @TotalSales = SUM(OrderTotal)
	FROM Orders WITH (NOLOCK)
	WHERE OrderDate BETWEEN @InitialDate AND @FinalDate;

	SELECT ISNULL(@TotalSales, 0);
END
