import json
import os
from pathlib import Path

from dotenv import load_dotenv

PROJECT_ROOT = Path(__file__).resolve().parent.parent
load_dotenv(PROJECT_ROOT / ".env")

API_KEY = os.getenv("OPENWEATHER_API_KEY")
DATABASE_PATH = PROJECT_ROOT / os.getenv("DATABASE_PATH", "data/weather.db")
CITY_CONFIG_PATH = PROJECT_ROOT / os.getenv("CITY_CONFIG_PATH", "config/cities.json")

if not API_KEY:
    raise RuntimeError(
        "OPENWEATHER_API_KEY is missing. Create .env from .env.example."
    )


def load_cities():
    with open(CITY_CONFIG_PATH, "r", encoding="utf-8") as file:
        config = json.load(file)

    cities = config.get("cities", [])
    if not cities:
        raise ValueError("No cities configured in config/cities.json.")

    return cities
