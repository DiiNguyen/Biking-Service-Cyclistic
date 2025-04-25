CREATE TABLE `trip_data` (
    ride_id VARCHAR(255) PRIMARY KEY,
    rideable_type VARCHAR(255),
    started_at DATETIME,
    ended_at DATETIME,
    start_station_name VARCHAR(255),
    start_station_id INT,
    end_station_name VARCHAR(255),
    end_station_id INT,
    start_lat DOUBLE,
    start_lng DOUBLE,
    end_lat DOUBLE,
    end_lng DOUBLE,
    member_casual VARCHAR(255),
    ride_length VARCHAR(255),
    day_of_week INT,
    Name_of_date VARCHAR(255)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/202401-divvy-tripdata.csv' INTO TABLE `trip_data`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED by '\n'
IGNORE 1 LINES
(ride_id, rideable_type,
    started_at ,
    ended_at ,
    start_station_name ,
    start_station_id,
    end_station_name ,
    end_station_id ,
     @start_lat,
     @start_lng,
     @end_lat,
     @end_lng,
     member_casual,
     @ride_length,
     day_of_week,
     Name_of_date)
SET
 start_lat = NULLIF(@start_lat, ''),
 start_lng = NULLIF(@start_lng, ''),
 end_lat = NULLIF(@end_lat, ''),
 end_lng = NULLIF(@end_lng, ''),
 ride_length = NULLIF(@ride_length, '');

SELECT ended_at, started_at, ride_length_sec, timediff(ended_at, started_at), sec_to_time(ride_length_sec)
FROM `trip_data`
ORDER BY ride_length_sec DESC
LIMIT 10;

UPDATE `trip_data`
SET ride_length = TIMESTAMPDIFF(SECOND, started_at, ended_at);

ALTER TABLE `2024_06_trip` ADD COLUMN ride_length_formatted varchar(255);

UPDATE `trip_data`
SET ride_length_formatted = CONCAT(
           FLOOR(ride_length / 3600), ':',
           LPAD(FLOOR((ride_length % 3600) / 60), 2, '0'), ':',
           LPAD(ride_length % 60, 2, '0')
       );

SELECT *
FROM trip_data;