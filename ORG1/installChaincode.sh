#/bin/bash

CHANNEL_NAME="mychannel"
CHAINCODE_NAME="fabcar"
CHAINCODE_VERSION="1.0.0"
CHAINCODE_PATH="/opt/gopath/src/github.com/chaincode/fabcar/node/"
CHAINCDE_LANGUAGE="node"

echo "****************** Installing Chaincode *****************************"
# #Install & Instantiate Chaincode

#working
# install on peer0.org1
 echo "*******Installing chaincode on peer0.org1 ********************"
 docker exec -e  "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org1.example.com:7051" -e "CORE_PEER_LOCALMSPID=Org1MSP" Org1-cli peer chaincode install -n $CHAINCODE_NAME -v $CHAINCODE_VERSION -l $CHAINCDE_LANGUAGE -p $CHAINCODE_PATH

sleep 3

echo "*******Instantiating chaincode on channel ********************"
docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org1.example.com:7051" -e "CORE_PEER_LOCALMSPID=Org1MSP" Org1-cli peer chaincode instantiate -o orderer.example.com:7050 -C $CHANNEL_NAME -n $CHAINCODE_NAME -l $CHAINCDE_LANGUAGE -v $CHAINCODE_VERSION -c '{"Args":[""]}' -P "OR ('Org1MSP.peer','Org2MSP.peer')"
