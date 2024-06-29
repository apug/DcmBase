# PostgreSQL configuration
DEFAULT_POSTGRES_USER=postgres
DEFAULT_POSTGRES_PASSWORD=postgres
DEFAULT_POSTGRES_DB=postgres

printf '%b\n' "--- PostgreSQL Configuration ---"
read -p "POSTGRES_USER [$DEFAULT_POSTGRES_USER]: " pg_user
pg_user=${pg_user:-$DEFAULT_POSTGRES_USER}
read -p "POSTGRES_PASSWORD [$DEFAULT_POSTGRES_PASSWORD]: " pg_pass
pg_pass=${pg_pass:-$DEFAULT_POSTGRES_PASSWORD}
read -p "POSTGRES_DB [$DEFAULT_POSTGRES_DB]: " pg_db
pg_db=${pg_db:-$DEFAULT_POSTGRES_DB}
printf '%b\n' ""

# Write partial config file directly to the service config directory
# REPO_NAME, SERVICE_NAME, and SERVICE_CONFIG_DIR are provided by dcm service config
cat >"$SERVICE_CONFIG_DIR/config.partial" <<EOF

# PostgreSQL Configuration
POSTGRES_USER=$pg_user
POSTGRES_PASSWORD=$pg_pass
POSTGRES_DB=$pg_db
EOF
