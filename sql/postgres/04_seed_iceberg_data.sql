-- Seed Apache Iceberg dimension tables from PostgreSQL OLTP.
--
-- Prerequisites:
--   01_create_oltp_tables.sql
--   02_seed_reference_data.sql
--   03_create_iceberg_tables.sql
--
-- Run once on a freshly initialized lakehouse.
-- Repeated execution may duplicate records.

-- 1. Stores
INSERT INTO iceberg_stores (
    store_id,
    store_name,
    city,
    state,
    opened_at
)
SELECT
    store_id,
    store_name,
    city,
    state,
    opened_at
FROM stores;

-- 2. Products
INSERT INTO iceberg_products (
    product_id,
    product_name,
    category,
    unit_price,
    created_at
)
SELECT
    product_id,
    product_name,
    category,
    unit_price,
    created_at
FROM products;

-- 3. Customers
INSERT INTO iceberg_customers (
    customer_id,
    first_name,
    last_name,
    email,
    loyalty_tier,
    created_at
)
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    loyalty_tier,
    created_at
FROM customers;
