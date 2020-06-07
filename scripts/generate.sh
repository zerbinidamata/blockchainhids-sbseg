#/bin/bash

CHANNEL_NAME="mychannel"

echo "##########################################################"
echo "##### Generate certificates using cryptogen tool #########"
echo "##########################################################"

if [ -d "crypto-config" ]; then
    rm -Rf crypto-config
fi
./bin/cryptogen generate --config=./crypto-config.yaml
export FABRIC_CFG_PATH=$PWD

sleep 2

echo "##########################################################"
echo "#########  Generating Orderer Genesis block ##############"
echo "##########################################################"

if [ -d "channel-artifacts" ]; then
    rm -Rf channel-artifacts/*
else
    mkdir -p channel-artifacts
fi

./bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block

sleep 2

echo
echo "#################################################################"
echo "### Generating channel configuration transaction 'channel.tx' ###"
echo "#################################################################"

./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME

sleep 2

echo
echo "#################################################################"
echo "#######    Generating anchor peer update for Org1MSP   ##########"
echo "#################################################################"

./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP

sleep 2

echo
echo "#################################################################"
echo "#######    Generating anchor peer update for Org2MSP   ##########"
echo "#################################################################"

./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP

echo
echo "################################################################################################################################"
echo "#                                                         NOTE :                                                               #"
echo "Replace the FABRIC_CA_SERVER_CA_KEYFILE in docker-compose-cli.yaml from crypto-config/peerOrganizations/org1.example.com/ca/   #"
echo "#################################################################################################################################"

sleep 2

echo
echo "#################################################################"
echo "#######  Copying Crypto-material to ORG and ORG2       ##########"
echo "#################################################################"

rm -rf ./../ORG1/crypto-config/
rm -rf ./../ORG1/channel-artifacts/ && mkdir -p ./../ORG1/channel-artifacts

rm -rf ./../ORG2/crypto-config/
rm -rf ./../ORG2/channel-artifacts/ && mkdir -p ./../ORG2/channel-artifacts

cp -r ./crypto-config/ ./../ORG1/
cp -r ./channel-artifacts ./../ORG1/

cp -r ./crypto-config/ ./../ORG2/
cp -r ./channel-artifacts ./../ORG2/
