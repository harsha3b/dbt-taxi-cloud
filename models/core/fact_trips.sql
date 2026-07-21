with green_data as (
    select * from {{ ref('stg_green_tripdata') }}
),

yellow_data as (
    select * from {{ ref('stg_yellow_tripdata') }}
),

trips_unioned as (
    select * from green_data
    union all
    select * from yellow_data
),

dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
),

final as (
    select
        -- identifiers
        trips_unioned.vendor_id,
        trips_unioned.service_type,
        trips_unioned.pickup_location_id,
        trips_unioned.dropoff_location_id,

        -- timestamps
        trips_unioned.pickup_datetime,
        trips_unioned.dropoff_datetime,
        timestamp_diff(
            trips_unioned.dropoff_datetime,
            trips_unioned.pickup_datetime,
            minute
        )                                           as trip_duration_minutes,

        -- trip details
        trips_unioned.passenger_count,
        trips_unioned.trip_distance,
        trips_unioned.trip_type,
        trips_unioned.payment_type,

        -- enriched zone info (role-playing dimension — pickup)
        pickup_zone.borough                         as pickup_borough,
        pickup_zone.zone                            as pickup_zone,
        pickup_zone.service_zone                    as pickup_service_zone,

        -- enriched zone info (role-playing dimension — dropoff)
        dropoff_zone.borough                        as dropoff_borough,
        dropoff_zone.zone                           as dropoff_zone,
        dropoff_zone.service_zone                   as dropoff_service_zone,

        -- financials
        trips_unioned.fare_amount,
        trips_unioned.extra,
        trips_unioned.mta_tax,
        trips_unioned.tip_amount,
        trips_unioned.tolls_amount,
        trips_unioned.imp_surcharge,
        trips_unioned.total_amount

    from trips_unioned
    inner join dim_zones as pickup_zone
        on trips_unioned.pickup_location_id = pickup_zone.location_id
    inner join dim_zones as dropoff_zone
        on trips_unioned.dropoff_location_id = dropoff_zone.location_id
)

select * from final