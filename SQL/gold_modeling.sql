USE ToyStoreDB;
GO

-- FACT TABLES

-- Fact Orders
CREATE EXTERNAL TABLE gold_fact_orders
WITH (
    LOCATION = 'gold/fact_orders/',
    DATA_SOURCE = ToyStoreData,
    FILE_FORMAT = ParquetFormat
)
AS
SELECT
    order_id,
    created_at,
    YEAR(created_at) AS order_year,
    MONTH(created_at) AS order_month,
    website_session_id,
    user_id,
    primary_product_id,
    items_purchased,
    price_usd AS revenue,
    cogs_usd AS cogs,
    (price_usd - cogs_usd) AS gross_profit,
    CASE 
        WHEN price_usd = 0 THEN 0
        ELSE (price_usd - cogs_usd) / price_usd
    END AS profit_margin
FROM silver_orders;

-- Fact Sessions
CREATE EXTERNAL TABLE gold_fact_sessions
WITH (
    LOCATION = 'gold/fact_sessions/',
    DATA_SOURCE = ToyStoreData,
    FILE_FORMAT = ParquetFormat
)
AS
SELECT
    website_session_id,
    created_at,
    YEAR(created_at) AS session_year,
    MONTH(created_at) AS session_month,
    user_id,
    is_repeat_session,
    utm_source,
    utm_campaign,
    utm_content,
    device_type
FROM silver_sessions;

-- Fact Order Items
CREATE EXTERNAL TABLE gold_fact_order_items
WITH (
    LOCATION = 'gold/fact_order_items/',
    DATA_SOURCE = ToyStoreData,
    FILE_FORMAT = ParquetFormat
)
AS
SELECT
    order_item_id,
    order_id,
    product_id,
    is_primary_item,
    price_usd,
    cogs_usd,
    (price_usd - cogs_usd) AS item_profit
FROM silver_order_items;

-- Fact Refunds
CREATE EXTERNAL TABLE gold_fact_refunds
WITH (
    LOCATION = 'gold/fact_refunds/',
    DATA_SOURCE = ToyStoreData,
    FILE_FORMAT = ParquetFormat
)
AS
SELECT
    order_item_refund_id,
    order_item_id,
    order_id,
    refund_amount_usd
FROM silver_refunds;

-- DIMENSION TABLE

CREATE EXTERNAL TABLE gold_dim_products
WITH (
    LOCATION = 'gold/dim_products/',
    DATA_SOURCE = ToyStoreData,
    FILE_FORMAT = ParquetFormat
)
AS
SELECT
    product_id,
    product_name,
    created_at AS product_launch_date
FROM silver_products;