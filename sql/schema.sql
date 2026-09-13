CREATE TABLE IF NOT EXISTS raw_weather (
    raw_id INTEGER PRIMARY KEY AUTOINCREMENT,
    requested_city TEXT NOT NULL,
    source TEXT NOT NULL,
    payload_json TEXT NOT NULL,
    loaded_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS weather_metrics (
    metric_id INTEGER PRIMARY KEY AUTOINCREMENT,
    raw_id INTEGER NOT NULL UNIQUE,
    city TEXT NOT NULL,
    country TEXT,
    latitude REAL,
    longitude REAL,
    temperature_c REAL,
    feels_like_c REAL,
    min_temperature_c REAL,
    max_temperature_c REAL,
    pressure_hpa REAL,
    humidity_percent REAL,
    visibility_m REAL,
    wind_speed_mps REAL,
    wind_direction_deg REAL,
    cloud_percent REAL,
    weather_main TEXT,
    weather_description TEXT,
    observed_at TEXT NOT NULL,
    transformed_at TEXT NOT NULL,
    FOREIGN KEY (raw_id) REFERENCES raw_weather(raw_id)
);

CREATE INDEX IF NOT EXISTS idx_weather_metrics_city
ON weather_metrics(city);

CREATE INDEX IF NOT EXISTS idx_weather_metrics_observed_at
ON weather_metrics(observed_at);
