
import argparse
import os
import random
import time
from datetime import datetime
from decimal import Decimal
from getpass import getpass
from pathlib import Path

import psycopg2
from psycopg2.extras import execute_values


PAYMENT_METHODS = ["CARD", "CASH", "DIGITAL_WALLET", "GIFT_CARD"]


def load_env(path=".env"):
    if not Path(path).exists():
        return
    for line in Path(path).read_text().splitlines():
        if "=" in line and not line.strip().startswith("#"):
            key, value = line.split("=", 1)
            os.environ.setdefault(key.strip(), value.strip())


def get_reference_data(conn):
    with conn.cursor() as cur:
        cur.execute("SELECT store_id FROM stores")
        stores = [row[0] for row in cur.fetchall()]

        cur.execute("SELECT product_id, unit_price FROM products")
        products = cur.fetchall()

        cur.execute("SELECT customer_id FROM customers")
        customers = [row[0] for row in cur.fetchall()]

    if not stores or not products or not customers:
        raise RuntimeError("Reference data is missing.")

    return stores, products, customers


def generate_transaction(stores, products, customers):
    store_id = random.choice(stores)
    customer_id = random.choice(customers) if random.random() < 0.9 else None
    payment = random.choice(PAYMENT_METHODS)

    selected = random.sample(products, min(random.randint(1, 5), len(products)))
    items = []
    total = Decimal("0.00")

    for product_id, price in selected:
        quantity = random.randint(1, 3)
        line_total = price * quantity
        items.append((product_id, quantity, price, line_total))
        total += line_total

    return store_id, customer_id, total, payment, items


def insert_batch(conn, batch):
    with conn.cursor() as cur:
        headers = [
            (store_id, customer_id, total, payment)
            for store_id, customer_id, total, payment, _ in batch
        ]

        result = execute_values(
            cur,
            """
            INSERT INTO transactions
                (store_id, customer_id, total_amount, payment_method)
            VALUES %s
            RETURNING txn_id
            """,
            headers,
            fetch=True,
        )

        items = []
        for (txn_id,), transaction in zip(result, batch):
            for product_id, quantity, price, line_total in transaction[4]:
                items.append((txn_id, product_id, quantity, price, line_total))

        if items:
            execute_values(
                cur,
                """
                INSERT INTO transaction_items
                    (txn_id, product_id, quantity, unit_price, line_total)
                VALUES %s
                """,
                items,
            )

    conn.commit()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--transactions", type=int, default=100)
    parser.add_argument("--batch-size", type=int, default=50)
    args = parser.parse_args()

    if args.transactions <= 0 or args.batch_size <= 0:
        parser.error("Transactions and batch size must be positive.")

    load_env()
    password = getpass("PostgreSQL password: ")

    conn = psycopg2.connect(
        host=os.environ["PGHOST"],
        port=os.environ.get("PGPORT", "5432"),
        dbname=os.environ.get("PGDATABASE", "postgres"),
        user=os.environ.get("PGUSER", "snowflake_admin"),
        password=password,
        sslmode="require",
        connect_timeout=15,
    )

    try:
        stores, products, customers = get_reference_data(conn)
        print(f"Connected: {len(stores)} stores, {len(products)} products, {len(customers)} customers")

        generated = 0
        started = time.time()

        while generated < args.transactions:
            count = min(args.batch_size, args.transactions - generated)
            batch = [
                generate_transaction(stores, products, customers)
                for _ in range(count)
            ]
            insert_batch(conn, batch)
            generated += count

            print(
                f"[{datetime.now():%H:%M:%S}] "
                f"Inserted {generated}/{args.transactions} transactions"
            )

        print(f"Completed in {time.time() - started:.2f} seconds.")
        print("pg_cron will handle the Iceberg synchronization.")

    finally:
        conn.close()


if __name__ == "__main__":
    main()
