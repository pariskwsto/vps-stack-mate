#!/bin/bash

source utils/logger.sh

logger CMD "Run 'reload-service' command"

services=$(docker compose config --services)

PS3="Enter the number of the service you want to reload: "
select SERVICE_NAME in $services
do
  if [[ -n "$SERVICE_NAME" ]]
  then
    break
  fi
done

logger DECISION "Reloading/recreating service $SERVICE_NAME"

docker compose pull $SERVICE_NAME
docker compose up -d --force-recreate $SERVICE_NAME
