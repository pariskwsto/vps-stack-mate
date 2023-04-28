#!/bin/bash

source utils/logger.sh
source .env

logger CMD "Run 'deploy-domains' command"

if [ ! -f ".env" ]
then
  logger ERROR "The file '.env' does not exist."
  logger INFO "Please run './mate.sh generate-config-files' command first."
  exit 0
fi

if [ ! -f "$MATE_DOMAINS_FILE" ]
then
  logger ERROR "The file '$MATE_DOMAINS_FILE' does not exist."
  logger INFO "Please run './mate.sh generate-config-files' command first."
  exit 0
fi

function removeNginxConfDir() {
  logger SUB_CMD "### Removing '$NGINX_SERVICE_CONF_DIR' directory..."
  rm -Rf "$NGINX_SERVICE_CONF_DIR"
}

function createNginxConfDir() {
  logger SUB_CMD "### Creating a new '$NGINX_SERVICE_CONF_DIR' directory..."
  mkdir -p "$NGINX_SERVICE_CONF_DIR"
}

function clearNginxConfDir() {
  logger SUB_CMD "### Checking if '$NGINX_SERVICE_CONF_DIR' directory exists..."
  if [ -e "$NGINX_SERVICE_CONF_DIR" ]; then
    removeNginxConfDir
  fi

  createNginxConfDir
}

function generateDomainSSL() {
  source scripts/generate/domain-ssl.sh
}

function setupSSL() {
  logger SUB_CMD "### Setting up SSL for '$domain'..."

  domain_conf_live_dir="$CERTBOT_SERVICE_DATA_DIR/conf/live/$domain"
  domain_conf_renewal_file="$CERTBOT_SERVICE_DATA_DIR/conf/renewal/$domain.conf"

  echo "SSL files:"
  logger INFO "- $domain_conf_live_dir"
  logger INFO "- $domain_conf_renewal_file"

  if [ ! -d $domain_conf_live_dir ] || [ ! -f $domain_conf_renewal_file ];
  then
    generateDomainSSL $domain
  else
    echo "SSL certificate for '$domain' already exists."
    logger DECISION "Do you want to regenerate the certificate? [y/N] "
    read -p "" regenerate_ssl_certificate
    if [ "$regenerate_ssl_certificate" == "Y" ] || [ "$regenerate_ssl_certificate" == "y" ]; 
    then
      generateDomainSSL $domain
    fi
  fi
}

function copyNginxConfFile() {
  logger SUB_CMD "### Copying '$domain' nginx conf file..."

  nginx_conf_file="$NGINX_MATE_CONF_DIR/$domain.conf"

  if [ ! -f $nginx_conf_file ];
  then
    logger INFO "There is no '$domain.conf' file in '$NGINX_MATE_CONF_DIR' directory."
    logger INFO "Using default.conf file..."
    sed 's/domain_placeholder/'$domain'/g' $NGINX_MATE_CONF_DIR/default.conf > $NGINX_SERVICE_CONF_DIR/$domain.conf
  else
    cp $NGINX_MATE_CONF_DIR/$domain.conf $NGINX_SERVICE_CONF_DIR/$domain.conf
  fi
}

function registerDomains() {
  echo "Registering domains..."

  json=$(cat $MATE_DOMAINS_FILE)
  json=$(echo "$json" | tr -d '[:space:]')
  json="${json#[}"
  json="${json%]}"

  IFS=','
  for domain in $json; do
    domain=$(echo "$domain" | tr -d '"')
    logger CMD "================> $domain <================"

    setupSSL $domain
    logger INFO "Finished setting up SSL for '$domain'"

    copyNginxConfFile $domain
    logger INFO "Finished copying '$domain' nginx conf file"
  done
}

function initDomainsSetup() {
  clearNginxConfDir
  registerDomains
}

initDomainsSetup