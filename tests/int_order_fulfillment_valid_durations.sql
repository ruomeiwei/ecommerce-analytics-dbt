select 
    order_id,
    approval_time_hours,
    processing_time_hours,
    delivery_time_hours,
    total_fulfillment_time_hours
from {{ ref('int_order_fulfillment') }}
where approval_time_hours < 0
   or processing_time_hours < 0
   or delivery_time_hours < 0
   or total_fulfillment_time_hours < 0