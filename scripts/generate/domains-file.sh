#!/bin/bash

source utils/logger.sh

logger CMD "Run 'generate-domains-json-file' command"

if [ ! -f ".env" ]
then
  logger ERROR "The file '.env' does not exist."
  logger INFO "Please run './mate.sh generate-env-file' command first."
  exit 0
fi

source .env

if [ -f "$MATE_DOMAINS_FILE" ]
then
  while true; do
    logger DECISION "The file '$MATE_DOMAINS_FILE' already exists. Do you want to generate a new one? (y/n): "
    read -p "" generate_new_mate_domains_file
    case $generate_new_mate_domains_file in
      [Yy]* )
        rm "$MATE_DOMAINS_FILE"
        break;;
      [Nn]* )
        logger INFO "Keeping existing '$MATE_DOMAINS_FILE' file..."
        exit 0;;
      * )
        logger ERROR "Please answer 'y' or 'n'."
        ;;
    esac
  done
fi

domains=("example.com" "subdomain.example.com")

json="["
for ((i=0; i<${#domains[@]}; i++)); do
  json+="\"${domains[$i]}\""
  if [ $i -lt $((${#domains[@]}-1)) ]; then
    json+=", "
  fi
done
json+="]"

echo "$json" > $MATE_DOMAINS_FILE

logger SUCCESS "The file '$MATE_DOMAINS_FILE' has been generated successfully."
