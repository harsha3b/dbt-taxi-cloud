select
    service_type,
    date_trunc(pickup_datetime, month)              as revenue_month,
    pickup_borough,

    -- volume
    count(*)                                        as trip_count,

    -- revenue breakdown
    sum(fare_amount)                                as revenue_fare,
    sum(extra)                                      as revenue_extra,
    sum(mta_tax)                                    as revenue_mta_tax,
    sum(tip_amount)                                 as revenue_tip,
    sum(tolls_amount)                               as revenue_tolls,
    sum(imp_surcharge)                              as revenue_improvement_surcharge,
    sum(total_amount)                               as revenue_total,

    -- averages
    avg(trip_distance)                              as avg_trip_distance_miles,
    avg(passenger_count)                            as avg_passenger_count,
    avg(trip_duration_minutes)                      as avg_trip_duration_minutes

from {{ ref('fact_trips') }}
group by 1, 2, 3