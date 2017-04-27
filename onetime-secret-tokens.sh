#!/bin/bash
GREEN="\033[0;32m"
RED="\033[0;31m"
CLEAR="\033[0m"

echo -e "\n${GREEN}creating  secret /secret/staging/staging_app${CLEAR}"
echo -e "Executing:\nvault write /secret/staging/staging_app user=someuser password=somepass ttl=1h\n"
echo -e "Output:"
vault write /secret/staging/staging_app user=someuser password=somepass ttl=1h

echo -e "\n\n${GREEN}creating  secret /secret/production/production_app${CLEAR}"
echo -e "Executing:\nvault write /secret/production/production_app user=someotheruser password=someotherpass ttl=2h\n"
echo -e "Output:"
vault write /secret/production/production_app user=someotheruser password=someotherpass ttl=2h

echo -e "\n\n${GREEN}creating secret-read onetime token${CLEAR}"
cat << 'EOF'
Executing:
TOKEN=$(vault token-create -no-default-policy \
  -policy=secret-read \
  -ttl=30m \
  -explicit-max-ttl=2h \
  -use-limit=1 \
  -metadata "group=staging" | grep -e '^token ' | awk '{print $2}')

EOF
TOKEN=$(vault token-create -no-default-policy \
  -policy=secret-read \
  -ttl=30m \
  -explicit-max-ttl=2h \
  -use-limit=1 \
  -metadata "group=staging" | grep -e '^token ' | awk '{print $2}')
echo -e "token : $TOKEN"

echo -e "\n\n${GREEN}First try on staging credentials - will succeed${CLEAR}"
echo -e "Executing:\ncurl -H\"X-Vault-Token: $TOKEN\" \"http://127.0.0.1:8200/v1/secret/staging/staging_app\"\n"
echo -e "Output:"
curl -H"X-Vault-Token: $TOKEN" "http://127.0.0.1:8200/v1/secret/staging/staging_app"
sleep 2

echo -e "\n\n${RED}Second try on staging credentials - will fail because it was a onetime token${CLEAR}"
echo -e "Executing:\ncurl -H\"X-Vault-Token: $TOKEN\" \"http://127.0.0.1:8200/v1/secret/staging/staging_app\"\n"
echo -e "Output:"
curl -H"X-Vault-Token: $TOKEN" "http://127.0.0.1:8200/v1/secret/staging/staging_app"
sleep 2

echo -e "\n\n${GREEN}creating new secret-read onetime token:${CLEAR}"
cat << 'EOF'
Executing:
TOKEN=$(vault token-create -no-default-policy \
  -policy=secret-read \
  -ttl=30m \
  -explicit-max-ttl=2h \
  -use-limit=1 \
  -metadata "group=staging" | grep -e '^token ' | awk '{print $2}')

EOF
TOKEN=$(vault token-create -no-default-policy \
  -policy=secret-read \
  -ttl=30m \
  -explicit-max-ttl=2h \
  -use-limit=1 \
  -metadata "group=staging" | grep -e '^token ' | awk '{print $2}')
echo -e "token : $TOKEN"

echo -e "\n${RED}First try on production credentials - will fail because of missing permissions${CLEAR}"
echo -e "Executing:\ncurl -H\"X-Vault-Token: $TOKEN\" \"http://127.0.0.1:8200/v1/secret/production/production_app\"\n"
curl -H"X-Vault-Token: $TOKEN" "http://127.0.0.1:8200/v1/secret/production/production_app"
sleep 2

echo -e "\n${RED}Second try on staging credentials - will fail because it was a onetime token${CLEAR}"
echo -e "Executing:\ncurl -H\"X-Vault-Token: $TOKEN\" \"http://127.0.0.1:8200/v1/secret/statging/staging_app\"\n"
curl -H"X-Vault-Token: $TOKEN" "http://127.0.0.1:8200/v1/secret/statging/staging_app"
sleep 2

echo -e "\n\n${GREEN}creating new secret-read token with reponse wrapping:${CLEAR}"
cat << 'EOF'
Executing:
WRAPPING_TOKEN=$(vault read -wrap-ttl=10m /secret/staging/staging_app | grep -e '^wrapping_token:' | awk '{print $2}')

EOF

WRAPPING_TOKEN=$(vault read -wrap-ttl=10m /secret/staging/staging_app | grep -e '^wrapping_token:' | awk '{print $2}')
echo -e "warpping token : $WRAPPING_TOKEN"


echo -e "\n${GREEN}Get the secret the first time - will work${CLEAR}"
echo -e "Executing:\nvault unwrap $WRAPPING_TOKEN\n"
echo -e "Output:"
vault unwrap $WRAPPING_TOKEN
sleep 2

echo -e "\n${RED}Get the secret the second time - will not work${CLEAR}"
echo -e "Executing:\nvault unwrap $WRAPPING_TOKEN\n"
echo -e "Output:"
vault unwrap $WRAPPING_TOKEN
sleep 2
