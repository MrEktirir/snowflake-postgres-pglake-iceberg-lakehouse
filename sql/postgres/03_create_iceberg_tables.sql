-- Apache Iceberg tables managed through pg_lake.
-- Execute against Snowflake Postgres after installing pg_lake.
--
-- Prerequisites:
--   CREATE EXTENSION IF NOT EXISTS pg_lake CASCADE;
--
-- The Iceberg storage location is determined by the
-- PostgreSQL instance configuration.

CREATE TABLE IF NOT EXISTS iceberg_stores (
    store_id    INT,
    store_name  TEXT,
    city        TEXT,
    state       TEXT,
    opened_at   TIMESTAMP
) USING iceberg;

CREATE TABLE IF NOT EXISTS iceberg_products (
    product_id    INT,
    product_name  TEXT,
    category      TEXT,
    unit_price    NUMERIC(10,2),
    created_at    TIMESTAMP
) USING iceberg;

CREATE TABLE IF NOT EXISTS iceberg_customers (
    customer_id   INT,
    first_name    TEXT,
    last_name     TEXT,
    email         TEXT,
    loyalty_tier  TEXT,
    created_at    TIMESTAMP
) USING iceberg;

CREATE TABLE IF NOT EXISTS iceberg_transactions (
    txn_id         INT,
    store_id       INT,
    customer_id    INT,
    txn_timestamp  TIMESTAMP,
    total_amount   NUMERIC(12,2),
    payment_method TEXT
) USING iceberg;

CREATE TABLE IF NOT EXISTS iceberg_transaction_items (
    item_id     INT,
    txn_id      INT,
    product_id  INT,
    quantity    INT,
    unit_price  NUMERIC(10,2),
    line_total  NUMERIC(12,2)
) USING iceberg;
