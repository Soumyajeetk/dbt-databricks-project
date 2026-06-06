with products as (
    select * from {{ ref('stg_products') }}
),

translations as (
    select * from {{ ref('stg_product_category_translations') }}
)

select
    p.product_id,
    coalesce(t.product_category_name_english, initcap(replace(p.product_category_name, '_', ' '))) as product_category_name
from products p
left join translations t on p.product_category_name = t.product_category_name