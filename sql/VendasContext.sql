﻿IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210813004112_Initial')
BEGIN
    CREATE SEQUENCE [MinhaSequencia] AS int START WITH 1000 INCREMENT BY 1 NO MINVALUE NO MAXVALUE NO CYCLE;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210813004112_Initial')
BEGIN
    CREATE TABLE [Vouchers] (
        [Id] uniqueidentifier NOT NULL,
        [Codigo] varchar(100) NOT NULL,
        [PercentualDesconto] decimal(18,2) NULL,
        [ValorDesconto] decimal(18,2) NULL,
        [Quantidade] int NOT NULL,
        [TipoDescontoVoucher] int NOT NULL,
        [DataValidade] datetime2 NOT NULL,
        [Ativo] bit NOT NULL,
        [Utilizado] bit NOT NULL,
        CONSTRAINT [PK_Vouchers] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210813004112_Initial')
BEGIN
    CREATE TABLE [Pedidos] (
        [Id] uniqueidentifier NOT NULL,
        [Codigo] int NOT NULL DEFAULT (NEXT VALUE FOR MinhaSequencia),
        [ClienteId] uniqueidentifier NOT NULL,
        [VoucherId] uniqueidentifier NULL,
        [ValorTotal] decimal(18,2) NOT NULL,
        [PedidoStatus] int NOT NULL,
        [Desconto] decimal(18,2) NOT NULL,
        [DataCadastro] datetime2 NOT NULL,
        [VoucherUtilizado] bit NOT NULL,
        CONSTRAINT [PK_Pedidos] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_Pedidos_Vouchers_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [Vouchers] ([Id]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210813004112_Initial')
BEGIN
    CREATE TABLE [PedidoItems] (
        [Id] uniqueidentifier NOT NULL,
        [PedidoId] uniqueidentifier NOT NULL,
        [ProdutoId] uniqueidentifier NOT NULL,
        [ProdutoNome] varchar(250) NOT NULL,
        [Quantidade] int NOT NULL,
        [ValorUnitario] decimal(18,2) NOT NULL,
        CONSTRAINT [PK_PedidoItems] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_PedidoItems_Pedidos_PedidoId] FOREIGN KEY ([PedidoId]) REFERENCES [Pedidos] ([Id]) ON DELETE NO ACTION
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210813004112_Initial')
BEGIN
    CREATE INDEX [IX_PedidoItems_PedidoId] ON [PedidoItems] ([PedidoId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210813004112_Initial')
BEGIN
    CREATE INDEX [IX_Pedidos_VoucherId] ON [Pedidos] ([VoucherId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210813004112_Initial')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210813004112_Initial', N'5.0.6');
END;
GO

COMMIT;
GO

