with staging_sellers as (
    select * from {{ ref('stg_sellers') }}
)

select
    seller_id,
    seller_city,
    seller_state
from staging_sellers