-- PostgreSQL OLTP schema
-- Source: Snowflake Postgres + pg_lake retail lakehouse project

CREATE TABLE IF NOT EXISTS stores (
    store_id    SERIAL PRIMARY KEY,
    store_name  TEXT NOT NULL,
    city        TEXT NOT NULL,
    state       TEXT NOT NULL,
    opened_at   TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS products (
    product_id    SERIAL PRIMARY KEY,
    product_name  TEXT NOT NULL,
    category      TEXT NOT NULL,
    unit_price    NUMERIC(10,2) NOT NULL,
    created_at    TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id   SERIAL PRIMARY KEY,
    first_name    TEXT NOT NULL,
    last_name     TEXT NOT NULL,
    email         TEXT UNIQUE NOT NULL,
    loyalty_tier  TEXT DEFAULT 'BRONZE',
    created_at    TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS transactions (
    txn_id         SERIAL PRIMARY KEY,
    store_id       INT NOT NULL REFERENCES stores(store_id),
    customer_id    INT REFERENCES customers(customer_id),
    txn_timestamp  TIMESTAMP NOT NULL DEFAULT now(),
    total_amount   NUMERIC(12,2) NOT NULL DEFAULT 0,
    payment_method TEXT NOT NULL DEFAULT 'CARD',
    synced_at      TIMESTAMP
);

CREATE TABLE IF NOT EXISTS transaction_items (
    item_id       SERIAL PRIMARY KEY,
    txn_id        INT NOT NULL REFERENCES transactions(txn_id),
    product_id    INT NOT NULL REFERENCES products(product_id),
    quantity      INT NOT NULL DEFAULT 1,
    unit_price    NUMERIC(10,2) NOT NULL,
    line_total    NUMERIC(12,2) NOT NULL,
    synced_at     TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_txn_synced
    ON transactions(synced_at)
    WHERE synced_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_items_synced
    ON transaction_items(synced_at)
    WHERE synced_at IS NULL;
