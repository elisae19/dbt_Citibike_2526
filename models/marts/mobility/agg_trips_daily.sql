{{
    config(
        materialized='table'
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['started_at', 'rideable_type', 'member_type', 'day_type']) }} as trips_by_day_id,
    date(started_at)     as trip_date,
    rideable_type,
    member_type,
    day_type,

    count(*)                            as nb_trips,
    round(avg(trip_duration_minutes), 2) as avg_duration_minutes,
    round(avg(distance_km), 2)           as avg_distance_km,
    countif(is_round_trip)               as nb_round_trips

from {{ ref('fct_trips') }}
group by 1, 2, 3, 4, 5
