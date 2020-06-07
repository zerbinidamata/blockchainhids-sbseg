# Understanding Docker-Compose.yaml file
___

Docker Compose is used to run multiple containers as a single service.


```yaml
version: '2'
```
This describes the version of docker compose file.

```yaml
networks:
  byfn:
```
* This describes the name of the network, and docker create the virtual network with the given name.

* Using this we can create the custom network


```yaml
services:
```
* In a distributed application, different pieces of the app are called “services”
* Services are really just “containers in production.”
* So in this section we have defined the containers that are required to run our network.

```yaml
services:

  orderer.example.com:
    container_name: orderer.example.com
    image: hyperledger/fabric-orderer
    environment:
      - ORDERER_GENERAL_LOGLEVEL=debug
      - ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
      - ORDERER_GENERAL_GENESISMETHOD=file
      - ORDERER_GENERAL_GENESISFILE=/var/hyperledger/orderer/orderer.genesis.block
      - ORDERER_GENERAL_LOCALMSPID=OrdererMSP
      - ORDERER_GENERAL_LOCALMSPDIR=/var/hyperledger/orderer/msp
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric
    command: orderer
    volumes:
    - ./channel-artifacts/genesis.block:/var/hyperledger/orderer/orderer.genesis.block
    - ./crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp:/var/hyperledger/orderer/msp
    ports:
      - 7050:7050
    networks:
      - byfn
```

* Here `ca.example.com` is the name of the service
* `image`: this describes the name of image from which this container will be created.
* `environment`: In this we provide the required environment variables for our network. 
   -  `ORDERER_GENERAL_LOGLEVEL`:
      - This sets the loggin level. By default is DEBUG.
      - DEBUG gives lots of information while debugging the application.
      - But DEBUG should not be used for production, as it gives lots if info and degrades the performance.
      - Other log levels are INFO & ERROR
   
   - `ORDERER_GENERAL_LISTENADDRESS`:
     - Every docker container has its own network interface, and we have to provide the interace address from wherer the orderer by default has to accept connections.
     - **0.0.0.0** means orderer will listen for all the interfaces.

  - `ORDERER_GENERAL_GENESISMETHOD`:
    - This specifies  the genesis block info will be in a file.
    - There are other methods available to specify genesis block.
  - `ORDERER_GENERAL_GENESISFILE`:
    - This specifies the location of the actual genesis file.
  - `ORDERER_GENERAL_LOCALMSPID`:
    - This specifies the MSPID for orderer.
    - The name of this MSPID should be identical to the name of MSPID provided in the configtx.yaml file.
  
  - `ORDERER_GENERAL_LOCALMSPDIR`:
    - This specifies the location in the container where the actual certificates are located.

* `working_dir`:This sets the working directory of the container that is created.

* ```yaml
    volumes:
    - ./channel-artifacts/genesis.block:/var/hyperledger/orderer/orderer.genesis.block
    - ./crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp:/var/hyperledger/orderer/msp`
    ```
    * `Volumes`:
      - This are used to mount the directory.
      ```yaml 
         - ./channel-artifacts/genesis.block:/var/hyperledger/orderer/orderer.genesis.block
      ```
      - Above line states that copy the genesis.block present in channel-artifacts from local machine and put it at `/var/hyperledger/orderer/orderer.genesis.block` this location present inside the container.
      - So this actually maps your local machines directory to containers directory.
* `ports`
    - This exposes the mentioned ports to outside network.