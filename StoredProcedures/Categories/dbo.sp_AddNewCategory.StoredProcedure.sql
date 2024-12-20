USE [db10814]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_AddNewCategory]
    @CategoryName VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM [dbo].[Categories]
        WHERE [CategoryName] = @CategoryName
    )
    BEGIN
        THROW 50000, 'Category name already exists!', 1;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [dbo].[Categories] (CategoryName)
        VALUES (@CategoryName);


        COMMIT TRANSACTION;

        SELECT CategoryID, CategoryName
        FROM [dbo].[Categories]
        WHERE CategoryName = @CategoryName;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO