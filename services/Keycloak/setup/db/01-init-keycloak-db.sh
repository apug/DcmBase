#!/bin/bash
set -e

export PGPASSWORD="${POSTGRES_PASSWORD}"

psql -v ON_ERROR_STOP=1 --host postgresql --port 5432 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Create user only if it doesn't exist
    DO \$\$
    BEGIN
        IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '${KC_DB_USERNAME}') THEN
            CREATE USER ${KC_DB_USERNAME} WITH PASSWORD '${KC_DB_PASSWORD}';
        END IF;
    END
    \$\$;

    -- Create database only if it doesn't exist
    SELECT 'CREATE DATABASE ${KC_DB_NAME}'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${KC_DB_NAME}')\gexec

    GRANT ALL PRIVILEGES ON DATABASE ${KC_DB_NAME} TO ${KC_DB_USERNAME};
    \c ${KC_DB_NAME}
    GRANT ALL ON SCHEMA public TO ${KC_DB_USERNAME};
EOSQL
