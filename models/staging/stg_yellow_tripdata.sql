with source as (
    select * from {{ source('raw_nyc_taxi', 'tlc_yellow_trips_2019') }}
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
        --cast(1 as int64)    as trip_type,   -- yellow has no trip_type; default to 1 (street hail)
        cast(1 as string)   as trip_type,  
        -- yellow has no trip_type; default to 1 (street hail) cast as string because green trip has trip_type as string

        -- payment
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        cast(null as numeric) as ehail_fee,  -- yellow has no ehail_fee
        imp_surcharge,
        total_amount,
        payment_type,

        'yellow' as service_type

    from source
)

select * from renamed