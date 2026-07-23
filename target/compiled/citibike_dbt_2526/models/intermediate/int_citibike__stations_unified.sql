
-- Regroupement des stations de départ et d'arrivée pour obtenir une seule ligne par station.

-- Au fil du temps, les stations peuvent légèrement dériver en lat/lng pour une même station_id (ex: 40.750, -73.993 vs 40.751, -73.992)
-- on prend alors l'observation la plus récente pour chaque station_id

with  __dbt__cte__int_citibike__trips_deduplicated as (

-- Ce modèle ne crée pas de table , il est utilisé pour dédupliquer les trajets en cas de doublons dans la source.
-- on garde la première ligne (la plus ancienne) par ride_id au cas où il y aurait des doublons
-- ensuite ce modèle filtré sera utilisé par int_citibike__stations_unified et int_citibike__trips_enriched

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

),

-- La CTE suivante n'est pas utilisée dans le modèle final, elle sert juste à tester qu'il n'y a pas de doublons
deduplicate_test as (

    select * from deduplicated
    where rn > 1

)

select * except(rn)
from deduplicated
where rn = 1
), starts as (

    select
        start_station_id   as station_id,
        start_station_name as station_name,
        start_lat           as lat,
        start_lng           as lng,
        started_at           as observed_at

    from __dbt__cte__int_citibike__trips_deduplicated

),

ends as (

    select
        end_station_id     as station_id,
        end_station_name   as station_name,
        end_lat             as lat,
        end_lng             as lng,
        ended_at             as observed_at

    from __dbt__cte__int_citibike__trips_deduplicated

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