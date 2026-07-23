
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        member_casual as value_field,
        count(*) as n_records

    from `local-tempo-493308-m1`.`citibike_dataset`.`dev_Citibike2526`
    group by member_casual

)

select *
from all_values
where value_field not in (
    'member','casual'
)



  
  
      
    ) dbt_internal_test