USE [POS]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   CREATE PROCEDURE [dbo].[GetAllDiscounts] AS BEGIN
SELECT
   UserRoleID,
   DiscountAmount
FROM
   Discounts WITH (NOLOCK)
   ORDER BY DiscountAmount ASC
END