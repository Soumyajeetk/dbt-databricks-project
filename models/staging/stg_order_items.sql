WITH items AS (
    SELECT *
    FROM {{ source('olist', 'olist_order_items') }}
)

SELECT
    -- Identifiers
    order_id,
    order_item_id as item_sequence_number,
    product_id,
    seller_id,

    -- Shipping Deadline
    to_timestamp(shipping_limit_date) as shipping_limit_at,

    -- Financial Metrics
    cast(price as decimal(10,2)) as item_price,
    cast(freight_value as decimal(10,2)) as freight_value
FROM items
