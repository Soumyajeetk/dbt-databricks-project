with order_items as (
    select * from {{ ref('stg_order_items') }}
),

customer_order_history as (
    select * from {{ ref('int_customer_order_history') }}
)

select
    -- 1. Unique Surrogate Key (Grain: One row per unique item inside an order)
    md5(concat(items.order_id, '_', items.item_sequence_number)) as order_item_key,
    
    -- 2. Dimensional Foreign Keys (For linking to dimension tables in Power BI)
    items.order_id,
    items.item_sequence_number,
    items.product_id,
    items.seller_id,
    cust.customer_unique_id,

    -- 3. Order Status & Timestamps
    cust.order_status,
    cust.purchased_at,
    items.shipping_limit_at,

    -- 4. Financial Metrics (At the Item Grain)
    items.item_price,
    items.freight_value,
    (items.item_price + items.freight_value) as total_item_cost,

    -- 5. Operational Logistics Metrics (Inherited from Order Level)
    cust.approval_delay_hours,
    cust.dispatch_delay_days,
    cust.delivery_time_days,
    cust.delivery_accuracy_flag,

    -- 6. Behavioral Metrics (Looking back at customer's history)
    cust.customer_order_sequence,
    cust.prior_lifetime_cancellations,
    cust.prior_lifetime_late_deliveries,
    
    -- 7. High-Level Core Status Flags
    cust.is_canceled,
    cust.is_delivered,
    cust.is_pending

from order_items items
inner join customer_order_history cust 
    on items.order_id = cust.order_id