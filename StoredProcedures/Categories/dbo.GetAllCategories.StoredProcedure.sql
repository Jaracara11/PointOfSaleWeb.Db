USE [POS]
GO
   /****** Object:  StoredProcedure [dbo].[GetAllCategories]    Script Date: 4/8/2023 5:21:54 PM ******/
SET
   ANSI_NULLS ON
GO
SET
   QUOTED_IDENTIFIER ON
GO
   CREATE PROCEDURE [dbo].[GetAllCategories] AS BEGIN
SELECT
   CategoryID,
   CategoryName
FROM
   Categories WITH (NOLOCK)
ORDER BY
   CategoryName ASC;

END
GO