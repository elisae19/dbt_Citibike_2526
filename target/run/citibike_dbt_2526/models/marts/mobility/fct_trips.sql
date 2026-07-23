

    
    
        -- generated script to merge partitions into `local-tempo-493308-m1`.`citibike_dataset`.`fct_trips`
      declare dbt_partitions_for_replacement array<timestamp>;

      
      
       -- 1. create a temp table with model data
        
  
    

    create or replace table `local-tempo-493308-m1`.`citibike_dataset`.`fct_trips__dbt_tmp184458954163`
      
    partition by timestamp_trunc(started_at, month)
    cluster by start_station_id, member_type

    
    OPTIONS(
      expiration_timestamp=TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 12 hour)
    )
    as (
      

select
    ride_id,
    rideable_type,
    member_type,

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


where started_at > (select max(started_at) from `local-tempo-493308-m1`.`citibike_dataset`.`fct_trips`)

    );
  
      -- 2. define partitions to update
      set (dbt_partitions_for_replacement) = (
          select as struct
              -- IGNORE NULLS: this needs to be aligned to _dbt_max_partition, which ignores null
              array_agg(distinct timestamp_trunc(started_at, month) IGNORE NULLS)
          from `local-tempo-493308-m1`.`citibike_dataset`.`fct_trips__dbt_tmp184458954163`
      );

      -- 3. run the merge statement
      

    merge into `local-tempo-493308-m1`.`citibike_dataset`.`fct_trips` as DBT_INTERNAL_DEST
        using (
        select
        * from `local-tempo-493308-m1`.`citibike_dataset`.`fct_trips__dbt_tmp184458954163`
      ) as DBT_INTERNAL_SOURCE
        on FALSE

    when not matched by source
         and timestamp_trunc(DBT_INTERNAL_DEST.started_at, month) in unnest(dbt_partitions_for_replacement) 
        then delete

    when not matched then insert
        (`ride_id`, `rideable_type`, `rider_type`, `started_at`, `ended_at`, `trip_duration_minutes`, `start_station_id`, `end_station_id`, `is_round_trip`, `distance_km`, `start_day_of_week`, `start_hour`, `day_type`)
    values
        (`ride_id`, `rideable_type`, `rider_type`, `started_at`, `ended_at`, `trip_duration_minutes`, `start_station_id`, `end_station_id`, `is_round_trip`, `distance_km`, `start_day_of_week`, `start_hour`, `day_type`)

;

      -- 4. clean up the temp table
      drop table if exists `local-tempo-493308-m1`.`citibike_dataset`.`fct_trips__dbt_tmp184458954163`

  


    


    