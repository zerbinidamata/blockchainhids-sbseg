#/bin/bash

#Below command will stop the running docker containers.
echo "****** Stopping the running containers...... ************"
docker-compose -f docker-compose.yaml down

echo""
echo "*********** Removing unused networks...... **************"
docker network prune
echo""
echo "*********** Removing all unused local volumes.... *******"
docker volume prune