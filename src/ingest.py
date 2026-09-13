import json
from datetime import datetime, timezone

import requests

from src.config import API_KEY


API_URL = "https://api.openweathermap.org/data/2.5/weather"


def fetch_weather(city: str) -> dict:
    params = {
        "q": city,
        "appid": API_KEY,
        "units": "metric",
    }

    response = requests.get(API_URL, params=params, timeout=20)
    response.raise_for_status()
    return response.json()


def load_raw_weather(connection, requested_city: str, payload: dict):
    loaded_at = datetime.now(timezone.utc).isoformat()

    connection.execute(
        """
        INSERT INTO raw_weather (
            requested_city,
            source,
            payload_json,
            loaded_at
        )
        VALUES (?, ?, ?, ?)
        """,
        (
            requested_city,
            "OpenWeatherMap",
            json.dumps(payload, separators=(",", ":")),
            loaded_at,
        ),
    )


def ingest_cities(connection, cities):
    for city in cities:
        print(f"Extracting weather data for {city}...")

        try:
            payload = fetch_weather(city)
            load_raw_weather(connection, city, payload)
            connection.commit()
            print(f"  [OK] Loaded raw JSON for {city}")

        except requests.RequestException as exc:
            connection.rollback()
            print(f"  [ERROR] API request failed for {city}: {exc}")
