with orders as (
    select *
    from {{ ref('stg_orders') }}
)

select 
    order_id,
    customer_id,
    order_status,
    purchased_at,
    approved_at,
    delivered_to_carrier_at,
    delivered_to_customer_at,
    estimated_delivery_at,
    timestamp_diff(approved_at, purchased_at, hour) as approval_time_hours,
    case
        when delivered_to_carrier_at < approved_at then null
        else timestamp_diff(
            delivered_to_carrier_at,
            approved_at,
            minute
        ) / 60.0
    end as processing_time_hours,
    case
        when delivered_to_customer_at < delivered_to_carrier_at then null
        else timestamp_diff(
            delivered_to_customer_at,
            delivered_to_carrier_at,
            minute
        ) / 60.0
    end as delivery_time_hours,
    timestamp_diff(delivered_to_customer_at, purchased_at, hour) as total_fulfillment_time_hours,
    case 
        when delivered_to_customer_at is null then null
        when estimated_delivery_at is null then null
        when delivered_to_customer_at >  estimated_delivery_at then 1 
        else 0 
    end as is_late,
    case
        when delivered_to_carrier_at < approved_at then 1
        else 0
    end as invalid_processing_time,
    case
        when delivered_to_customer_at < delivered_to_carrier_at then 1
        else 0
    end as invalid_delivery_time
from orders

