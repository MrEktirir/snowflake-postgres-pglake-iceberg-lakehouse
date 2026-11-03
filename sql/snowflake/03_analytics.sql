-- Snowflake Analytics Queries
-- Project: Snowflake Postgres + pg_lake + Apache Iceberg
--
-- Database: PG_LAKE_ANALYTICS
-- Schema: PUBLIC
--
-- All queries operate on Apache Iceberg tables
-- registered through the Snowflake Postgres catalog integration.


-- ============================================================
-- 1. STORE SALES PERFORMANCE
-- ============================================================

SELECT
    s.STORE_NAME,
    s.CITY,
    COUNT(t.TXN_ID) AS TOTAL_TRANSACTIONS,
    ROUND(SUM(t.TOTAL_AMOUNT), 2) AS TOTAL_REVENUE,
    ROUND(AVG(t.TOTAL_AMOUNT), 2) AS AVG_TRANSACTION_VALUE
FROM PG_LAKE_ANALYTICS.PUBLIC.ICEBERG_TRANSACTIONS t
JOIN PG_LAKE_ANALYTICS.PUBLIC.ICEBERG_STORES s
    ON t.STORE_ID = s.STORE_ID
GROUP BY
    s.STORE_NAME,
    s.CITY
ORDER BY TOTAL_REVENUE DESC;


-- ============================================================
-- 2. PRODUCT CATEGORY PERFORMANCE
-- ============================================================

SELECT
    p.CATEGORY,
    COUNT(DISTINCT i.TXN_ID) AS TRANSACTIONS,
    SUM(i.QUANTITY) AS UNITS_SOLD,
    ROUND(SUM(i.LINE_TOTAL), 2) AS TOTAL_REVENUE
FROM PG_LAKE_ANALYTICS.PUBLIC.ICEBERG_TRANSACTION_ITEMS i
JOIN PG_LAKE_ANALYTICS.PUBLIC.ICEBERG_PRODUCTS p
    ON i.PRODUCT_ID = p.PRODUCT_ID
GROUP BY
    p.CATEGORY
ORDER BY TOTAL_REVENUE DESC;


-- ============================================================
-- 3. TOP 10 PRODUCTS BY REVENUE
-- ============================================================

SELECT
    p.PRODUCT_NAME,
    p.CATEGORY,
    SUM(i.QUANTITY) AS UNITS_SOLD,
    ROUND(SUM(i.LINE_TOTAL), 2) AS TOTAL_REVENUE
FROM PG_LAKE_ANALYTICS.PUBLIC.ICEBERG_TRANSACTION_ITEMS i
JOIN PG_LAKE_ANALYTICS.PUBLIC.ICEBERG_PRODUCTS p
    ON i.PRODUCT_ID = p.PRODUCT_ID
GROUP BY
    p.PRODUCT_NAME,
    p.CATEGORY
ORDER BY TOTAL_REVENUE DESC
LIMIT 10;
