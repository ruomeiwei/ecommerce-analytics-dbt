select
    seller_id,
    delivered_orders,
    late_rate,
    avg_processing_time_hours
from {{ ref('mart_seller_fulfillment') }}
where is_eligible_for_ranking = 1
  and avg_processing_time_hours is not null
  and late_rate is not null