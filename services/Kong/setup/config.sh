# Kong configuration
DEFAULT_KONG_PG_USER=kong
DEFAULT_KONG_PG_PASSWORD=kong
DEFAULT_KONG_PG_DATABASE=kong
DEFAULT_KONG_PASSWORD=handyshake # Admin GUI password (required for RBAC)

printf '%b\n' "--- Kong Configuration ---" >&2

# Get CADDY_MAIN_DOMAIN from existing config sources
caddy_main_domain=""
if [ -f "$CC_CONFIG_DIR/config.env" ]; then
  caddy_main_domain=$(grep -oP '^CADDY_MAIN_DOMAIN=\K.*' "$CC_CONFIG_DIR/config.env" 2>/dev/null)
fi
if [ -z "$caddy_main_domain" ] && [ -f "services/config/Base/Caddy/config.partial" ]; then
  caddy_main_domain=$(grep -oP '^CADDY_MAIN_DOMAIN=\K.*' "services/config/Base/Caddy/config.partial" 2>/dev/null)
fi
caddy_main_domain=${caddy_main_domain:-apug.it}

read -p "KONG_PG_USER [$DEFAULT_KONG_PG_USER]: " kong_pg_user
kong_pg_user=${kong_pg_user:-$DEFAULT_KONG_PG_USER}
read -p "KONG_PG_PASSWORD [$DEFAULT_KONG_PG_PASSWORD]: " kong_pg_pass
kong_pg_pass=${kong_pg_pass:-$DEFAULT_KONG_PG_PASSWORD}
read -p "KONG_PG_DATABASE [$DEFAULT_KONG_PG_DATABASE]: " kong_pg_db
kong_pg_db=${kong_pg_db:-$DEFAULT_KONG_PG_DATABASE}

# Kong Manager GUI URLs (must match Caddy reverse proxy configuration)
DEFAULT_KONG_DOMAIN="kong.${caddy_main_domain}"
read -p "KONG_DOMAIN [$DEFAULT_KONG_DOMAIN]: " kong_domain
kong_domain=${kong_domain:-$DEFAULT_KONG_DOMAIN}
printf '%b\n' "" >&2

# Write partial config file directly to the service config directory
# REPO_NAME, SERVICE_NAME, and SERVICE_CONFIG_DIR are provided by dcm service config
cat > "$SERVICE_CONFIG_DIR/config.partial" <<EOF

# Kong Configuration
KONG_PG_USER=$kong_pg_user
KONG_PG_PASSWORD=$kong_pg_pass
KONG_PG_DATABASE=$kong_pg_db
KONG_ADMIN_GUI_URL=https://$kong_domain
KONG_ADMIN_GUI_API_URL=https://$kong_domain/admin
KONG_PASSWORD=$DEFAULT_KONG_PASSWORD
EOF

kong_config_dir="$DCM_CONFIG_DIR/DCMBase/Kong"
mkdir -p "$kong_config_dir"

if [ ! -f "$kong_config_dir/kong-plugins.yml" ]; then
  cat > "$kong_config_dir/kong-plugins.yml" <<'KEOF'
# Kong Custom Plugins
#
# Aggiungi qui i tuoi plugin custom. Per ogni plugin:
#   1. Monta la directory del plugin come volume in kong-cp
#   2. Aggiorna KONG_PLUGINS con il nome del plugin
#
# Esempio (sostituisci "my-plugin" con il nome reale):
#
# services:
#   kong-cp:
#     environment:
#       KONG_PLUGINS: "bundled,my-plugin"
#     volumes:
#       - ${DCM_VOLUMES_DIR}/DCMBase/Kong/Plugins/my-plugin:/usr/local/share/lua/5.1/kong/plugins/my-plugin:ro,z
#
# Dopo ogni modifica: docker compose up -d --force-recreate kong-cp

services:
  kong-cp:
    environment:
      KONG_PLUGINS: "bundled"
KEOF
  printf '%b\n' "✓ kong-plugins.yml creato in $kong_config_dir" >&2
fi
