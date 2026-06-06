with product_category_translations as (
    select * from {{ source('olist', 'product_category_name_translation') }}
)
select
    product_category_name,
    -- Clean up formatting to look professional (e.g., replacement of underscores)
    initcap(replace(product_category_name_english, '_', ' ')) as product_category_name_english
from product_category_translations