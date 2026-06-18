#!/bin/sh
printf '%b\n' "--- Mailpit Configuration ---" >&2

caddy_main_domain=""
if [ -f "$DCM_CONFIG_DIR/config.env" ]; then
  caddy_main_domain=$(grep -oP '^CADDY_MAIN_DOMAIN=\K.*' "$DCM_CONFIG_DIR/config.env" 2>/dev/null)
fi
if [ -z "$caddy_main_domain" ] && [ -f "$DCM_CONFIG_DIR/_dcm/Caddy/config.partial" ]; then
  caddy_main_domain=$(grep -oP '^CADDY_MAIN_DOMAIN=\K.*' "$DCM_CONFIG_DIR/_dcm/Caddy/config.partial" 2>/dev/null)
fi
caddy_main_domain=${caddy_main_domain:-apug.it}

DEFAULT_MAILPIT_DOMAIN="mail.${caddy_main_domain}"
read -p "MAILPIT_DOMAIN [$DEFAULT_MAILPIT_DOMAIN]: " mailpit_domain
mailpit_domain=${mailpit_domain:-$DEFAULT_MAILPIT_DOMAIN}

DEFAULT_MAILPIT_SMTP_HOST="mailpit"
DEFAULT_MAILPIT_SMTP_PORT="1025"

cat > "$SERVICE_CONFIG_DIR/config.partial" <<EOF

# Mailpit Configuration
MAILPIT_DOMAIN=$mailpit_domain
MAILPIT_SMTP_HOST=$DEFAULT_MAILPIT_SMTP_HOST
MAILPIT_SMTP_PORT=$DEFAULT_MAILPIT_SMTP_PORT
EOF

printf '%b\n' "" >&2
printf '%b\n' "SMTP: ${DEFAULT_MAILPIT_SMTP_HOST}:${DEFAULT_MAILPIT_SMTP_PORT} (internal Docker network)" >&2
printf '%b\n' "GUI:  https://${mailpit_domain}" >&2
