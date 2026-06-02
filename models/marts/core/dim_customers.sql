with customer_geo as (
    select 
        customer_unique_id,
        city,
        state,
        zip_code_prefix,
        -- Grabs their most recent order's address in case they moved
        row_number() over (
            partition by customer_unique_id 
            order by customer_id desc
        ) as row_num
    from {{ ref('stg_customers') }}
),

unique_customers_geo as (
    select * from customer_geo where row_num = 1
),

customer_orders as (
    select 
        c.customer_unique_id,
        o.order_id,
        o.is_canceled,
        o.approval_delay_hours,
        o.dispatch_delay_days,
        o.delivery_time_days,
        o.delivery_accuracy_flag
    from {{ ref('int_orders_operational_metrics') }} o
    join {{ ref('stg_customers') }} c on o.customer_id = c.customer_id
),

customer_aggregates as (
    select
        customer_unique_id,
        count(distinct order_id) as total_lifetime_orders,
        sum(is_canceled) as total_lifetime_cancellations,
        cast(avg(approval_delay_hours) as decimal (10,2)) as avg_lifetime_approval_delay_hours,
        cast(avg(dispatch_delay_days)as decimal (10,2)) as avg_lifetime_dispatch_delay_days,
        cast(avg(delivery_time_days)as decimal (10,2)) as avg_lifetime_delivery_time_days,
        cast(avg(delivery_accuracy_flag)as decimal (10,2)) as lifetime_delivery_sla_compliance_rate
    from customer_orders
    group by 1
)


select
    -- 1. Unique Primary Key (Grain: One row per unique customer identity)
    geo.customer_unique_id,

    -- 2. Geographic Attributes (For regional filtering in Power BI)
    geo.zip_code_prefix,
    geo.city,
    geo.state,

    -- 3. Lifetime Behavioral Aggregates
    coalesce(agg.total_lifetime_orders, 0) as total_lifetime_orders,
    coalesce(agg.total_lifetime_cancellations, 0) as total_lifetime_cancellations,
    agg.avg_lifetime_approval_delay_hours,
    agg.avg_lifetime_dispatch_delay_days,
    agg.avg_lifetime_delivery_time_days,
    agg.lifetime_delivery_sla_compliance_rate,

    -- 4. Analytical Customer Segment Flag
    case 
        when agg.total_lifetime_orders > 1 then 'Repeat Buyer'
        else 'One-Time Buyer'
    end as customer_loyalty_segment

from unique_customers_geo geo
left join customer_aggregates agg 
    on geo.customer_unique_id = agg.customer_unique_id
) 