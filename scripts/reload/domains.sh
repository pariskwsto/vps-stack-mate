#!/bin/bash

source utils/logger.sh
source .env

logger CMD "Run 'reload-domains' command"

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

    copyNginxConfFile $domain
    logger INFO "Finished copying '$domain' nginx conf file"
  done
}

function initDomainsSetup() {
  clearNginxConfDir
  registerDomains

  docker compose up --force-recreate -d nginx
}

initDomainsSetup