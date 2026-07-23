
  
    

    create or replace table `local-tempo-493308-m1`.`citibike_dataset`.`agg_trips_by_station_hour`
      
    
    

    
    OPTIONS()
    as (
      

select
    start_station_id,
    start_hour,
    day_type,
    rider_type,

    count(*) as nb_departures,
    round(avg(trip_duration_minutes), 2) as avg_duration_minutes

from `local-tempo-493308-m1`.`citibike_dataset`.`fct_trips`
group by 1, 2, 3, 4
    );
  