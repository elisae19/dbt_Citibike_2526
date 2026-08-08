{{
    config(
        materialized='table'
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['start_station_id', 'start_hour', 'day_type', 'member_type']) }} as trips_by_station_hour_id,
    start_station_id,
    start_hour,
    day_type,
    member_type,

    count(*) as nb_departures,
    round(avg(trip_duration_minutes), 2) as avg_duration_minutes

from {{ ref('fct_trips') }}
group by 1, 2, 3, 4, 5
