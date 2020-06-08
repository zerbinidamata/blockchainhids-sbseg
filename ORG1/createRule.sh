#!/bin/bash

CHAINCODE_NAME="rules"
CHAINCODE_SRC="/opt/gopath/src/github.com/chaincode/rules/node"
CHAINCODE_VERSION="1.0.0"
CHANNEL_NAME="mychannel"

docker exec Org1-cli peer chaincode invoke -o orderer.example.com:7050 -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["createRule", "RULE2", "Name", "Premise", "Action", "Test Case"]}'
