-- Latest observations
SELECT
    city,
    country,
    temperature_c,
    feels_like_c,
    humidity_percent,
    pressure_hpa,
    wind_speed_mps,
    cloud_percent,
    weather_description,
    observed_at
FROM weather_metrics
ORDER BY observed_at DESC
LIMIT 20;

-- Average temperature by city
SELECT
    city,
    ROUND(AVG(temperature_c), 2) AS avg_temperature_c,
    ROUND(AVG(humidity_percent), 2) AS avg_humidity_percent
FROM weather_metrics
GROUP BY city
ORDER BY avg_temperature_c DESC;

-- Highest observed temperature
SELECT city, temperature_c, observed_at
FROM weather_metrics
ORDER BY temperature_c DESC
LIMIT 10;

-- Pipeline row counts
SELECT COUNT(*) AS raw_payloads FROM raw_weather;
SELECT COUNT(*) AS transformed_records FROM weather_metrics;
