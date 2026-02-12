#!/bin/bash
set -e

SOURCE_DIR="/docker-entrypoint-initdb.source"

echo "--- Starting DB Initialization ---"

echo "Running migrations..."
for f in $(ls $SOURCE_DIR/migrations/*.sql | sort); do
    echo "Applying migration: $f"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$f"
done

if [ "$LOAD_SEEDS" = "true" ]; then
    echo "Running seeds..."
    for f in $(ls $SOURCE_DIR/seeds/*.sql | sort); do
        echo "Applying seed: $f"
        psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$f"
    done
else
    echo "Skipping seeds (LOAD_SEEDS is false)."
fi

echo "--- DB Initialization Complete ---"
