select ride_id, count(*) as cnt
from `local-tempo-493308-m1`.`citibike_dataset`.`stg_citibike__trips`
group by 1
having cnt > 1