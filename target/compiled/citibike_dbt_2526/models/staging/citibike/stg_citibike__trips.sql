

with source as (

    select * from `local-tempo-493308-m1`.`citibike_dataset`.`dev_Citibike2526`

),

renamed as (

    select
        ride_id,
        rideable_type,
        member_casual                          as rider_type,

        cast(started_at as timestamp)          as started_at,
        cast(ended_at as timestamp)            as ended_at,

        start_station_id                       as start_station_id,
        start_station_name                     as start_station_name,
        cast(start_lat as float64)             as start_lat,
        cast(start_lng as float64)             as start_lng,

        end_station_id                         as end_station_id,
        end_station_name                       as end_station_name,
        cast(end_lat as float64)               as end_lat,
        cast(end_lng as float64)               as end_lng

    from source

)

select * from renamed