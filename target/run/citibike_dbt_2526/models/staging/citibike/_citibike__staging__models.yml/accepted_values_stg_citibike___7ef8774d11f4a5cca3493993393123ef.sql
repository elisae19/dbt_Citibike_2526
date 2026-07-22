
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        rideable_type as value_field,
        count(*) as n_records

    from `local-tempo-493308-m1`.`citibike_dataset`.`stg_citibike__trips`
    group by rideable_type

)

select *
from all_values
where value_field not in (
    'classic_bike','electric_bike','docked_bike'
)



  
  
      
    ) dbt_internal_test