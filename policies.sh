#!/bin/bash
GREEN="\033[0;32m"
CLEAR="\033[0m"

echo -e "\n${GREEN}Writing mysql-admin policy${CLEAR}"
echo -e "Executing:\nvault policy-write mysql-admin hcl/mysql-admin.hcl\n"
echo -e "Output:"
vault policy-write mysql-admin hcl/mysql-admin.hcl

echo -e "\n\n${GREEN}create mysql-admin token:${CLEAR}"
echo -e "Executing:\nvault token-create -no-default-policy -policy=mysql-admin\n"
echo -e "Output:"
vault token-create -no-default-policy -policy=mysql-admin

echo -e "\n${GREEN}Writing mysql-read policy${CLEAR}"
echo -e "Executing:\nvault policy-write mysql-read hcl/mysql-read.hcl\n"
echo -e "Output:"
vault policy-write mysql-read hcl/mysql-read.hcl

echo -e "\n\n${GREEN}create mysql-read token:${CLEAR}"
echo -e "Executing:\nvault token-create -no-default-policy -policy=mysql-read\n"
echo -e "Output:"
vault token-create -no-default-policy -policy=mysql-read

echo -e "\n${GREEN}Writing secret-admin policy${CLEAR}"
echo -e "Executing:\nvault policy-write secret-admin hcl/secret-admin.hcl\n"
echo -e "Output:"
vault policy-write secret-admin hcl/secret-admin.hcl

echo -e "\n\n${GREEN}create secret-admin token:${CLEAR}"
echo -e "Executing:\nvault token-create -no-default-policy -policy=secret-admin\n"
echo -e "Output:"
vault token-create -no-default-policy -policy=secret-admin

echo -e "\n${GREEN}Writing secret-read policy${CLEAR}"
echo -e "Executing:\nvault policy-write secret-read hcl/secret-read.hcl\n"
echo -e "Output:"
vault policy-write secret-read hcl/secret-read.hcl

echo -e "\n\n${GREEN}create secret-read token:${CLEAR}"
cat  << 'EOF'
Executing:
vault token-create -no-default-policy \
  -policy=secret-read \
  -ttl=30m \
  -explicit-max-ttl=2h \
  -use-limit=10 \
  -metadata "group=staging"

EOF
echo -e "Output:"
vault token-create -no-default-policy \
  -policy=secret-read \
  -ttl=30m \
  -explicit-max-ttl=2h \
  -use-limit=10 \
  -metadata "group=staging"
