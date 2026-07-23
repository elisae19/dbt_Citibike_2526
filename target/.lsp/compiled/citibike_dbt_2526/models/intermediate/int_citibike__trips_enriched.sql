with __dbt__cte__int_citibike__trips_deduplicated as (


-- Les exports mensuels concaténés peuvent se chevaucher sur les bornes
-- de date : on garde une seule ligne par ride_id.

with trips as (

    select * from `local-tempo-493308-m1`.`citibike_dataset`.`stg_citibike__trips`

),

deduplicated as (

    select
        *,
        row_number() over (
            partition by ride_id
            order by started_at
        ) as rn

    from trips

)

select * except(rn)
from deduplicated
where rn = 1
)
--EPHEMERAL-SELECT-WRAPPER-START
select * from (


with trips as (

    select * from __dbt__cte__int_citibike__trips_deduplicated

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
        



    

    2 * 3961 * asin(sqrt(power(sin((acos(-1) * end_lat / 180 - acos(-1) * start_lat / 180) / 2), 2) +
    cos(acos(-1) * start_lat / 180) * cos(acos(-1) * end_lat / 180) *
    power(sin((acos(-1) * end_lng / 180 - acos(-1) * start_lng / 180) / 2), 2))) * 1.60934 as distance_km

    from trips

)

select *
from enriched
-- on écarte les trajets aberrants (erreurs de capteur/station coupée)
where trip_duration_minutes > 0
  and trip_duration_minutes < 1440
--EPHEMERAL-SELECT-WRAPPER-END
)