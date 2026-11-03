-- Snowflake Postgres + pg_lake Iceberg Catalog Integration
--
-- Purpose:
-- Connect Snowflake to Apache Iceberg tables managed
-- by pg_lake inside a Snowflake Postgres instance.
--
-- Prerequisites:
--   Snowflake Postgres instance: RETAIL_TXNS
--   pg_lake extension enabled
--   Apache Iceberg tables created in PostgreSQL
--
-- Execute in a Snowflake SQL Worksheet using ACCOUNTADMIN
-- or a role with the required privileges.

CREATE CATALOG INTEGRATION IF NOT EXISTS PG_LAKE_POSTGRES_CATALOG
    CATALOG_SOURCE = SNOWFLAKE_POSTGRES
    TABLE_FORMAT = ICEBERG
    CATALOG_NAMESPACE = 'public'
    REST_CONFIG = (
        POSTGRES_INSTANCE = 'RETAIL_TXNS'
        ACCESS_DELEGATION_MODE = VENDED_CREDENTIALS
        CATALOG_NAME = 'postgres'
    )
    ENABLED = TRUE;
