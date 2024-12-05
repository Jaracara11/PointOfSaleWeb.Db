USE [db10814]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[tg_ResetCategoryIDSeed]
ON [dbo].[Categories]
AFTER DELETE
AS
BEGIN
    DECLARE @MaxCategoryID INT;

    SELECT @MaxCategoryID = ISNULL(MAX(CategoryID), 0)
    FROM Categories;

    DBCC CHECKIDENT('Categories', RESEED, @MaxCategoryID);
END;
GO
ALTER TABLE [dbo].[Categories] ENABLE TRIGGER [tg_ResetCategoryIDSeed]
GO


