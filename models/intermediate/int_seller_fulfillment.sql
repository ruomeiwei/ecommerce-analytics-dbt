with order_sellers as (

    select distinct
        order_id,
        seller_id

    from {{ ref('stg_order_items') }}

),

fulfillment as (

    select *

    from {{ ref('int_order_fulfillment') }}

)

select

    order_sellers.order_id,
    order_sellers.seller_id,

    fulfillment.order_status,
    fulfillment.purchased_at,
    fulfillment.approved_at,
    fulfillment.delivered_to_carrier_at,
    fulfillment.delivered_to_customer_at,
    fulfillment.estimated_delivery_at,

    fulfillment.approval_time_hours,
    fulfillment.processing_time_hours,
    fulfillment.delivery_time_hours,
    fulfillment.total_fulfillment_time_hours,

    fulfillment.is_late,
    fulfillment.invalid_processing_time,
    fulfillment.invalid_delivery_time

from order_sellers

left join fulfillment
    on order_sellers.order_id = fulfillment.order_id