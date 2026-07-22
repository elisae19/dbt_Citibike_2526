
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select station_id
from `local-tempo-493308-m1`.`citibike_dataset`.`int_citibike__stations_unified`
where station_id is null



  
  
      
    ) dbt_internal_test