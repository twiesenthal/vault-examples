#!/bin/zsh
SLEEP=20

>&2 echo "#Creating ./data if it doesn't exists"
mkdir -p ./data >/dev/null 2>&1

>&2 echo "#Running docker-compose up -d"
docker-compose up -d >/dev/null 2>&1

# i know this could be more sophisticated
>&2 echo "#Waiting for the containers to start"
sleep $SLEEP;

echo "export VAULT_ADDR=http://127.0.0.1:8200"
echo "export VAULT_TOKEN=$(docker logs vaultexample_vault 2>/dev/null | grep 'Root Token' | awk '{print $3}')"
echo "export VAULT_UNSEAL=$(docker logs vaultexample_vault 2>/dev/null | grep 'Unseal Key' | awk '{print $3}')"
>&2 echo "#Done"
>&2 echo '#You can run $(./up.sh) to directly export the environment variables on container start or copy the export calls into your shell'
