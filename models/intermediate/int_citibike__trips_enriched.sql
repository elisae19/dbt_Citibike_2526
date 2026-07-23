{{
    config(
        materialized='table',
        partition_by={
            "field": "started_at",
            "data_type": "timestamp",
            "granularity": "month"
        },
        cluster_by=["start_station_id", "rider_type"]
    )
}}

with trips as (

    select * from {{ ref('int_citibike__trips_deduplicated') }}

),

enriched as (

    select
        *,

        timestamp_diff(ended_at, started_at, second) / 60.0   as trip_duration_minutes,

        (start_station_id = end_station_id)                   as is_round_trip,

        extract(dayofweek from started_at)                     as start_day_of_week,
        extract(hour from started_at)                           as start_hour,

        case
            when extract(dayofweek from started_at) in (1, 7) then 'weekend'
            else 'weekday'
        end as day_type,

        -- distance haversine approximative en km
        {{ dbt_utils.haversine_distance(
            'start_lat',
            'start_lng',
            'end_lat',
            'end_lng',
            'km'
        ) }} as distance_km

    from trips

)

select *
from enriched
-- on écarte les trajets aberrants (erreurs de capteur/station coupée)
where trip_duration_minutes > 0
  and trip_duration_minutes < 1440
