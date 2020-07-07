#/bin/bash

cd ORG1
./start.sh
sleep 5
./installRulesChaincode.sh 
sleep 5
cd controller-api/
yarn
pm2 start yarn --name api.org1 -- dev
cd ../../ORG2
./start.sh
sleep 5
./installRulesChaincode.sh 
sleep 5
cd controller-api
yarn
pm2 start yarn --name api.org2 -- dev
sleep 5
open 'http://localhost:5984/_utils/#/database/mychannel_rules/_all_docs'