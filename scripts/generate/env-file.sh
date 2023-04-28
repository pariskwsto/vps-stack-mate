#!/bin/bash

MATE_DOMAINS_FILE="domains.json"
NGINX_MATE_CONF_DIR=nginx/conf

NGINX_SERVICE_NAME=nginx-mate
NGINX_SERVICE_CONF_DIR="nginx/conf.d"

CERTBOT_SERVICE_NAME=certbot-mate
CERTBOT_SERVICE_DATA_DIR="certbot/data"
CERTBOT_LETSENCRYPT_RSA_KEY_SIZE=4096
CERTBOT_LETSENCRYPT_STAGING=0

source utils/logger.sh

logger CMD "Run 'generate-env-file' command"

if [ -f ".env" ]
then
  while true; do
    logger DECISION "The file '.env' already exists. Do you want to generate a new one? (y/n): "
    read -p "" generate_new_env_file
    case $generate_new_env_file in
      [Yy]* )
        rm .env
        break;;
      [Nn]* )
        logger INFO "Keeping existing '.env' file..."
        exit 0;;
      * )
        logger ERROR "Please answer 'y' or 'n'."
        ;;
    esac
  done
fi

logger DECISION "Enter your email address for Certbot: "
read -p "" CERTBOT_LETSENCRYPT_EMAIL

cat <<EOF >.env
# vps-stack-mate config variables
MATE_DOMAINS_FILE=$MATE_DOMAINS_FILE
NGINX_MATE_CONF_DIR=$NGINX_MATE_CONF_DIR

# vps-stack-mate services variables
## Nginx
NGINX_SERVICE_NAME=$NGINX_SERVICE_NAME
NGINX_SERVICE_CONF_DIR=$NGINX_SERVICE_CONF_DIR

## Certbot
CERTBOT_SERVICE_NAME=$CERTBOT_SERVICE_NAME
CERTBOT_SERVICE_DATA_DIR=$CERTBOT_SERVICE_DATA_DIR
## Define certbot letsencrypt config data
CERTBOT_LETSENCRYPT_EMAIL=$CERTBOT_LETSENCRYPT_EMAIL
CERTBOT_LETSENCRYPT_RSA_KEY_SIZE=$CERTBOT_LETSENCRYPT_RSA_KEY_SIZE
### Default 0
### Set to 1 if you're testing your setup to avoid hitting request limits
CERTBOT_LETSENCRYPT_STAGING=$CERTBOT_LETSENCRYPT_STAGING
EOF

logger SUCCESS "The file '.env' has been generated successfully."