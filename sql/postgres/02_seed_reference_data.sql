-- Seed reference data for the retail OLTP database.
-- Run after 01_create_oltp_tables.sql.
-- Intended for a fresh database; rerunning may duplicate data.

INSERT INTO stores (store_name, city, state) VALUES
    ('Downtown Flagship', 'Seattle', 'WA'),
    ('Mall of Pacific', 'San Francisco', 'CA'),
    ('Eastside Express', 'Bellevue', 'WA'),
    ('Harbor Point', 'Portland', 'OR'),
    ('Valley Center', 'San Jose', 'CA');

INSERT INTO products (product_name, category, unit_price) VALUES
    ('Organic Coffee Beans 1lb', 'Grocery', 14.99),
    ('Wireless Earbuds Pro', 'Electronics', 79.99),
    ('Cotton T-Shirt', 'Apparel', 24.99),
    ('Stainless Water Bottle', 'Home', 19.99),
    ('Running Shoes', 'Footwear', 129.99),
    ('Yoga Mat Premium', 'Fitness', 39.99),
    ('LED Desk Lamp', 'Electronics', 44.99),
    ('Organic Protein Bar 12pk', 'Grocery', 29.99),
    ('Backpack 30L', 'Accessories', 59.99),
    ('Sunscreen SPF50', 'Personal Care', 12.99),
    ('Bluetooth Speaker', 'Electronics', 49.99),
    ('Trail Mix 2lb', 'Grocery', 9.99),
    ('Insulated Lunch Bag', 'Home', 22.99),
    ('Fitness Tracker Band', 'Electronics', 89.99),
    ('Bamboo Cutting Board', 'Home', 17.99);

INSERT INTO customers (first_name, last_name, email, loyalty_tier) VALUES
    ('Alice', 'Chen', 'alice.chen@example.com', 'GOLD'),
    ('Bob', 'Martinez', 'bob.martinez@example.com', 'SILVER'),
    ('Carol', 'Johnson', 'carol.j@example.com', 'BRONZE'),
    ('David', 'Kim', 'david.kim@example.com', 'GOLD'),
    ('Eve', 'Patel', 'eve.patel@example.com', 'PLATINUM'),
    ('Frank', 'Lopez', 'frank.lopez@example.com', 'BRONZE'),
    ('Grace', 'Wu', 'grace.wu@example.com', 'SILVER'),
    ('Hank', 'Brown', 'hank.brown@example.com', 'BRONZE'),
    ('Iris', 'Davis', 'iris.davis@example.com', 'GOLD'),
    ('Jack', 'Wilson', 'jack.wilson@example.com', 'SILVER');
