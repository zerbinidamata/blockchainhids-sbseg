#/bin/bash

CHAINCODE_NAME="rules"
CHAINCODE_SRC="/opt/gopath/src/github.com/chaincode/rules/node"
CHAINCODE_VERSION="1.0.0"
CHANNEL_NAME="mychannel"

docker exec Org2-cli peer chaincode query -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["queryAllCars"]}'

#docker exec Org1-cli peer chaincode query -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["queryCar","CAR05"]}'
