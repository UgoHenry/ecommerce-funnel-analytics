-- ==========================================================
-- 1. DIMENSION TABLES (The Points of the Star Schema)
-- ==========================================================

CREATE TABLE dim_pod_customers AS
SELECT DISTINCT
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
FROM olist_customers_dataset;

CREATE TABLE dim_pod_products AS
SELECT DISTINCT
    product_id,
    COALESCE(product_category_name, 'uncategorized') AS product_category,
    product_weight_g,
    product_length_cm
FROM olist_products_dataset;

-- ==========================================================
-- 2. FACT TABLE (The Center of the Star Schema)
-- Grain: 1 row per order line item
-- ==========================================================

CREATE TABLE fact_pod_orders AS
SELECT
    oi.order_id,
    oi.order_item_id,
    o.customer_id,
    oi.product_id,
    TRUNC(o.order_purchase_timestamp) AS order_date,
    oi.price AS item_revenue_eur,
    oi.freight_value AS shipping_cost_eur,
    ROUND(CAST(o.order_delivered_customer_date AS DATE) - CAST(o.order_purchase_timestamp AS DATE), 1) AS fulfillment_days
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi 
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

-- ==========================================================
-- 3. DATA QUALITY QA ASSERTIONS (Must return 0 rows to pass)
-- ==========================================================

SELECT 'DUPLICATE_ORDER_ITEM' AS qa_check, order_id || '-' || order_item_id AS failed_key
FROM fact_pod_orders
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1

UNION ALL

SELECT 'INVALID_REVENUE' AS qa_check, order_id AS failed_key
FROM fact_pod_orders
WHERE item_revenue_eur IS NULL OR item_revenue_eur <= 0

UNION ALL

SELECT 'ORPHAN_CUSTOMER_FK' AS qa_check, f.order_id AS failed_key
FROM fact_pod_orders f
LEFT JOIN dim_pod_customers c ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL;