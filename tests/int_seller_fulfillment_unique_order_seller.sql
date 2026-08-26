select
    order_id,
    seller_id,
    count(*) as row_count

from {{ ref('int_seller_fulfillment') }}

group by
    order_id,
    seller_id

having count(*) > 1