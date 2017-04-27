# General

This is a small example of what can be done with. I created this to deonstrate some very basic concepts.

This example shows how to :
 - mount the mysql backend using the vault cli
 - write policies using the vault cli
 - create a token that is only valid for one request and how to use it to get a secret using curl

 Please execute the scripts in the following order :
  - up.sh
  - policies.sh
  - mysql.sh
  - onetime-secret-token.sh

In order to run this example you need [```docker-compose```](www.docker.com) and [```vault```](www.vaultproject.io) installed on you machine.

The scripts output all executed commands so you do not need to look into the scripts to see what is getting executed.

# Scripts
## up.sh
This script starts all needed docker containers and outputs the export calls to add needed environment variables to your shell.
You can also run ```$(./up.sh)``` to export the variables directly.

## down.sh
This script removes the containers and all files created by vault.

## policies.sh
This script demonstrates how to write policies and how to create tokes for those policies using the cli. The rules used to create the policies can be fould in the ```hcl/``` folder.

## mysql.sh
This script shows how to mount mysql databases as secret backends into vault and how to retrieve credentials using those backends.

## onetime-secret-tokens.sh
This script shows how to create a token that is only valid for one request and how vault behaves when the token is used more than once.
It will also show how to use response  wrapping to let vault take care of the limiting.

# Further reading
  - [cli](https://www.vaultproject.io/docs/commands/index.html)
  - [http api](https://www.vaultproject.io/docs/http/index.html)
  - [configuration](https://www.vaultproject.io/docs/config/) (go here to find infos about storage backends)
  - [secret backends](https://www.vaultproject.io/docs/secrets/index.html)
  - [auth backends](https://www.vaultproject.io/docs/auth/index.html)
  - [audit backends](https://www.vaultproject.io/docs/audit/index.html)
