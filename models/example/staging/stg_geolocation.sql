WITH geo AS (
    SELECT *
    FROM {{ source('olist', 'olist_geolocation') }}
)

SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
FROM geo
