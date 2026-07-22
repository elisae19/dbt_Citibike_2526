
    
    

with child as (
    select start_station_id as from_field
    from `local-tempo-493308-m1`.`citibike_dataset`.`fct_trips`
    where start_station_id is not null
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


