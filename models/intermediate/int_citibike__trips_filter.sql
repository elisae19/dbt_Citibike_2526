{{
    config(
        materialized='ephemeral'
    )
}}
-- Ce modèle ne crée pas de table , il est utilisé pour dédupliquer les trajets en cas de doublons dans la source.
-- on garde la première ligne (la plus ancienne) par ride_id au cas où il y aurait des doublons
-- ensuite ce modèle filtré sera utilisé par int_citibike__stations_unified et int_citibike__trips_enriched

with trips as (

    select * from {{ ref('stg_citibike__trips') }}

),

deduplicated as (

    select
        *,
        row_number() over (
            partition by ride_id
            order by started_at
        ) as rn

    from trips

),

-- Sert à filtrer les trajets hors de la période juillet 2025 à juin 2026
filter_date as (

    select * from deduplicated
    where started_at between '2025-07-01' and '2026-06-30'

),


-- Sert à filtrer les trajets qui ne sont pas dans la zone de NYC (ex: New Jersey, New Haven, etc.)
filter_nyc as (

    select * from filter_date
    where start_lat between 40.4 and 41.0
      and end_lat between 40.4 and 41.0
      and start_lng between -74.3 and -73.6
      and end_lng between -74.3 and -73.6

)

select * except(rn)
from filter_nyc
where rn = 1

