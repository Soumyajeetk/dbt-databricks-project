WITH customers AS (
    SELECT *
    FROM {{ source('olist', 'olist_customers') }}
)

SELECT 
    -- Identifiers
    customer_id,          -- Maps 1:1 to the individual order
    customer_unique_id,   -- Tracks the actual individual customer across multiple lifetime orders

    -- Geography (Standardized text formatting)
    customer_zip_code_prefix as zip_code_prefix,
    initcap(customer_city) as city,
    upper(customer_state) as state
FROM customers 