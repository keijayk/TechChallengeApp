#!/bin/bash

RSC_GRP=$1
CONTAINER_NAME=$2
LOG_MESSAGE=$3

while true; do
   UPDATE_DB_STATUS=$(az container logs --resource-group "$RSC_GRP" --name "$CONTAINER_NAME" | grep "${LOG_MESSAGE}")

   if [[ "$UPDATE_DB_STATUS" == "$LOG_MESSAGE" ]]; then
      echo
      echo -n "===== Update DB Completed ====="
      echo
      break
   else
      printf "."
      sleep 2
   fi
done
