# RabbitMQ configuration
DEFAULT_RABBITMQ_DEFAULT_USER=admin
DEFAULT_RABBITMQ_DEFAULT_PASS=admin
DEFAULT_RABBITMQ_DEFAULT_VHOST=/

printf '%b\n' "--- RabbitMQ Configuration ---" >&2
read -p "RABBITMQ_DEFAULT_USER [$DEFAULT_RABBITMQ_DEFAULT_USER]: " rmq_user
rmq_user=${rmq_user:-$DEFAULT_RABBITMQ_DEFAULT_USER}
read -p "RABBITMQ_DEFAULT_PASS [$DEFAULT_RABBITMQ_DEFAULT_PASS]: " rmq_pass
rmq_pass=${rmq_pass:-$DEFAULT_RABBITMQ_DEFAULT_PASS}
read -p "RABBITMQ_DEFAULT_VHOST [$DEFAULT_RABBITMQ_DEFAULT_VHOST]: " rmq_vhost
rmq_vhost=${rmq_vhost:-$DEFAULT_RABBITMQ_DEFAULT_VHOST}
printf '%b\n' "" >&2

# Write partial config file directly to the service config directory
# REPO_NAME, SERVICE_NAME, and SERVICE_CONFIG_DIR are provided by dcm service config
cat > "$SERVICE_CONFIG_DIR/config.partial" <<EOF

# RabbitMQ Configuration
RABBITMQ_DEFAULT_USER=$rmq_user
RABBITMQ_DEFAULT_PASS=$rmq_pass
RABBITMQ_DEFAULT_VHOST=$rmq_vhost
EOF
