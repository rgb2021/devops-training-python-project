from typing import List, Dict
from flask import Flask
import psycopg2
import json
import os

app = Flask(__name__)


def favorite_colors() -> List[Dict]:
    config = {
        "user": os.environ.get("DB_USER", "root"),
        "password": os.environ.get("DB_PWD", "root"),
        "host": os.environ.get("DB_HOST", "COMPLETE"),
        "port": os.environ.get("DB_PORT", "5432"),
        "database": os.environ.get("DB_NAME", "root"),
    }
    connection = psycopg2.connect(**config)
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM favorite_colors")
    results = [{name: color} for (name, color) in cursor]
    cursor.close()
    connection.close()

    return results


@app.route("/")
def index() -> str:
    return json.dumps({"favorite_colors": favorite_colors()})


if __name__ == "__main__":
    app.run(host="0.0.0.0")
