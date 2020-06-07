#/bin/bash

CHANNEL_NAME="mychannel"

echo "starting the network....."
docker-compose -f docker-compose.yaml up -d


echo "****** Creating the channel ***************"

# Create the channel
docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp"  -e "CORE_PEER_ADDRESS=peer0.org2.example.com:7051" -e "CORE_PEER_LOCALMSPID=Org2MSP" Org2-cli peer channel fetch 0 -o orderer.example.com:7050 -c $CHANNEL_NAME

sleep 2

docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.example.com:7051" -e "CORE_PEER_LOCALMSPID=Org2MSP" Org2-cli peer channel join -b $CHANNEL_NAME"_0".block

sleep 2 

docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer1.org2.example.com:7051" -e "CORE_PEER_LOCALMSPID=Org2MSP" Org2-cli peer channel join -b $CHANNEL_NAME"_0".block

sleep 2
# echo "*********** Updating anchor peers of Org2 ********************"
docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e  "CORE_PEER_ADDRESS=peer0.org2.example.com:7051" -e "CORE_PEER_LOCALMSPID=Org2MSP" Org2-cli peer channel update -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org2MSPanchors.tx

#**********************************************************************************************************************************************************************
