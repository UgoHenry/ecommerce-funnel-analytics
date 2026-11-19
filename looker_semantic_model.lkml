explore: fact_pod_orders {
  label: "Print-on-Demand Orders & Fulfillment"
  join: dim_pod_customers {
    type: left_outer
    sql_on: ${fact_pod_orders.customer_id} = ${dim_pod_customers.customer_id} ;;
    relationship: many_to_one
  }
  join: dim_pod_products {
    type: left_outer
    sql_on: ${fact_pod_orders.product_id} = ${dim_pod_products.product_id} ;;
    relationship: many_to_one
  }
}

view: fact_pod_orders {
  sql_table_name: ANALYST.FACT_POD_ORDERS ;;

  dimension: order_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.ORDER_ID ;;
  }

  dimension_group: order_date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.ORDER_DATE ;;
  }

  measure: total_orders {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_item_revenue_eur {
    type: sum
    value_format_name: eur
    sql: ${TABLE}.ITEM_REVENUE_EUR ;;
  }

  measure: avg_fulfillment_days {
    type: average
    value_format_name: decimal_1
    sql: ${TABLE}.FULFILLMENT_DAYS ;;
  }
}