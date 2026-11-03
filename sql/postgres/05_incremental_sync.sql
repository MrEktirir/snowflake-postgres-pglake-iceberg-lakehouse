-- Incremental PostgreSQL OLTP -> Apache Iceberg synchronization.
--
-- Requires:
--   pg_cron extension
--   OLTP and Iceberg tables created previously
--
-- Schedule: every minute
-- Tracking column: synced_at

CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Transaction headers
SELECT cron.schedule(
    'sync_txn_headers',
    '* * * * *',
    $job$
    WITH pending AS (
        SELECT *
        FROM transactions
        WHERE synced_at IS NULL
    ),
    inserted AS (
        INSERT INTO iceberg_transactions (
            txn_id,
            store_id,
            customer_id,
            txn_timestamp,
            total_amount,
            payment_method
        )
        SELECT
            txn_id,
            store_id,
            customer_id,
            txn_timestamp,
            total_amount,
            payment_method
        FROM pending
        RETURNING txn_id
    )
    UPDATE transactions t
    SET synced_at = NOW()
    FROM inserted i
    WHERE t.txn_id = i.txn_id;
    $job$
);

-- Transaction line items
SELECT cron.schedule(
    'sync_txn_items',
    '* * * * *',
    $job$
    WITH pending AS (
        SELECT *
        FROM transaction_items
        WHERE synced_at IS NULL
    ),
    inserted AS (
        INSERT INTO iceberg_transaction_items (
            item_id,
            txn_id,
            product_id,
            quantity,
            unit_price,
            line_total
        )
        SELECT
            item_id,
            txn_id,
            product_id,
            quantity,
            unit_price,
            line_total
        FROM pending
        RETURNING item_id
    )
    UPDATE transaction_items t
    SET synced_at = NOW()
    FROM inserted i
    WHERE t.item_id = i.item_id;
    $job$
);
