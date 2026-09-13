from pathlib import Path


def transform_raw_data(connection, transform_sql_path: Path):
    sql = transform_sql_path.read_text(encoding="utf-8")
    connection.executescript(sql)
    connection.commit()
    print("[OK] SQL transformation completed.")
