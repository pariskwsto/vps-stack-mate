#!/bin/bash

source utils/logger.sh

logger CMD "Run 'deploy-services' command"

docker compose up -d