#!/bin/zsh

echo -e "\n\e[32mRunning docker-compose down\e[39m"
docker-compose down 1>/dev/null

echo -e "\n\e[32mremoving vault files from ./data\e[39m"
rm -rf ./data  > /dev/null 2>&1 || true
