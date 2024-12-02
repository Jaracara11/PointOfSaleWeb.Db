USE [db10814]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_AuthUser]
    @Username NVARCHAR(25),
    @Password NVARCHAR(255)
AS
BEGIN
    DECLARE @Result NVARCHAR(MAX);
    DECLARE @UserID INT;
    DECLARE @FirstName NVARCHAR(50);
    DECLARE @LastName NVARCHAR(50);
    DECLARE @Email NVARCHAR(100);
    DECLARE @RoleName NVARCHAR(50);
    DECLARE @PasswordHash NVARCHAR(255);

    IF EXISTS (SELECT 1 FROM dbo.Users WHERE Username = @Username AND PasswordHash = @Password)
    BEGIN
        SELECT 
            @UserID = u.UserID,
            @FirstName = u.FirstName,
            @LastName = u.LastName,
            @Email = u.Email,
            @RoleName = r.RoleName 
        FROM dbo.Users u
        INNER JOIN dbo.UserRoles r ON u.UserRoleID = r.UserRoleID
        WHERE u.Username = @Username;

        SET @Result = 'Success';
    END
    ELSE
    BEGIN
        SET @Result = 'Invalid username or password';
    END

    SELECT 
        @Result AS Message,
        @UserID AS UserID,
        @Username AS Username,
        @FirstName AS FirstName,
        @LastName AS LastName,
        @Email AS Email,
        @RoleName AS RoleName; 
END
GO