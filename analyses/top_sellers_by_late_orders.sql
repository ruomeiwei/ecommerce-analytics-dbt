select 
    seller_id,
    delivered_orders,
    late_orders,
    late_rate,
    seller_late_rate_rank
from {{ ref('mart_seller_fulfillment') }}
where is_eligible_for_ranking = 1
order by late_orders desc
limit 20