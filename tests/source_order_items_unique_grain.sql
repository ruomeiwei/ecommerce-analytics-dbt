select
    order_id,
    order_item_id
from {{ source("ecommerce_raw", "order_items") }}
group by 1, 2 
having count(*) > 1