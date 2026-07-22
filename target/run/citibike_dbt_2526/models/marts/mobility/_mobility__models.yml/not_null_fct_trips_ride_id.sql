
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select ride_id
from `local-tempo-493308-m1`.`citibike_dataset`.`fct_trips`
where ride_id is null



  
  
      
    ) dbt_internal_test