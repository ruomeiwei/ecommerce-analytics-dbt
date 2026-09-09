with seller_quartiles as (

    select
        seller_id,
        delivered_orders,
        late_orders,
        late_rate,
        avg_processing_time_hours,
        ntile(4) over (
            order by avg_processing_time_hours
        ) as processing_time_quartile

    from {{ ref('mart_seller_fulfillment') }}

    where is_eligible_for_ranking = 1
      and avg_processing_time_hours is not null

)

select
    processing_time_quartile,
    avg(avg_processing_time_hours) as avg_processing_time,
    avg(late_rate) as avg_late_rate,
    sum(delivered_orders) as delivered_orders,
    sum(late_orders) as late_orders

from seller_quartiles

group by processing_time_quartile

order by processing_time_quartile