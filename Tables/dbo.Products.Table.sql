USE [POS]
GO
	/****** Object:  Table [dbo].[Products]    Script Date: 4/8/2023 5:21:54 PM ******/
SET
	ANSI_NULLS ON
GO
SET
	QUOTED_IDENTIFIER ON
GO
	CREATE TABLE [dbo].[Products](
		[ProductID] [nvarchar](50) NOT NULL,
		[ProductName] [nvarchar](50) NOT NULL,
		[ProductDescription] [nvarchar](100) NULL,
		[ProductPrice] [decimal](10, 2) NOT NULL,
		[ProductCost] [decimal](10, 2) NOT NULL,
		[ProductStock] [int] NOT NULL,
		[ProductCategoryID] [int] NOT NULL,
		CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([ProductID] ASC) WITH (
			PAD_INDEX = OFF,
			STATISTICS_NORECOMPUTE = OFF,
			IGNORE_DUP_KEY = OFF,
			ALLOW_ROW_LOCKS = ON,
			ALLOW_PAGE_LOCKS = ON,
			OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
		) ON [PRIMARY]
	) ON [PRIMARY]
GO
ALTER TABLE
	[dbo].[Products] WITH CHECK
ADD
	CONSTRAINT [fk_products_categoryID] FOREIGN KEY([ProductCategoryID]) REFERENCES [dbo].[Categories] ([CategoryID])
GO
ALTER TABLE
	[dbo].[Products] CHECK CONSTRAINT [fk_products_categoryID]
GO

--Insert placeholder products
INSERT INTO [dbo].[Products] ([ProductID], [ProductName], [ProductDescription], [ProductPrice], [ProductCost], [ProductStock], [ProductCategoryID])
VALUES 
    ('12357', 'iPhone 12', 'Latest smartphone from Apple', 999.99, 800.00, 100, 1),
    ('8552', 'Samsung Galaxy S21', 'High-end Android smartphone', 899.99, 750.00, 150, 1),
    ('55156', 'Nike Air Max', 'Running shoes with excellent cushioning', 129.99, 90.00, 50, 2),
    ('7867544', 'Levi''s 501 Jeans', 'Classic straight-leg jeans', 79.99, 60.00, 75, 2),
    ('9885255', 'Instant Pot', 'Multi-functional electric pressure cooker', 99.99, 80.00, 30, 3),
    ('122458', 'Harry Potter and the Sorcerer''s Stone', 'First book in the Harry Potter series', 12.99, 7.50, 200, 4),
    ('355676', 'MAC Ruby Woo Lipstick', 'Iconic matte red lipstick', 19.99, 15.00, 100, 5),
    ('741741', 'Yoga Mat', 'Non-slip exercise mat for yoga and fitness', 29.99, 20.00, 80, 6),
    ('659822', 'LEGO Star Wars Millennium Falcon', 'Building set with Star Wars spaceship', 159.99, 120.00, 20, 7),
    ('96515', 'Vitamins', 'Essential daily multivitamin supplements', 24.99, 18.00, 150, 8);
GO