WITH orders AS (
    SELECT *
    FROM {{ source('olist', 'olist_orders') }}
)

select
    -- Identifiers
    order_id,
    customer_id,

    -- Order Status
    order_status,

    -- Operational Flags (1/0 format for easy aggregation downstream)
    case when order_status = 'canceled' then 1 else 0 end as is_canceled,
    case when order_status = 'delivered' then 1 else 0 end as is_delivered,
    case when order_status in ('processing', 'approved', 'unshipped') then 1 else 0 end as is_pending,

    -- Timestamps (Casting raw string fields to proper Databricks timestamps)
    to_timestamp(order_purchase_timestamp) as purchased_at,
    to_timestamp(order_approved_at) as approved_at,
    to_timestamp(order_delivered_carrier_date) as delivered_to_carrier_at,
    to_timestamp(order_delivered_customer_date) as delivered_to_customer_at,
    to_timestamp(order_estimated_delivery_date) as estimated_delivery_at

from orders