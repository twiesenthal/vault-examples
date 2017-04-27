#!/bin/bash
GREEN="\033[0;32m"
CLEAR="\033[0m"

echo -e "\n${GREEN}Running docker-compose down${CLEAR}"
docker-compose down 1>/dev/null

echo -e "\n${GREEN}removing vault files from ./data${CLEAR}"
rm -rf ./data  > /dev/null 2>&1 || true
