

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