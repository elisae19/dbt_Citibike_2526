
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select started_at
from `local-tempo-493308-m1`.`citibike_dataset`.`dev_Citibike2526`
where started_at is null



  
  
      
    ) dbt_internal_test