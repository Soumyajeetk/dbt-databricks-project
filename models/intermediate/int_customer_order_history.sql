with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('int_orders_operational_metrics') }}
),

-- Step 1: Join customers and orders to link the unique human identity to the operational behavior
joined_orders as (
    select
        c.customer_unique_id,
        o.order_id,
        o.customer_id,
        o.order_status,
        o.is_canceled,
        o.is_delivered,
        o.is_pending,
        o.purchased_at,
        o.approval_delay_hours,
        o.dispatch_delay_days,
        o.delivery_time_days,
        o.delivery_accuracy_flag
    from orders o
    join customers c on o.customer_id = c.customer_id
),

-- Step 2: Use window functions to look back at the customer's timeline
historical_timeline as (
    select
        *,
        -- Counts if this is the customer's 1st, 2nd, or 3rd order over time
        row_number() over (
            partition by customer_unique_id 
            order by purchased_at
        ) as customer_order_sequence,
        
        -- Tracks how many total times this customer canceled *before* placing this specific order
        coalesce(
            sum(is_canceled) over (
                partition by customer_unique_id 
                order by purchased_at 
                rows between unbounded preceding and 1 preceding
            ), 0
        ) as prior_lifetime_cancellations,

        -- Tracks how many late deliveries this customer experienced *before* placing this specific order
        coalesce(
            sum(case when delivery_accuracy_flag = 0 then 1 else 0 end) over (
                partition by customer_unique_id 
                order by purchased_at 
                rows between unbounded preceding and 1 preceding
            ), 0
        ) as prior_lifetime_late_deliveries

    from joined_orders 
)

select * from historical_timeline 