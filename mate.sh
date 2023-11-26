#!/bin/bash

USAGE="Usage: ./mate.sh [COMMAND] [OPTIONS]...

Generate config files commands:
  generate-env-file                       Generate .env file
  generate-domains-file                   Generate domains.json file
  generate-config-files                   Generate all config files

Deploy stack commands:
  deploy-domains                          Setup domains and subdomains (+SSL certificates)
  deploy-services                         Deploy the Docker Compose services
  deploy-stack                            Deploy both domains and services for the VPS stack

Reload stack commands:
  reload-domains                          Reload all domains and subdomains nginx conf files
  reload-service                          Reload a service to fix an issue or get the latest version of the image
  reload-stack                            Redeploy all services and reload all domains

Available commands:
  clean-stack                             Remove all the config files

Options: -h, --help                       Display this help message"

if [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
  echo "$USAGE"
  exit 0

# Generate config files commands
elif [ "$1" == "generate-env-file" ]
then
  scripts/generate/env-file.sh "${@:2}"

elif [ "$1" == "generate-domains-file" ]
then
  scripts/generate/domains-file.sh "${@:2}"

elif [ "$1" == "generate-config-files" ]
then
  scripts/generate/env-file.sh "${@:2}"
  scripts/generate/domains-file.sh "${@:2}"

# Deploy stack commands
elif [ "$1" == "deploy-domains" ]
then
  scripts/deploy/domains.sh "${@:2}"

elif [ "$1" == "deploy-services" ]
then
  scripts/deploy/services.sh "${@:2}"

elif [ "$1" == "deploy-stack" ]
then
  scripts/deploy/services.sh "${@:2}"
  scripts/deploy/domains.sh "${@:2}"

# Reload stack commands
elif [ "$1" == "reload-domains" ]
then
  scripts/reload/domains.sh "${@:2}"

elif [ "$1" == "reload-service" ]
then
  scripts/reload/service.sh "${@:2}"

elif [ "$1" == "reload-stack" ]
then
  scripts/deploy/services.sh "${@:2}"
  scripts/reload/domains.sh "${@:2}"

# Available commands
elif [ "$1" == "clean-stack" ]
then
  rm -rf certbot nginx/conf.d .env domains.json

else
  echo "Invalid command. Use './mate.sh --help' to see available commands."
  exit 1
fi