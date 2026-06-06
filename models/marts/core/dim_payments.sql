with staging_payments as (
    select * from {{ ref('stg_order_payments') }}
)

select
    -- Creating a unique surrogate key for each payment row
    md5(concat(order_id, '_', cast(payment_sequential as string))) as payment_key,
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
from staging_payments