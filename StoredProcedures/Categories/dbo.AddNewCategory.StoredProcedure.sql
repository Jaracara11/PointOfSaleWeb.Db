USE [POS]
GO
  /****** Object:  StoredProcedure [dbo].[AddNewCategory]    Script Date: 4/8/2023 5:21:54 PM ******/
SET
  ANSI_NULLS ON
GO
SET
  QUOTED_IDENTIFIER ON
GO
  CREATE PROCEDURE [dbo].[AddNewCategory] @CategoryName VARCHAR(50),
  @CategoryID INT = 0 AS BEGIN
SET
  nocount ON;

IF EXISTS (
  SELECT
    1
  FROM
    [dbo].[Categories]
  WHERE
    [Categoryname] = @CategoryName
) BEGIN THROW 50000,
'Category name already exists!',
1;

END BEGIN try;

BEGIN TRANSACTION;

INSERT INTO
  [dbo].[Categories] (Categoryname)
VALUES
  (@CategoryName);

COMMIT TRANSACTION;

SELECT
  @CategoryID = Scope_identity();

EXEC Getcategorybyid @CategoryID = @CategoryID;

END try BEGIN catch IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

THROW;

END catch;

END
GO