with orders as (
    select * from {{ ref('stg_orders') }}
)

select
    -- Identifiers
    order_id,
    customer_id,
    order_status,
    -- Pass-through flags from staging
    is_canceled,
    is_delivered,
    is_pending,
    -- Core Timestamps
    purchased_at,
    approved_at,
    delivered_to_carrier_at,
    delivered_to_customer_at,
    estimated_delivery_at,

    -- Metric 1: Approval Efficiency (Friction before order is accepted)
    -- Crucial for checking if long approval wait times cause customers to cancel!
    timestampdiff(HOUR, purchased_at, approved_at) as approval_delay_hours,

    -- Metric 2: Dispatch Speed (Friction at the seller warehouse)
    timestampdiff(DAY, approved_at, delivered_to_carrier_at) as dispatch_delay_days,

    -- Metric 3: Delivery Transit Time (Time spent in carrier hands)
    case 
        when is_delivered = 1 then timestampdiff(DAY, delivered_to_carrier_at, delivered_to_customer_at)
        else null 
    end as delivery_time_days,

    -- Metric 4: Delivery SLA Compliance (1 = On Time, 0 = Late)
    case 
        when is_delivered = 1 and delivered_to_customer_at <= estimated_delivery_at then 1
        when is_delivered = 1 and delivered_to_customer_at > estimated_delivery_at then 0
        else null -- Returns null for pending/canceled orders so it won't warp your SLA %
    end as delivery_accuracy_flag

from orders