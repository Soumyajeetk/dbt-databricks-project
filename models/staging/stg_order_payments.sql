WITH payments AS (
    SELECT *
    FROM {{ source('olist', 'olist_order_payments') }}
)

SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM payments
