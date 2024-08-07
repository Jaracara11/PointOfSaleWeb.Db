USE [POS]
GO
    /****** Object: StoredProcedure [dbo].[DeleteCategory] ******/
SET
    ANSI_NULLS ON
GO
SET
    QUOTED_IDENTIFIER ON
GO
    CREATE PROCEDURE [dbo].[DeleteCategory] @CategoryID INT AS BEGIN
SET
    NOCOUNT ON;

BEGIN TRY 
IF NOT EXISTS (
    SELECT
        1
    FROM
        Categories
    WHERE
        CategoryID = @CategoryID
) BEGIN THROW 51000,
'Category not found!',
1;

END 
IF EXISTS (
    SELECT
        1
    FROM
        Products
    WHERE
        ProductCategoryID = @CategoryID
) BEGIN THROW 51000,
'Cannot delete this category while it has products assigned to it!',
1;

END BEGIN TRANSACTION;

-- Delete the category
DELETE FROM
    Categories
WHERE
    CategoryID = @CategoryID;

COMMIT TRANSACTION;

END TRY BEGIN CATCH IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

THROW;

END CATCH;

END