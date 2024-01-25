USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[GetOrdersByDate]    Script Date: 1/25/2024 11:29:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetOrdersByDate]
@InitialDate DateTime,
@FinalDate Datetime
AS BEGIN
    SET @InitialDate = DATEADD(DAY, DATEDIFF(DAY, 0, @InitialDate), 0)
    SET @FinalDate = DATEADD(MINUTE, -1, DATEADD(DAY, DATEDIFF(DAY, 0, @FinalDate) + 1, 0))

    SELECT 
        OrderID,
        [User],
        OrderTotal,
        OrderDate
    FROM Orders WITH (NOLOCK)
    WHERE OrderDate BETWEEN @InitialDate AND @FinalDate
    ORDER BY OrderDate DESC;
END