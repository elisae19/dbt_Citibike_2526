



select
    1
from `local-tempo-493308-m1`.`citibike_dataset`.`agg_trips_daily`

where not(nb_trips >= 0)

