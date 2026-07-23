

select
    ride_id,
    rideable_type,
    rider_type,

    started_at,
    ended_at,
    trip_duration_minutes,

    start_station_id,
    end_station_id,
    is_round_trip,
    distance_km,

    start_day_of_week,
    start_hour,
    day_type

from `local-tempo-493308-m1`.`citibike_dataset`.`int_citibike__trips_enriched`

