#!/bin/bash

source utils/logger.sh

logger CMD "Run 'reload-service' command"

logger DECISION "Enter the name of the service you need to reload/recreate: "
read -p "" SERVICE_NAME

docker-compose pull $SERVICE_NAME
docker-compose up -d --force-recreate $SERVICE_NAME
