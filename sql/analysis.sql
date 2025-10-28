-- Check how many rows you have
SELECT COUNT(*) AS total_rows FROM cycle_2019;

-- Look at column names and first few rows
SELECT * FROM cycle_2019 LIMIT 10;

-- Check unique rider types
SELECT DISTINCT usertype FROM cycle_2019;

-- Count how many of each rider type
SELECT usertype , COUNT(*) AS count
FROM cycle_2019
GROUP BY usertype;

-- Check unique start and end stations
SELECT COUNT(DISTINCT from_station_name) AS unique_start_stations,
       COUNT(DISTINCT to_station_name) AS unique_end_stations
FROM cycle_2019;

-- Calculate average, minimum, and maximum trip duration
SELECT 
    usertype ,
    ROUND(AVG(tripduration/60), 2) AS avg_duration_min,
    ROUND(MIN(tripduration/60), 2) AS min_duration_min,
    ROUND(MAX(tripduration/60), 2) AS max_duration_min
FROM cycle_2019
GROUP BY usertype;

-- Check trips per month (if starttime is in date format)
SELECT 
    strftime('%m', start_time) AS month,
    usertype,
    COUNT(*) AS trips
FROM cycle_2019
GROUP BY month, usertype
ORDER BY month;


-- Total rides and average trip duration per rider type
SELECT 
    usertype ,
    COUNT(*) AS total_rides,
    ROUND(AVG(tripduration/60), 2) AS avg_trip_min
FROM cycle_2019
GROUP BY usertype ;

-- Gender breakdown if available
SELECT 
    usertype,
    gender,
    COUNT(*) AS count
FROM cycle_2019
WHERE gender IS NOT NULL
GROUP BY usertype, gender;
