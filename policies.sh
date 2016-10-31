#!/bin/zsh

echo -e "\n\e[32mWriting mysql-admin policy\e[39m"
vault policy-write mysql-admin hcl/mysql-admin.hcl

echo -e "\n\e[32mcreate mysql-admin token:\e[39m"
vault token-create -no-default-policy -policy=mysql-admin

echo -e "\n\e[32mWriting mysql-read policy\e[39m"
vault policy-write mysql-read hcl/mysql-read.hcl

echo -e "\n\e[32mcreate mysql-read token:\e[39m"
vault token-create -no-default-policy -policy=mysql-read

echo -e "\n\e[32mWriting secret-admin policy\e[39m"
vault policy-write secret-admin hcl/secret-admin.hcl

echo -e "\n\e[32mcreate secret-admin token:\e[39m"
vault token-create -no-default-policy -policy=secret-admin

echo -e "\n\e[32mWriting secret-read policy\e[39m"
vault policy-write secret-read hcl/secret-read.hcl

echo -e "\n\e[32mcreate secret-read token:\e[39m"
vault token-create -no-default-policy \
  -policy=secret-read \
  -ttl=30m \
  -explicit-max-ttl=2h \
  -use-limit=10 \
  -metadata "group=staging"
