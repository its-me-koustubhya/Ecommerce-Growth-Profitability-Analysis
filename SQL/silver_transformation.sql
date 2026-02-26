-- Create Database
CREATE DATABASE ToyStoreDB;
GO

USE ToyStoreDB;
GO

-- Create External Data Source
CREATE EXTERNAL DATA SOURCE ToyStoreData
WITH (
    LOCATION = 'https://toystoreecommercestorage.dfs.core.windows.net'
);

-- Create Parquet File Format
CREATE EXTERNAL FILE FORMAT ParquetFormat
WITH (
    FORMAT_TYPE = PARQUET
);

-- SILVER LAYER TABLES (CETAS)

-- Orders
CREATE EXTERNAL TABLE silver_orders
WITH (
    LOCATION = 'silver/orders/',
    DATA_SOURCE = ToyStoreData,
    FILE_FORMAT = ParquetFormat
)
AS
SELECT
    CAST(order_id AS INT) AS order_id,
    CAST(created_at AS DATETIME2) AS created_at,
    CAST(website_session_id AS INT) AS website_session_id,
    CAST(user_id AS INT) AS user_id,
    CAST(primary_product_id AS INT) AS primary_product_id,
    CAST(items_purchased AS INT) AS items_purchased,
    CAST(price_usd AS FLOAT) AS price_usd,
    CAST(cogs_usd AS FLOAT) AS cogs_usd
FROM OPENROWSET(
    BULK 'https://toystoreecommercestorage.dfs.core.windows.net/bronze/orders/*.csv',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE
) AS rows;

-- Sessions
CREATE EXTERNAL TABLE silver_sessions
WITH (
    LOCATION = 'silver/sessions/',
    DATA_SOURCE = ToyStoreData,
    FILE_FORMAT = ParquetFormat
)
AS
SELECT
    CAST(website_session_id AS INT) AS website_session_id,
    CAST(created_at AS DATETIME2) AS created_at,
    CAST(user_id AS INT) AS user_id,
    CAST(is_repeat_session AS INT) AS is_repeat_session,
    CAST(utm_source AS VARCHAR(100)) AS utm_source,
    CAST(utm_campaign AS VARCHAR(100)) AS utm_campaign,
    CAST(utm_content AS VARCHAR(100)) AS utm_content,
    CAST(device_type AS VARCHAR(20)) AS device_type,
    CAST(http_referer AS VARCHAR(255)) AS http_referer
FROM OPENROWSET(
    BULK 'https://toystoreecommercestorage.dfs.core.windows.net/bronze/website_sessions/*.csv',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE
) AS rows;

-- Order Items
CREATE EXTERNAL TABLE silver_order_items
WITH (
    LOCATION = 'silver/order_items/',
    DATA_SOURCE = ToyStoreData,
    FILE_FORMAT = ParquetFormat
)
AS
SELECT
    CAST(order_item_id AS INT) AS order_item_id,
    CAST(created_at AS DATETIME2) AS created_at,
    CAST(order_id AS INT) AS order_id,
    CAST(product_id AS INT) AS product_id,
    CAST(is_primary_item AS INT) AS is_primary_item,
    CAST(price_usd AS FLOAT) AS price_usd,
    CAST(cogs_usd AS FLOAT) AS cogs_usd
FROM OPENROWSET(
    BULK 'https://toystoreecommercestorage.dfs.core.windows.net/bronze/order_items/*.csv',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE
) AS rows;

-- Refunds
CREATE EXTERNAL TABLE silver_refunds
WITH (
    LOCATION = 'silver/refunds/',
    DATA_SOURCE = ToyStoreData,
    FILE_FORMAT = ParquetFormat
)
AS
SELECT
    CAST(order_item_refund_id AS INT) AS order_item_refund_id,
    CAST(created_at AS DATETIME2) AS created_at,
    CAST(order_item_id AS INT) AS order_item_id,
    CAST(order_id AS INT) AS order_id,
    CAST(refund_amount_usd AS FLOAT) AS refund_amount_usd
FROM OPENROWSET(
    BULK 'https://toystoreecommercestorage.dfs.core.windows.net/bronze/order_item_refunds/*.csv',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE
) AS rows;

-- Products
CREATE EXTERNAL TABLE silver_products
WITH (
    LOCATION = 'silver/products/',
    DATA_SOURCE = ToyStoreData,
    FILE_FORMAT = ParquetFormat
)
AS
SELECT
    CAST(product_id AS INT) AS product_id,
    CAST(created_at AS DATETIME2) AS created_at,
    CAST(product_name AS VARCHAR(200)) AS product_name
FROM OPENROWSET(
    BULK 'https://toystoreecommercestorage.dfs.core.windows.net/bronze/products/*.csv',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE
) AS rows;