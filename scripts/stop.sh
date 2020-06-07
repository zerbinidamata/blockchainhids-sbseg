#/bin/bash

echo "##########################################################"
echo "#####         Removing docker containers         #########"
echo "##########################################################"

docker kill $(docker ps -aq)
docker rm -f $(docker ps -aq)
docker network prune 
docker volume prune
