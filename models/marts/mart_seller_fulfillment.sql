with seller_fulfillment as (

    select *

    from {{ ref('int_seller_fulfillment') }}

),

seller_metrics as (

    select

        seller_id,

        count(distinct order_id) as orders_received,

        count(distinct case
            when order_status = 'delivered' then order_id
        end) as delivered_orders,

        count(distinct case
            when is_late = 1 then order_id
        end) as late_orders,

        safe_divide(
            count(distinct case
                when is_late = 1 then order_id
            end),
            count(distinct case
                when order_status = 'delivered' then order_id
            end)
        ) as late_rate,

        avg(processing_time_hours) as avg_processing_time_hours,

        avg(delivery_time_hours) as avg_delivery_time_hours

    from seller_fulfillment

    group by seller_id

),

eligible_sellers as (

    select

        *,
        rank() over (
            order by late_rate desc
        ) as seller_late_rate_rank

    from seller_metrics

    where delivered_orders >= 30

),

final as (

    select

        seller_metrics.seller_id,
        seller_metrics.orders_received,
        seller_metrics.delivered_orders,
        seller_metrics.late_orders,
        seller_metrics.late_rate,
        seller_metrics.avg_processing_time_hours,
        seller_metrics.avg_delivery_time_hours,

        case
            when seller_metrics.delivered_orders >= 30 then 1
            else 0
        end as is_eligible_for_ranking,

        eligible_sellers.seller_late_rate_rank

    from seller_metrics

    left join eligible_sellers
        on seller_metrics.seller_id = eligible_sellers.seller_id

)

select *

from final