
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with child as (
    select end_station_id as from_field
    from `local-tempo-493308-m1`.`citibike_dataset`.`fct_trips`
    where end_station_id is not null
),

parent as (
    select station_id as to_field
    from `local-tempo-493308-m1`.`citibike_dataset`.`dim_stations`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



  
  
      
    ) dbt_internal_test