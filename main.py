import logging

from src.config import DATABASE_PATH, PROJECT_ROOT, load_cities
from src.db import get_connection, initialize_database
from src.ingest import ingest_cities
from src.transform import transform_raw_data


SCHEMA_PATH = PROJECT_ROOT / "sql" / "schema.sql"
TRANSFORM_PATH = PROJECT_ROOT / "sql" / "transform.sql"
LOG_PATH = PROJECT_ROOT / "logs" / "pipeline.log"


def configure_logging():
    LOG_PATH.parent.mkdir(parents=True, exist_ok=True)

    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s | %(levelname)s | %(message)s",
        handlers=[
            logging.FileHandler(LOG_PATH),
            logging.StreamHandler(),
        ],
    )


def main():
    configure_logging()
    logging.info("Starting weather ELT pipeline")

    connection = get_connection(DATABASE_PATH)

    try:
        initialize_database(connection, SCHEMA_PATH)

        cities = load_cities()
        logging.info("Configured cities: %s", ", ".join(cities))

        ingest_cities(connection, cities)
        transform_raw_data(connection, TRANSFORM_PATH)

        raw_count = connection.execute(
            "SELECT COUNT(*) FROM raw_weather"
        ).fetchone()[0]

        metric_count = connection.execute(
            "SELECT COUNT(*) FROM weather_metrics"
        ).fetchone()[0]

        logging.info(
            "Pipeline completed | raw_rows=%s | metric_rows=%s",
            raw_count,
            metric_count,
        )

    except Exception:
        logging.exception("Pipeline failed")
        raise

    finally:
        connection.close()


if __name__ == "__main__":
    main()
