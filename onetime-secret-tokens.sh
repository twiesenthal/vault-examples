#!/bin/zsh

echo -e "\n\e[32mcreating  secret /secret/staging/staging_app\e[39m"
vault write /secret/staging/staging_app user=someuser password=somepass ttl=1h
echo -e "\n\e[32mcreating  secret /secret/production/production_app\e[39m"
vault write /secret/production/production_app user=someotheruser password=someotherpass ttl=2h

echo -e "\n\e[32mcreating secret-read onetime token\e[39m"
TOKEN=$(vault token-create -no-default-policy \
  -policy=secret-read \
  -ttl=30m \
  -explicit-max-ttl=2h \
  -use-limit=1 \
  -metadata "group=staging" | grep -e '^token ' | awk '{print $2}')

echo -e "\n\e[32mFirst try on staging credentials - will succeed\e[39m"
sleep 5
curl  -v -H"X-Vault-Token: $TOKEN" "http://127.0.0.1:8200/v1/secret/staging/staging_app" 2>/dev/null
echo -e "\n\e[31mSecond try on staging credentials - will fail because it was a onetime token\e[39m"
sleep 2
curl  -v -H"X-Vault-Token: $TOKEN" "http://127.0.0.1:8200/v1/secret/staging/staging_app" 2>/dev/null

sleep 5
echo -e "\n\n\e[32mcreating new secret-read onetime token:\e[39m"
TOKEN=$(vault token-create -no-default-policy \
  -policy=secret-read \
  -ttl=30m \
  -explicit-max-ttl=2h \
  -use-limit=1 \
  -metadata "group=staging" | grep -e '^token ' | awk '{print $2}')

echo -e "\n\e[31mFirst try on production credentials - will fail because of missing permissions\e[39m"
sleep 5
curl  -v -H"X-Vault-Token: $TOKEN" "http://127.0.0.1:8200/v1/secret/production/production_app" 2>/dev/null
echo -e "\n\e[31mSecond try on staging credentials - will fail because it was a onetime token\e[39m"
sleep 2
curl  -v -H"X-Vault-Token: $TOKEN" "http://127.0.0.1:8200/v1/secret/statging/staging_app" 2>/dev/null

sleep 5
echo -e "\n\n\e[32mcreating new secret-read token with reponse wrapping:\e[39m"
WRAPPING_TOKEN=$(vault read -wrap-ttl=10m /secret/staging/staging_app | grep -e '^wrapping_token:' | awk '{print $2}')
echo $WRAPPING_TOKEN
echo -e "\n\e[32mGet the secret the first time - will work\e[39m"
sleep 5
vault unwrap $WRAPPING_TOKEN 2>/dev/null
echo -e "\n\e[31mGet the secret the second time - will not work\e[39m"
sleep 2
vault unwrap $WRAPPING_TOKEN
