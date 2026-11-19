SELECT
    COUNT(order_id) AS step_1_orders_placed,
    COUNT(order_approved_at) AS step_2_payment_approved,
    ROUND(100.0 * COUNT(order_approved_at) / COUNT(order_id), 2) AS approved_pct,
    COUNT(order_delivered_carrier_date) AS step_3_shipped_to_carrier,
    ROUND(100.0 * COUNT(order_delivered_carrier_date) / NULLIF(COUNT(order_approved_at), 0), 2) AS shipped_pct,
    COUNT(order_delivered_customer_date) AS step_4_delivered_to_customer,
    ROUND(100.0 * COUNT(order_delivered_customer_date) / NULLIF(COUNT(order_delivered_carrier_date), 0), 2) AS delivered_pct
FROM olist_orders_dataset;

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT f.order_id) AS total_orders,
        ROUND(SUM(f.item_revenue_eur), 2) AS lifetime_revenue_eur,
        ROUND(AVG(f.fulfillment_days), 1) AS avg_delivery_days
    FROM fact_pod_orders f
    JOIN dim_pod_customers c 
        ON f.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    CASE 
        WHEN total_orders = 1 THEN '1_One_Time_Buyer'
        WHEN total_orders = 2 THEN '2_Repeat_Buyer_(2_Orders)'
        ELSE '3_VIP_Loyalist_(3+_Orders)'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_customers,
    ROUND(SUM(lifetime_revenue_eur), 2) AS total_segment_revenue,
    ROUND(AVG(avg_delivery_days), 1) AS avg_delivery_days
FROM customer_orders
GROUP BY 
    CASE 
        WHEN total_orders = 1 THEN '1_One_Time_Buyer'
        WHEN total_orders = 2 THEN '2_Repeat_Buyer_(2_Orders)'
        ELSE '3_VIP_Loyalist_(3+_Orders)'
    END
ORDER BY customer_segment;