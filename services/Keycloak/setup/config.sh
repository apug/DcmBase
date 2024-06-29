# Keycloak configuration
DEFAULT_KC_DB_NAME=keycloak
DEFAULT_KC_DB_USERNAME=keycloak
DEFAULT_KC_DB_PASSWORD=keycloak
DEFAULT_KC_BOOTSTRAP_ADMIN_USERNAME=admin
DEFAULT_KC_BOOTSTRAP_ADMIN_PASSWORD=admin

printf '%b\n' "--- Keycloak Configuration ---" >&2
read -p "KC_DB_NAME[$DEFAULT_KC_DB_NAME]: " kc_db_name
kc_db_name=${kc_db_name:-$DEFAULT_KC_DB_NAME}
read -p "KC_DB_USERNAME [$DEFAULT_KC_DB_USERNAME]: " kc_db_user
kc_db_user=${kc_db_user:-$DEFAULT_KC_DB_USERNAME}
read -p "KC_DB_PASSWORD [$DEFAULT_KC_DB_PASSWORD]: " kc_db_pass
kc_db_pass=${kc_db_pass:-$DEFAULT_KC_DB_PASSWORD}
read -p "DEFAULT_KC_BOOTSTRAP_ADMIN_USERNAME [$DEFAULT_KC_BOOTSTRAP_ADMIN_USERNAME]: " kc_admin
kc_admin=${kc_admin:-$DEFAULT_KC_BOOTSTRAP_ADMIN_USERNAME}
read -p "DEFAULT_KC_BOOTSTRAP_ADMIN_PASSWORD [$DEFAULT_KC_BOOTSTRAP_ADMIN_PASSWORD]: " kc_admin_pass
kc_admin_pass=${kc_admin_pass:-$DEFAULT_KC_BOOTSTRAP_ADMIN_PASSWORD}
printf '%b\n' "" >&2

# Write partial config file directly to the service config directory
# REPO_NAME, SERVICE_NAME, and SERVICE_CONFIG_DIR are provided by dcm service config
cat > "$SERVICE_CONFIG_DIR/config.partial" <<EOF

# Keycloak Configuration
KC_DB_NAME=$kc_db_name
KC_DB_USERNAME=$kc_db_user
KC_DB_PASSWORD=$kc_db_pass
KC_BOOTSTRAP_ADMIN_USERNAME=$kc_admin
KC_BOOTSTRAP_ADMIN_PASSWORD=$kc_admin_pass
EOF
