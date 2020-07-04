#/bin/bash

cd ORG1
./start.sh
sleep 5
./installRulesChaincode.sh 
sleep 5
cd ../ORG2
./start.sh
sleep 5
./installRulesChaincode.sh 
sleep 5
cd controller-api
yarn && yarn run dev
sleep 5
open 'http://localhost:5984/_utils/#/database/mychannel_rules/_all_docs'