
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