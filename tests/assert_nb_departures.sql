-- Total nb_trips in dim_stations should equal to total nb_trips in fct_trips

with fct_trips_total as (
    select 
        count(start_station_id) as total_dep
    from {{ ref('fct_trips') }}
),

dim_station_trips as (
    select 
        sum(nb_departures) as total_dep
    from {{ ref('dim_stations') }}
)

select
    fct_trips_total.total_dep as fct_trips_total,
    dim_station_trips.total_dep as dim_station_total
from fct_trips_total, dim_station_trips
where fct_trips_total.total_dep != dim_station_trips.total_dep