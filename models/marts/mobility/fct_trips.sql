{{
    config(
        materialized='incremental',
        incremental_strategy='insert_overwrite',
        partition_by={
            "field": "started_at",
            "data_type": "timestamp",
            "granularity": "month"
        },
        cluster_by=["start_station_id", "rider_type"]
    )
}}

select
    ride_id,
    rideable_type,
    rider_type,

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

{% if is_incremental() %}
where started_at > (select max(started_at) from {{ this }})
{% endif %}
