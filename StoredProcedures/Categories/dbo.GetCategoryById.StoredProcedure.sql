USE [POS]
GO
    /****** Object:  StoredProcedure [dbo].[GetCategoryById]    Script Date: 4/8/2023 5:21:54 PM ******/
SET
    ANSI_NULLS ON
GO
SET
    QUOTED_IDENTIFIER ON
GO
    CREATE PROCEDURE [dbo].[GetCategoryById] @CategoryId INT AS BEGIN
SELECT
    CategoryID,
    CategoryName
FROM
    Categories WITH (NOLOCK)
WHERE
    CategoryID = @CategoryId
END
GO