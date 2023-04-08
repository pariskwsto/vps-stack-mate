#!/bin/bash

Blue="\033[34m"
Cyan="\033[36m"
Gray="\033[90m"
Green="\033[32m"
Magenta="\033[35m"
Red="\033[31m"
Yellow="\033[33m"

Light_Blue="\033[94m"
Light_Cyan="\033[96m"
Light_Gray="\033[37m"
Light_Green="\033[92m"
Light_Magenta="\033[95m"
Light_Red="\033[91m"
Light_Yellow="\033[93m"

White="\033[97m"
color_reset="\033[0m"

function logger {
  local type=$1
  local message=$2

  case $type in
    CMD) color_code=$Light_Cyan;;
    DECISION) color_code=$Light_Yellow;;
    ERROR) color_code=$Red;;
    INFO) color_code=$Gray;;
    SUCCESS) color_code=$Green;;
    URL) color_code=$Magenta;;
    *) color_code=$White;;
  esac

  echo -e "${color_code}${message}${color_reset}"
}