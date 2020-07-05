#!/bin/bash

CHAINCODE_NAME="rules"
CHAINCODE_SRC="/opt/gopath/src/github.com/chaincode/rules/node"
CHAINCODE_VERSION="1.0.0"
CHANNEL_NAME="mychannel"

id=$1
name=$2
premise=$3
action=$4
test=$5

 #docker exec Org1-cli peer chaincode invoke -o orderer.example.com:7050 -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["createRule", "RULE 2", "Name", "Premise", "Action", "Test Case"]}'
docker exec Org1-cli peer chaincode invoke -o orderer.example.com:7050 -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["createRule", '"$1"', '"$2"', '"$3"', '"$4"', '"$5"']}'
