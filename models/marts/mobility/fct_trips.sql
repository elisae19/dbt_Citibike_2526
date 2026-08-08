{{
    config(
        materialized='table',
        cluster_by=['start_station_id', 'member_type']
    )
}}

-- Grain: one row per Citibike trip

select
    ride_id,
    rideable_type,
    member_type,

    started_at,
    ended_at,
    trip_duration_minutes,

    start_station_id,
    end_station_id,
    is_round_trip,
    distance_km,

    start_day_of_week,
    start_hour,
    day_type

from {{ ref('int_citibike__trips_enriched') }}
