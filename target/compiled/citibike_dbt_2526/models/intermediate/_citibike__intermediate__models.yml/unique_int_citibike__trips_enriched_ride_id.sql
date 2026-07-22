
    
    

with dbt_test__target as (

  select ride_id as unique_field
  from `local-tempo-493308-m1`.`citibike_dataset`.`int_citibike__trips_enriched`
  where ride_id is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


