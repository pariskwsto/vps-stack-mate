#!/bin/bash

source .env

echo "Run 'generate-domains-txt-file' command"

if [ -f "$MATE_DOMAINS_FILE" ]
then
  read -p "The file '$MATE_DOMAINS_FILE' already exists. Do you want to generate a new one? (y/n): " GENERATE_NEW
  if [ "$GENERATE_NEW" == "y" ]
  then
    rm "$MATE_DOMAINS_FILE"
  else
    echo "Keeping existing '$MATE_DOMAINS_FILE' file."
    exit 0
  fi
fi

domains=(example.com subdomain.example.com)

for domain in "${domains[@]}"
do
  echo "$domain" >> "$MATE_DOMAINS_FILE"
done

echo "The file '$MATE_DOMAINS_FILE' has been generated successfully."
