﻿/*
Deployment script for BikeStores

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "BikeStores"
:setvar DefaultFilePrefix "BikeStores"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Dropping Default Constraint unnamed constraint on [sales].[order_items]...';


GO
ALTER TABLE [sales].[order_items] DROP CONSTRAINT [DF__order_ite__disco__47DBAE45];


GO
PRINT N'Dropping Foreign Key unnamed constraint on [production].[stocks]...';


GO
ALTER TABLE [production].[stocks] DROP CONSTRAINT [FK__stocks__product___4BAC3F29];


GO
PRINT N'Dropping Foreign Key unnamed constraint on [sales].[order_items]...';


GO
ALTER TABLE [sales].[order_items] DROP CONSTRAINT [FK__order_ite__produ__4D94879B];


GO
PRINT N'Dropping Foreign Key unnamed constraint on [production].[products]...';


GO
ALTER TABLE [production].[products] DROP CONSTRAINT [FK__products__catego__48CFD27E];


GO
PRINT N'Dropping Foreign Key unnamed constraint on [production].[products]...';


GO
ALTER TABLE [production].[products] DROP CONSTRAINT [FK__products__brand___49C3F6B7];


GO
PRINT N'Dropping Foreign Key unnamed constraint on [production].[stocks]...';


GO
ALTER TABLE [production].[stocks] DROP CONSTRAINT [FK__stocks__store_id__4AB81AF0];


GO
PRINT N'Dropping Foreign Key unnamed constraint on [sales].[orders]...';


GO
ALTER TABLE [sales].[orders] DROP CONSTRAINT [FK__orders__customer__4E88ABD4];


GO
PRINT N'Dropping Foreign Key unnamed constraint on [sales].[order_items]...';


GO
ALTER TABLE [sales].[order_items] DROP CONSTRAINT [FK__order_ite__order__4CA06362];


GO
PRINT N'Dropping Foreign Key unnamed constraint on [sales].[orders]...';


GO
ALTER TABLE [sales].[orders] DROP CONSTRAINT [FK__orders__staff_id__5070F446];


GO
PRINT N'Dropping Foreign Key unnamed constraint on [sales].[staffs]...';


GO
ALTER TABLE [sales].[staffs] DROP CONSTRAINT [FK__staffs__manager___52593CB8];


GO
PRINT N'Dropping Foreign Key unnamed constraint on [sales].[staffs]...';


GO
ALTER TABLE [sales].[staffs] DROP CONSTRAINT [FK__staffs__store_id__5165187F];


GO
PRINT N'Dropping Foreign Key unnamed constraint on [sales].[orders]...';


GO
ALTER TABLE [sales].[orders] DROP CONSTRAINT [FK__orders__store_id__4F7CD00D];


GO
PRINT N'Starting rebuilding table [production].[products]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [production].[tmp_ms_xx_products] (
    [product_id]   INT             IDENTITY (1, 1) NOT NULL,
    [product_name] VARCHAR (255)   NOT NULL,
    [brand_id]     INT             NOT NULL,
    [category_id]  INT             NOT NULL,
    [model_year]   SMALLINT        NOT NULL,
    [list_price]   DECIMAL (10, 2) NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_product1] PRIMARY KEY CLUSTERED ([product_id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [production].[products])
    BEGIN
        SET IDENTITY_INSERT [production].[tmp_ms_xx_products] ON;
        INSERT INTO [production].[tmp_ms_xx_products] ([product_id], [product_name], [brand_id], [category_id], [model_year], [list_price])
        SELECT   [product_id],
                 [product_name],
                 [brand_id],
                 [category_id],
                 [model_year],
                 [list_price]
        FROM     [production].[products]
        ORDER BY [product_id] ASC;
        SET IDENTITY_INSERT [production].[tmp_ms_xx_products] OFF;
    END

DROP TABLE [production].[products];

EXECUTE sp_rename N'[production].[tmp_ms_xx_products]', N'products';

EXECUTE sp_rename N'[production].[tmp_ms_xx_constraint_PK_product1]', N'PK_product', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Starting rebuilding table [production].[stocks]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [production].[tmp_ms_xx_stocks] (
    [store_id]   INT NOT NULL,
    [product_id] INT NOT NULL,
    [quantity]   INT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_stock1] PRIMARY KEY CLUSTERED ([store_id] ASC, [product_id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [production].[stocks])
    BEGIN
        INSERT INTO [production].[tmp_ms_xx_stocks] ([store_id], [product_id], [quantity])
        SELECT   [store_id],
                 [product_id],
                 [quantity]
        FROM     [production].[stocks]
        ORDER BY [store_id] ASC, [product_id] ASC;
    END

DROP TABLE [production].[stocks];

EXECUTE sp_rename N'[production].[tmp_ms_xx_stocks]', N'stocks';

EXECUTE sp_rename N'[production].[tmp_ms_xx_constraint_PK_stock1]', N'PK_stock', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Starting rebuilding table [sales].[customers]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [sales].[tmp_ms_xx_customers] (
    [customer_id] INT           IDENTITY (1, 1) NOT NULL,
    [first_name]  VARCHAR (255) NOT NULL,
    [last_name]   VARCHAR (255) NOT NULL,
    [phone]       VARCHAR (25)  NULL,
    [email]       VARCHAR (255) NOT NULL,
    [street]      VARCHAR (255) NULL,
    [city]        VARCHAR (50)  NULL,
    [state]       VARCHAR (25)  NULL,
    [zip_code]    VARCHAR (5)   NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_customers1] PRIMARY KEY CLUSTERED ([customer_id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [sales].[customers])
    BEGIN
        SET IDENTITY_INSERT [sales].[tmp_ms_xx_customers] ON;
        INSERT INTO [sales].[tmp_ms_xx_customers] ([customer_id], [first_name], [last_name], [phone], [email], [street], [city], [state], [zip_code])
        SELECT   [customer_id],
                 [first_name],
                 [last_name],
                 [phone],
                 [email],
                 [street],
                 [city],
                 [state],
                 [zip_code]
        FROM     [sales].[customers]
        ORDER BY [customer_id] ASC;
        SET IDENTITY_INSERT [sales].[tmp_ms_xx_customers] OFF;
    END

DROP TABLE [sales].[customers];

EXECUTE sp_rename N'[sales].[tmp_ms_xx_customers]', N'customers';

EXECUTE sp_rename N'[sales].[tmp_ms_xx_constraint_PK_customers1]', N'PK_customers', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Starting rebuilding table [sales].[order_items]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [sales].[tmp_ms_xx_order_items] (
    [order_id]   INT             NOT NULL,
    [item_id]    INT             NOT NULL,
    [product_id] INT             NOT NULL,
    [quantity]   INT             NOT NULL,
    [list_price] DECIMAL (10, 2) NOT NULL,
    [discount]   DECIMAL (4, 2)  DEFAULT 0 NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_order_items1] PRIMARY KEY CLUSTERED ([order_id] ASC, [item_id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [sales].[order_items])
    BEGIN
        INSERT INTO [sales].[tmp_ms_xx_order_items] ([order_id], [item_id], [product_id], [quantity], [list_price], [discount])
        SELECT   [order_id],
                 [item_id],
                 [product_id],
                 [quantity],
                 [list_price],
                 [discount]
        FROM     [sales].[order_items]
        ORDER BY [order_id] ASC, [item_id] ASC;
    END

DROP TABLE [sales].[order_items];

EXECUTE sp_rename N'[sales].[tmp_ms_xx_order_items]', N'order_items';

EXECUTE sp_rename N'[sales].[tmp_ms_xx_constraint_PK_order_items1]', N'PK_order_items', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Starting rebuilding table [sales].[staffs]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [sales].[tmp_ms_xx_staffs] (
    [staff_id]   INT           IDENTITY (1, 1) NOT NULL,
    [first_name] VARCHAR (50)  NOT NULL,
    [last_name]  VARCHAR (50)  NOT NULL,
    [email]      VARCHAR (255) NOT NULL,
    [phone]      VARCHAR (25)  NULL,
    [active]     TINYINT       NOT NULL,
    [store_id]   INT           NOT NULL,
    [manager_id] INT           NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_staff1] PRIMARY KEY CLUSTERED ([staff_id] ASC),
    UNIQUE NONCLUSTERED ([email] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [sales].[staffs])
    BEGIN
        SET IDENTITY_INSERT [sales].[tmp_ms_xx_staffs] ON;
        INSERT INTO [sales].[tmp_ms_xx_staffs] ([staff_id], [first_name], [last_name], [email], [phone], [active], [store_id], [manager_id])
        SELECT   [staff_id],
                 [first_name],
                 [last_name],
                 [email],
                 [phone],
                 [active],
                 [store_id],
                 [manager_id]
        FROM     [sales].[staffs]
        ORDER BY [staff_id] ASC;
        SET IDENTITY_INSERT [sales].[tmp_ms_xx_staffs] OFF;
    END

DROP TABLE [sales].[staffs];

EXECUTE sp_rename N'[sales].[tmp_ms_xx_staffs]', N'staffs';

EXECUTE sp_rename N'[sales].[tmp_ms_xx_constraint_PK_staff1]', N'PK_staff', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Starting rebuilding table [sales].[stores]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [sales].[tmp_ms_xx_stores] (
    [store_id]   INT           IDENTITY (1, 1) NOT NULL,
    [store_name] VARCHAR (255) NOT NULL,
    [phone]      VARCHAR (25)  NULL,
    [email]      VARCHAR (255) NULL,
    [street]     VARCHAR (255) NULL,
    [city]       VARCHAR (255) NULL,
    [state]      VARCHAR (10)  NULL,
    [zip_code]   VARCHAR (5)   NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_stores1] PRIMARY KEY CLUSTERED ([store_id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [sales].[stores])
    BEGIN
        SET IDENTITY_INSERT [sales].[tmp_ms_xx_stores] ON;
        INSERT INTO [sales].[tmp_ms_xx_stores] ([store_id], [store_name], [phone], [email], [street], [city], [state], [zip_code])
        SELECT   [store_id],
                 [store_name],
                 [phone],
                 [email],
                 [street],
                 [city],
                 [state],
                 [zip_code]
        FROM     [sales].[stores]
        ORDER BY [store_id] ASC;
        SET IDENTITY_INSERT [sales].[tmp_ms_xx_stores] OFF;
    END

DROP TABLE [sales].[stores];

EXECUTE sp_rename N'[sales].[tmp_ms_xx_stores]', N'stores';

EXECUTE sp_rename N'[sales].[tmp_ms_xx_constraint_PK_stores1]', N'PK_stores', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating Foreign Key unnamed constraint on [production].[products]...';


GO
ALTER TABLE [production].[products] WITH NOCHECK
    ADD FOREIGN KEY ([category_id]) REFERENCES [production].[categories] ([category_id]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Creating Foreign Key unnamed constraint on [production].[products]...';


GO
ALTER TABLE [production].[products] WITH NOCHECK
    ADD FOREIGN KEY ([brand_id]) REFERENCES [production].[brands] ([brand_id]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Creating Foreign Key [production].[FK_stock_stores]...';


GO
ALTER TABLE [production].[stocks] WITH NOCHECK
    ADD CONSTRAINT [FK_stock_stores] FOREIGN KEY ([store_id]) REFERENCES [sales].[stores] ([store_id]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Creating Foreign Key [production].[FKJ_stock_products]...';


GO
ALTER TABLE [production].[stocks] WITH NOCHECK
    ADD CONSTRAINT [FKJ_stock_products] FOREIGN KEY ([product_id]) REFERENCES [production].[products] ([product_id]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Creating Foreign Key [sales].[FK_orders_order_item]...';


GO
ALTER TABLE [sales].[order_items] WITH NOCHECK
    ADD CONSTRAINT [FK_orders_order_item] FOREIGN KEY ([order_id]) REFERENCES [sales].[orders] ([order_id]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Creating Foreign Key [sales].[FK_product_order_item]...';


GO
ALTER TABLE [sales].[order_items] WITH NOCHECK
    ADD CONSTRAINT [FK_product_order_item] FOREIGN KEY ([product_id]) REFERENCES [production].[products] ([product_id]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Creating Foreign Key unnamed constraint on [sales].[staffs]...';


GO
ALTER TABLE [sales].[staffs] WITH NOCHECK
    ADD FOREIGN KEY ([manager_id]) REFERENCES [sales].[staffs] ([staff_id]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [sales].[staffs]...';


GO
ALTER TABLE [sales].[staffs] WITH NOCHECK
    ADD FOREIGN KEY ([store_id]) REFERENCES [sales].[stores] ([store_id]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Creating Foreign Key [sales].[FK_orders_customers]...';


GO
ALTER TABLE [sales].[orders] WITH NOCHECK
    ADD CONSTRAINT [FK_orders_customers] FOREIGN KEY ([customer_id]) REFERENCES [sales].[customers] ([customer_id]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Creating Foreign Key [sales].[FK_orders_staff]...';


GO
ALTER TABLE [sales].[orders] WITH NOCHECK
    ADD CONSTRAINT [FK_orders_staff] FOREIGN KEY ([staff_id]) REFERENCES [sales].[staffs] ([staff_id]);


GO
PRINT N'Creating Foreign Key [sales].[FK_orders_stores]...';


GO
ALTER TABLE [sales].[orders] WITH NOCHECK
    ADD CONSTRAINT [FK_orders_stores] FOREIGN KEY ([store_id]) REFERENCES [sales].[stores] ([store_id]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [production].[stocks] WITH CHECK CHECK CONSTRAINT [FK_stock_stores];

ALTER TABLE [production].[stocks] WITH CHECK CHECK CONSTRAINT [FKJ_stock_products];

ALTER TABLE [sales].[order_items] WITH CHECK CHECK CONSTRAINT [FK_orders_order_item];

ALTER TABLE [sales].[order_items] WITH CHECK CHECK CONSTRAINT [FK_product_order_item];

ALTER TABLE [sales].[orders] WITH CHECK CHECK CONSTRAINT [FK_orders_customers];

ALTER TABLE [sales].[orders] WITH CHECK CHECK CONSTRAINT [FK_orders_staff];

ALTER TABLE [sales].[orders] WITH CHECK CHECK CONSTRAINT [FK_orders_stores];


GO
CREATE TABLE [#__checkStatus] (
    id           INT            IDENTITY (1, 1) PRIMARY KEY CLUSTERED,
    [Schema]     NVARCHAR (256),
    [Table]      NVARCHAR (256),
    [Constraint] NVARCHAR (256)
);

SET NOCOUNT ON;

DECLARE tableconstraintnames CURSOR LOCAL FORWARD_ONLY
    FOR SELECT SCHEMA_NAME([schema_id]),
               OBJECT_NAME([parent_object_id]),
               [name],
               0
        FROM   [sys].[objects]
        WHERE  [parent_object_id] IN (OBJECT_ID(N'production.products'), OBJECT_ID(N'sales.staffs'))
               AND [type] IN (N'F', N'C')
                   AND [object_id] IN (SELECT [object_id]
                                       FROM   [sys].[check_constraints]
                                       WHERE  [is_not_trusted] <> 0
                                              AND [is_disabled] = 0
                                       UNION
                                       SELECT [object_id]
                                       FROM   [sys].[foreign_keys]
                                       WHERE  [is_not_trusted] <> 0
                                              AND [is_disabled] = 0);

DECLARE @schemaname AS NVARCHAR (256);

DECLARE @tablename AS NVARCHAR (256);

DECLARE @checkname AS NVARCHAR (256);

DECLARE @is_not_trusted AS INT;

DECLARE @statement AS NVARCHAR (1024);

BEGIN TRY
    OPEN tableconstraintnames;
    FETCH tableconstraintnames INTO @schemaname, @tablename, @checkname, @is_not_trusted;
    WHILE @@fetch_status = 0
        BEGIN
            PRINT N'Checking constraint: ' + @checkname + N' [' + @schemaname + N'].[' + @tablename + N']';
            SET @statement = N'ALTER TABLE [' + @schemaname + N'].[' + @tablename + N'] WITH ' + CASE @is_not_trusted WHEN 0 THEN N'CHECK' ELSE N'NOCHECK' END + N' CHECK CONSTRAINT [' + @checkname + N']';
            BEGIN TRY
                EXECUTE [sp_executesql] @statement;
            END TRY
            BEGIN CATCH
                INSERT  [#__checkStatus] ([Schema], [Table], [Constraint])
                VALUES                  (@schemaname, @tablename, @checkname);
            END CATCH
            FETCH tableconstraintnames INTO @schemaname, @tablename, @checkname, @is_not_trusted;
        END
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH

IF CURSOR_STATUS(N'LOCAL', N'tableconstraintnames') >= 0
    CLOSE tableconstraintnames;

IF CURSOR_STATUS(N'LOCAL', N'tableconstraintnames') = -1
    DEALLOCATE tableconstraintnames;

SELECT N'Constraint verification failed:' + [Schema] + N'.' + [Table] + N',' + [Constraint]
FROM   [#__checkStatus];

IF @@ROWCOUNT > 0
    BEGIN
        DROP TABLE [#__checkStatus];
        RAISERROR (N'An error occurred while verifying constraints', 16, 127);
    END

SET NOCOUNT OFF;

DROP TABLE [#__checkStatus];


GO
PRINT N'Update complete.';


GO
