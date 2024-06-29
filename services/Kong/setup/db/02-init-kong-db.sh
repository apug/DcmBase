#!/bin/bash
set -e

export PGPASSWORD="${POSTGRES_PASSWORD}"

psql -v ON_ERROR_STOP=1 --host postgresql --port 5432 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Create user only if it doesn't exist
    DO \$\$
    BEGIN
        IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '${KONG_PG_USER}') THEN
            CREATE USER ${KONG_PG_USER} WITH PASSWORD '${KONG_PG_PASSWORD}';
        END IF;
    END
    \$\$;

    -- Create database only if it doesn't exist
    SELECT 'CREATE DATABASE ${KONG_PG_DATABASE}'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${KONG_PG_DATABASE}')\gexec

    GRANT ALL PRIVILEGES ON DATABASE ${KONG_PG_DATABASE} TO ${KONG_PG_USER};
    \c ${KONG_PG_DATABASE}
    GRANT ALL ON SCHEMA public TO ${KONG_PG_USER};
EOSQL
