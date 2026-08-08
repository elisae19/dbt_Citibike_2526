{{
    config(
        materialized='table'
    )
}}

with stations as (

    select * from {{ ref('int_citibike__stations_unified') }}

),

trips as (

    select * from {{ ref('int_citibike__trips_enriched') }}

),

departures as (

    select
        start_station_id as station_id,
        count(*)          as nb_departures
    from trips
    group by 1

),

arrivals as (

    select
        end_station_id   as station_id,
        count(*)          as nb_arrivals
    from trips
    group by 1

)

select
    s.station_id,
    s.station_name,
    s.lat,
    s.lng,
    coalesce(d.nb_departures, 0) as nb_departures,
    coalesce(a.nb_arrivals, 0)   as nb_arrivals,
    coalesce(d.nb_departures, 0) + coalesce(a.nb_arrivals, 0) as nb_total_trips

from stations s
left join departures d on s.station_id = d.station_id
left join arrivals a   on s.station_id = a.station_id
