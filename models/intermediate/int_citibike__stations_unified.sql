{{
    config(
        materialized='table'
    )
}}
-- Regroupement des stations de départ et d'arrivée pour obtenir une seule ligne par station.

-- Au fil du temps, les stations peuvent légèrement dériver en lat/lng pour une même station_id (ex: 40.750, -73.993 vs 40.751, -73.992)
-- on prend alors l'observation la plus récente pour chaque station_id

with starts as (

    select
        start_station_id   as station_id,
        start_station_name as station_name,
        start_lat           as lat,
        start_lng           as lng,
        started_at           as observed_at

    from {{ ref('int_citibike__trips_deduplicated') }}

),

ends as (

    select
        end_station_id     as station_id,
        end_station_name   as station_name,
        end_lat             as lat,
        end_lng             as lng,
        ended_at             as observed_at

    from {{ ref('int_citibike__trips_deduplicated') }}

),

unioned as (

    select * from starts
    union all
    select * from ends

),

-- ranked permet de garder la dernière observation pour chaque station_id
ranked as (

    select
        *,
        row_number() over (
            partition by station_id
            order by observed_at desc
        ) as rn

    from unioned
    where station_id is not null

)

select
    station_id,
    station_name,
    lat,
    lng
from ranked
where rn = 1
