# Automated Weather Data Pipeline

End-to-end ELT pipeline using Python, SQL, SQLite, Linux cron, JSON, Git, and the OpenWeatherMap Current Weather API.

## Architecture

OpenWeatherMap API -> Python ingestion -> SQLite raw_weather -> SQL transformation -> SQLite weather_metrics -> analytics

The project deliberately uses **ELT**:
- Extract weather JSON with Python.
- Load the complete raw JSON payload into SQLite.
- Transform the raw JSON with SQL/SQLite JSON functions.
- Automate execution with Linux cron.

## Structure

```text
automated-weather-data-pipeline/
├── config/cities.json
├── data/.gitkeep
├── logs/.gitkeep
├── sql/schema.sql
├── sql/transform.sql
├── src/config.py
├── src/db.py
├── src/ingest.py
├── src/transform.py
├── .env.example
├── .gitignore
├── cron_weather.sh
├── main.py
├── queries.sql
├── requirements.txt
└── README.md
```

## Setup

1. Create an OpenWeatherMap account and API key. The API key is required for API calls and may take up to about two hours to activate after account verification.

2. On Linux:

```bash
git clone <your-repository-url>
cd automated-weather-data-pipeline
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
```

3. Edit `.env`:

```env
OPENWEATHER_API_KEY=your_real_api_key
DATABASE_PATH=data/weather.db
CITY_CONFIG_PATH=config/cities.json
```

4. Edit `config/cities.json` if needed:

```json
{
  "cities": [
    "Vijayawada,IN",
    "Hyderabad,IN",
    "Bengaluru,IN"
  ]
}
```

5. Run:

```bash
python3 main.py
```

6. Inspect SQLite:

```bash
sqlite3 data/weather.db
```

Then:

```sql
.tables
SELECT COUNT(*) FROM raw_weather;
SELECT city, temperature_c, humidity_percent, weather_description, observed_at
FROM weather_metrics
ORDER BY observed_at DESC;
.quit
```

## Cron automation

```bash
chmod +x cron_weather.sh
./cron_weather.sh
crontab -e
```

Run every hour:

```cron
0 * * * * /home/youruser/automated-weather-data-pipeline/cron_weather.sh
```

View logs:

```bash
tail -f logs/pipeline.log
```

## GitHub

```bash
git init
git add .
git commit -m "Build automated weather ELT pipeline"
git branch -M main
git remote add origin https://github.com/<username>/automated-weather-data-pipeline.git
git push -u origin main
```

Never commit `.env` or the SQLite database.

## Interview explanation

> I built an automated ELT weather pipeline using Python and the OpenWeatherMap API. Python extracts current weather responses as JSON and loads the complete raw payload into SQLite so the original source data is preserved. SQL then parses and cleans the JSON into an analytical weather table. Linux cron automates the complete pipeline on a fixed schedule.

## Strong upgrades

- API retry and exponential backoff
- Structured pipeline-run logging
- Data-quality checks
- CSV exports
- PostgreSQL destination
- Docker
- GitHub Actions CI
- Streamlit analytics dashboard

Official OpenWeather information:
https://openweathermap.org/
https://openweathermap.org/faq
