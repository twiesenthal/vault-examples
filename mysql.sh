#!/bin/bash
GREEN="\033[0;32m"
CLEAR="\033[0m"
#mount and configure first mysql
echo -e "\n${GREEN}Mounting first mysql${CLEAR}"
echo -e "Executing:\nvault mount -path /mysql/local-docker mysql\n"
echo -e "Output:"
vault mount -path /mysql/local-docker mysql

echo -e "\n\n${GREEN}Setting up connection to first mysql${CLEAR}"
cat << 'EOF'
Executing:
vault write  /mysql/local-docker/config/connection \
  connection_url="root:root@tcp(vaultexample_mysql1:3306)/"
EOF
echo -e "Output:"
vault write  /mysql/local-docker/config/connection \
  connection_url="root:root@tcp(vaultexample_mysql1:3306)/"

echo -e "\n\n${GREEN}Creating mysql role for first mysql${CLEAR}"
cat << 'EOF'
Executing:
vault write mysql/local-docker/roles/usage-user \
  sql="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT USAGE ON *.* TO '{{name}}'@'%';"
EOF
echo -e "Output:"
vault write mysql/local-docker/roles/usage-user \
  sql="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT USAGE ON *.* TO '{{name}}'@'%';"

echo -e "\n\n${GREEN}Updating lease for first mysql${CLEAR}"
echo -e "Executing:\nvault write mysql/local-docker/config/lease lease=3h lease_max=36h\n"
echo -e "Output:"
vault write mysql/local-docker/config/lease lease=3h lease_max=36h

#mount and configure second mysql
echo -e "\n\n${GREEN}Mounting second mysql${CLEAR}"
echo -e "Executing:\nvault mount -path /mysql/local-docker-other mysql\n"
echo -e "Output:"
vault mount -path /mysql/local-docker-other mysql

echo -e "\n\n${GREEN}- Setting up connection to second mysql${CLEAR}"
cat << 'EOF'
Executing:
vault write  /mysql/local-docker-other/config/connection \
  connection_url="root:root@tcp(vaultexample_mysql2:3306)/"
EOF
echo -e "Output:"
vault write  /mysql/local-docker-other/config/connection \
  connection_url="root:root@tcp(vaultexample_mysql2:3306)/"

echo -e "\n\n${GREEN}Creating mysql role for second mysql${CLEAR}"
cat << 'EOF'
Executing:
vault write mysql/local-docker-other/roles/usage-user \
  sql="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT USAGE ON *.* TO '{{name}}'@'%';"
EOF
echo -e "Output:"
vault write mysql/local-docker-other/roles/usage-user \
  sql="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT USAGE ON *.* TO '{{name}}'@'%';"

echo -e "\n\n${GREEN}Updating lease for second mysql${CLEAR}"
echo -e "Executing:\nvault write mysql/local-docker-other/config/lease lease=26h lease_max=240h\n"
echo -e "Output:"
vault write mysql/local-docker-other/config/lease lease=26h lease_max=240h

#getting usage creds for first mysql
#this happens using your root token
echo -e "\n\n${GREEN}Getting usage creds for first mysql${CLEAR}"
echo -e "${GREEN}This happens using your root token${CLEAR}"
echo -e "Executing:\nvault read mysql/local-docker/creds/usage-user\n"
echo -e "Output:"
vault read mysql/local-docker/creds/usage-user

#getting usage creds for second mysql
#this happens using your root token
echo -e "\n${GREEN}Getting usage creds for second mysql${CLEAR}"
echo -e "${GREEN}This also happens using your root token${CLEAR}"
echo -e "Executing:\nvault read mysql/local-docker-other/creds/usage-user\n"
echo -e "Output:"
vault read mysql/local-docker-other/creds/usage-user
