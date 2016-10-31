#!/bin/zsh

#mount and configure first mysql
echo -e "\n\e[32mMounting first mysql\e[39m"
vault mount -path /mysql/local-docker mysql 1>/dev/null
echo -e "\n\t\e[32m- Setting up connection first\e[39m"
vault write  /mysql/local-docker/config/connection \
  connection_url="root:root@tcp(vault_mysql-vault-test1_1:3306)/" 1>/dev/null
echo -e "\t\e[32m- Creating mysql role\e[39m"
vault write mysql/local-docker/roles/usage-user \
  sql="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT USAGE ON *.* TO '{{name}}'@'%';" 1>/dev/null
echo -e "\t\e[32m- Updating lease\e[39m"
vault write mysql/local-docker/config/lease lease=3h lease_max=36h 1>/dev/null

#mount and configure second mysql
echo -e "\n\e[32mMounting second mysql\e[39m"
vault mount -path /mysql/local-docker-other mysql 1>/dev/null
echo -e "\n\t\e[32m- Setting up connection first\e[39m"
vault write  /mysql/local-docker-other/config/connection \
  connection_url="root:root@tcp(vault_mysql-vault-test2_1:3306)/" 1>/dev/null
echo -e "\t\e[32m- Creating mysql role\e[39m"
vault write mysql/local-docker-other/roles/usage-user \
  sql="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT USAGE ON *.* TO '{{name}}'@'%';" 1>/dev/null
echo -e "\t\e[32m- Updating lease\e[39m"
vault write mysql/local-docker-other/config/lease lease=26h lease_max=240h 1>/dev/null

#getting usage creds for first mysql
#this happens using your root token
echo -e "\n\e[32mExecuting: 'vault read mysql/local-docker/creds/usage-user'\e[39m"
vault read mysql/local-docker/creds/usage-user

#getting usage creds for second mysql
#this happens using your root token
echo -e "\n\e[32mExecuting: 'vault read mysql/local-docker-other/creds/usage-user'\e[39m"
vault read mysql/local-docker-other/creds/usage-user
