INSERT OR IGNORE INTO weather_metrics (
    raw_id,
    city,
    country,
    latitude,
    longitude,
    temperature_c,
    feels_like_c,
    min_temperature_c,
    max_temperature_c,
    pressure_hpa,
    humidity_percent,
    visibility_m,
    wind_speed_mps,
    wind_direction_deg,
    cloud_percent,
    weather_main,
    weather_description,
    observed_at,
    transformed_at
)
SELECT
    r.raw_id,
    json_extract(r.payload_json, '$.name'),
    json_extract(r.payload_json, '$.sys.country'),
    json_extract(r.payload_json, '$.coord.lat'),
    json_extract(r.payload_json, '$.coord.lon'),

    ROUND(json_extract(r.payload_json, '$.main.temp'), 2),
    ROUND(json_extract(r.payload_json, '$.main.feels_like'), 2),
    ROUND(json_extract(r.payload_json, '$.main.temp_min'), 2),
    ROUND(json_extract(r.payload_json, '$.main.temp_max'), 2),

    json_extract(r.payload_json, '$.main.pressure'),
    json_extract(r.payload_json, '$.main.humidity'),
    json_extract(r.payload_json, '$.visibility'),

    ROUND(json_extract(r.payload_json, '$.wind.speed'), 2),
    json_extract(r.payload_json, '$.wind.deg'),
    json_extract(r.payload_json, '$.clouds.all'),

    json_extract(r.payload_json, '$.weather[0].main'),
    json_extract(r.payload_json, '$.weather[0].description'),

    datetime(json_extract(r.payload_json, '$.dt'), 'unixepoch'),
    datetime('now')
FROM raw_weather AS r;
