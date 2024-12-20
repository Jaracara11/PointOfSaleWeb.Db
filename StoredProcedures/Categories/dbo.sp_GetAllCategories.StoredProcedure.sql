USE [db10814]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetAllCategories] 
AS 
BEGIN
    SET NOCOUNT ON;

    SELECT 
        CategoryID, 
        CategoryName 
    FROM 
        Categories WITH (NOLOCK) 
    ORDER BY 
        CategoryName ASC;
END;
GO


