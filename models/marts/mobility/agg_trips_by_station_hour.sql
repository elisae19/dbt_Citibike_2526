{{
    config(
        materialized='table'
    )
}}

select
    start_station_id,
    start_hour,
    day_type,
    rider_type,

    count(*) as nb_departures,
    round(avg(trip_duration_minutes), 2) as avg_duration_minutes

from {{ ref('fct_trips') }}
group by 1, 2, 3, 4
