#!/bin/bash

source utils/logger.sh
source .env

function copyDefaultNginxConfFile() {
  logger SUB_CMD "### Copying default nginx configuration file for '$domain'..."
  sed 's/domain_placeholder/'$domain'/g' $NGINX_MATE_CONF_DIR/default.conf > $NGINX_SERVICE_CONF_DIR/$domain.conf
  logger INFO "Finished copying '$domain' default nginx conf file"
}

function generateNewSSLCertificate() {
  # Downloading recommended TLS parameters
  if [ ! -e "$CERTBOT_SERVICE_DATA_DIR/conf/options-ssl-nginx.conf" ] || [ ! -e "$CERTBOT_SERVICE_DATA_DIR/conf/ssl-dhparams.pem" ];
  then
    logger SUB_CMD "### Downloading recommended TLS parameters ..."
    
    mkdir -p "$CERTBOT_SERVICE_DATA_DIR/conf"
    
    curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$CERTBOT_SERVICE_DATA_DIR/conf/options-ssl-nginx.conf"
    
    curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$CERTBOT_SERVICE_DATA_DIR/conf/ssl-dhparams.pem"
    
    echo
  fi
  
  # Creating dummy certificate
  logger SUB_CMD "### Creating dummy certificate for '$domain'..."
  
  letsencrypt_live_path="/etc/letsencrypt/live/$domain"
  
  mkdir -p "$CERTBOT_SERVICE_DATA_DIR/conf/live/$domain"
  
  docker-compose run --rm --entrypoint "\
    openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout '$letsencrypt_live_path/privkey.pem' \
    -out '$letsencrypt_live_path/fullchain.pem' \
    -subj '/CN=localhost'" certbot
  
  # Starting nginx
  logger SUB_CMD "### Starting nginx..."
  
  docker-compose up --force-recreate -d nginx
  
  # Deleting dummy certificate
  logger SUB_CMD "### Deleting dummy certificate for '$domain'..."
  
  docker-compose run --rm --entrypoint "\
    rm -Rf /etc/letsencrypt/live/$domain && \
    rm -Rf /etc/letsencrypt/archive/$domain && \
    rm -Rf /etc/letsencrypt/renewal/$domain.conf" certbot
  
  # Requesting Let's Encrypt certificate
  logger SUB_CMD "### Requesting Let's Encrypt certificate for '$domain'..."
  
  domain_arg="-d $domain"
  
  # Select appropriate email arg
  case "$CERTBOT_LETSENCRYPT_EMAIL" in
    "") email_arg="--register-unsafely-without-email" ;;
    *) email_arg="--email $CERTBOT_LETSENCRYPT_EMAIL" ;;
  esac
  
  # Enable staging mode if needed
  if [ $CERTBOT_LETSENCRYPT_STAGING != "0" ]; then staging_arg="--staging"; fi
  
  docker-compose run --rm --entrypoint "\
    certbot certonly --webroot -w /var/www/certbot \
      $staging_arg \
      $email_arg \
      $domain_arg \
      --rsa-key-size $CERTBOT_LETSENCRYPT_RSA_KEY_SIZE \
      --agree-tos \
      --force-renewal" certbot
  
  # Reloading nginx
  logger SUCCESS "### Reloading nginx..."
  
  docker-compose exec nginx nginx -s reload
}

function initDomainSSLGeneration() {
  copyDefaultNginxConfFile $domain
  generateNewSSLCertificate $domain
}

initDomainSSLGeneration``