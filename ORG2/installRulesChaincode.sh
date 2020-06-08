#!/bin/bash
#INSTALL CHAINCODE ON ORG2 PEER(S)

CHANNEL_NAME="mychannel"
CHAINCODE_NAME="rules"
CHAINCODE_LANGUAGE="node"
CHAINCODE_VERSION="1.0.0"
CHAINCODE_PATH="/opt/gopath/src/github.com/chaincode/rules/node/"

# install on peer0.org2
echo "*******Installing chaincode on peer0.org2 ********************"
docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.example.com:7051" -e "CORE_PEER_LOCALMSPID=Org2MSP" Org2-cli peer chaincode install -n $CHAINCODE_NAME -v $CHAINCODE_VERSION -l $CHAINCODE_LANGUAGE -p $CHAINCODE_PATH

# echo "*******Quering chaincode on channel from ORG-2 ********************"
# docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.example.com:7051" -e "CORE_PEER_LOCALMSPID=Org2MSP" peer0.org2.example.com peer chaincode query -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["queryAllIncidents","INCIDENT1","INCIDENT9"]}'