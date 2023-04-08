#!/bin/bash

source .env
source utils/logger.sh

logger CMD "Run 'generate-domains-txt-file' command"

if [ -f "$MATE_DOMAINS_FILE" ]
then
  logger DECISION "The file '$MATE_DOMAINS_FILE' already exists. Do you want to generate a new one? (y/n): "
  read -p "" GENERATE_NEW
  if [ "$GENERATE_NEW" == "y" ]
  then
    rm "$MATE_DOMAINS_FILE"
  else
    logger INFO "Keeping existing '$MATE_DOMAINS_FILE' file..."
    exit 0
  fi
fi

domains=(example.com subdomain.example.com)

for domain in "${domains[@]}"
do
  echo "$domain" >> "$MATE_DOMAINS_FILE"
done

logger SUCCESS "The file '$MATE_DOMAINS_FILE' has been generated successfully."
