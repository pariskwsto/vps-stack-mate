#!/bin/bash

USAGE="Usage: ./mate.sh [COMMAND] [OPTIONS]...

Generate config files commands:
  generate-env-file                       Generate .env file
  generate-domains-file                   Generate domains.json file
  generate-all-config-files               Generate all config files

Deploy stack commands:
  deploy-domains                          Setup domains and subdomains for the VPS stack
  deploy-services                         Deploy the Docker-compose services for Mate
  deploy-stack                            Deploy the VPS stack

Available commands:
  clean-stack                             Remove all config files

Options: -h, --help                       Display this help message"

if [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
  echo "$USAGE"
  exit 0

# generate config files commands
elif [ "$1" == "generate-env-file" ]
then
  scripts/generate/env-file.sh "${@:2}"

elif [ "$1" == "generate-domains-file" ]
then
  scripts/generate/domains-file.sh "${@:2}"

elif [ "$1" == "generate-all-config-files" ]
then
  scripts/generate/env-file.sh "${@:2}"
  scripts/generate/domains-file.sh "${@:2}"

# deploy the stack commands
elif [ "$1" == "deploy-domains" ]
then
  scripts/deploy/domains.sh "${@:2}"

elif [ "$1" == "deploy-services" ]
then
  scripts/deploy/services.sh "${@:2}"

elif [ "$1" == "deploy-stack" ]
then
  scripts/deploy/domains.sh "${@:2}"
  scripts/deploy/services.sh "${@:2}"

# clean stack command
elif [ "$1" == "clean-stack" ]
then
  rm -rf certbot nginx/conf.d .env domains.json

else
    echo "Invalid command. Use './mate.sh --help' to see available commands."
    exit 1
fi