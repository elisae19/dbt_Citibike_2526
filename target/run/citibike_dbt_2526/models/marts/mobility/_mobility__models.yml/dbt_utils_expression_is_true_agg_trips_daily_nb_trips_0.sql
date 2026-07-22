
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from `local-tempo-493308-m1`.`citibike_dataset`.`agg_trips_daily`

where not(nb_trips >= 0)


  
  
      
    ) dbt_internal_test