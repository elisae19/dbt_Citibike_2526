-- Total nb_trips in dim_stations should equal to total nb_trips in fct_trips

with fct_trips_total as (
    select 
        count(end_station_id) as total_arr
    from {{ ref('fct_trips') }}
),

dim_station_trips as (
    select 
        sum(nb_arrivals) as total_arr
    from {{ ref('dim_stations') }}
)

select
    fct_trips_total.total_arr as fct_trips_total,
    dim_station_trips.total_arr as dim_station_total
from fct_trips_total, dim_station_trips
where fct_trips_total.total_arr != dim_station_trips.total_arr