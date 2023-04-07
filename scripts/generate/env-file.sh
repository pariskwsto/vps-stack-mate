#!/bin/bash

echo "Run 'generate-env-file' command"

MATE_DOMAINS_FILE="domains.txt"
MATE_NGINX_CONF_DIR=nginx/conf

NGINX_CONTAINER=nginx-mate
NGINX_CONF_PATH="nginx/conf.d"

CERTBOT_CONTAINER=certbot-mate
CERTBOT_DATA_PATH="certbot/data"
CERTBOT_LETSENCRYPT_RSA_KEY_SIZE=4096
CERTBOT_LETSENCRYPT_STAGING=0

if [ -f ".env" ]
then
  read -p "The file '.env' already exists. Do you want to generate a new one? (y/n): " GENERATE_NEW
  if [ "$GENERATE_NEW" == "y" ]
  then
    rm .env
  else
    echo "Keeping existing '.env' file."
    exit 0
  fi
fi

read -p "Enter your email address for Certbot: " CERTBOT_LETSENCRYPT_EMAIL

cat <<EOF >.env
# vps-stack-mate config variables
MATE_DOMAINS_FILE=$MATE_DOMAINS_FILE
MATE_NGINX_CONF_DIR=$MATE_NGINX_CONF_DIR

# vps-stack-mate services variables
## Nginx
NGINX_CONTAINER=$NGINX_CONTAINER
NGINX_CONF_PATH=$NGINX_CONF_PATH

## Certbot
CERTBOT_CONTAINER=$CERTBOT_CONTAINER
CERTBOT_DATA_PATH=$CERTBOT_DATA_PATH
## Define certbot letsencrypt config data
CERTBOT_LETSENCRYPT_EMAIL=$CERTBOT_LETSENCRYPT_EMAIL
CERTBOT_LETSENCRYPT_RSA_KEY_SIZE=$CERTBOT_LETSENCRYPT_RSA_KEY_SIZE
### Default 0
### Set to 1 if you're testing your setup to avoid hitting request limits
CERTBOT_LETSENCRYPT_STAGING=$CERTBOT_LETSENCRYPT_STAGING
EOF

echo "The file '.env' has been generated successfully."