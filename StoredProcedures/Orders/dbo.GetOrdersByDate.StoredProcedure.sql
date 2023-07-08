USE [POS]
GO
/****** Object:  StoredProcedure [dbo].[GetOrdersByDate]    Script Date: 7/8/2023 8:54:50 AM ******/
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
