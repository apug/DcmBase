# MariaDB configuration
DEFAULT_MARIADB_ROOT_PASSWORD=root

printf '%b\n' "--- MariaDB Configuration ---" >&2
read -p "MARIADB_ROOT_PASSWORD [$DEFAULT_MARIADB_ROOT_PASSWORD]: " mariadb_root_pass
mariadb_root_pass=${mariadb_root_pass:-$DEFAULT_MARIADB_ROOT_PASSWORD}
printf '%b\n' "" >&2

# Write partial config file directly to the service config directory
# REPO_NAME, SERVICE_NAME, and SERVICE_CONFIG_DIR are provided by dcm service config
cat > "$SERVICE_CONFIG_DIR/config.partial" <<EOF

# MariaDB Configuration
MARIADB_ROOT_PASSWORD=$mariadb_root_pass
EOF
