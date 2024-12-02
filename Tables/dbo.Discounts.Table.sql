USE [db10814]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discounts](
    [DiscountID] [int] IDENTITY(1,1) NOT NULL,
    [UserRoleID] [int] NOT NULL,
    [DiscountAmount] [decimal](18, 2) NOT NULL,
    PRIMARY KEY CLUSTERED 
    (
        [DiscountID] ASC
    ) WITH 
    (
        PAD_INDEX = OFF, 
        STATISTICS_NORECOMPUTE = OFF, 
        IGNORE_DUP_KEY = OFF, 
        ALLOW_ROW_LOCKS = ON, 
        ALLOW_PAGE_LOCKS = ON, 
        OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Discounts]  WITH CHECK ADD  
    CONSTRAINT [fk_discounts_userrole] FOREIGN KEY([UserRoleID])
    REFERENCES [dbo].[UserRoles] ([UserRoleID])
GO

ALTER TABLE [dbo].[Discounts] CHECK CONSTRAINT [fk_discounts_userrole]
GO
INSERT INTO [dbo].[Discounts] ([UserRoleID], [DiscountAmount])
VALUES 
    (1, 0.20),  -- Role 1 gets 20% discount
    (1, 0.15),  -- Role 1 gets 15% discount
    (1, 0.10),  -- Role 1 gets 10% discount
    (1, 0.05),  -- Role 1 gets 5% discount
    (2, 0.20),  -- Role 2 gets 20% discount
    (2, 0.15),  -- Role 2 gets 15% discount
    (2, 0.10),  -- Role 2 gets 10% discount
    (2, 0.05),  -- Role 2 gets 5% discount
    (3, 0.10),  -- Role 3 gets 10% discount
    (3, 0.05);  -- Role 3 gets 5% discount
GO