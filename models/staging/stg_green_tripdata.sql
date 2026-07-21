with source as (
    select * from {{ source('raw_nyc_taxi', 'tlc_green_trips_2019') }}
),

renamed as (
    select
        -- ids
        vendor_id,
        pickup_location_id,
        dropoff_location_id,

        -- timestamps
        pickup_datetime,
        dropoff_datetime,

        -- trip info
        passenger_count,
        trip_distance,
        store_and_fwd_flag,
        rate_code,
        trip_type,

        -- payment
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        ehail_fee,
        imp_surcharge,
        total_amount,
        payment_type,

        -- service type (for unioning with yellow later)
        'green' as service_type

    from source
)

select * from renamed