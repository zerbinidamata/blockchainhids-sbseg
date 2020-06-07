## Understanding configtx.yaml 
___

Configtx.yaml is used to create 
- genesis block
  - This block is the first block on a chain and it initializes the ordering servie.
- channels in the network
  - Channel allows a group of participants to create a separate ledger
of transactions

Contents of the configtx.yaml  
1. Organizations Section  
2. Orderer Section  
3. Application Section  
4. Capabilities Section  
5. Profile Section  


* **Organizations Section**:  
     ```yaml
    Organizations:

    #Development use only. Not sutailble for production

    - &OrdererOrg
        Name: OrdererOrg
        ID: OrdererMSP
        MSPDir: crypto-config/ordererOrganizations/example.com/msp
    ```
   - This section contains the Org details. It could be Orderer or Peer
   - Here `Name` is the name of the Orderer Organization
   - `ID` is the name of the Membership Service Provider (MSP) of OrdererOrg.
   - `MSPDir` is the actual location where the crypto material for OrdererMSP is available.
   - We have created this directory using crypto-config.yaml file.  

   ```yaml
    - &Org1
        Name: Org1MSP
        ID: Org1MSP
        MSPDir: crypto-config/peerOrganizations/org1.example.com/msp
        AnchorPeers:
            - Host: peer0.org1.example.com
              Port: 7051
  ```  
  Here `Name` is the name of the Peer Organization.
  - `ID` is the name of the Membership Service Provider of Peer Org (MSP).
  - `MSPDir` is the actual location where the crypto material for PeerOrg is available.
  - `Anchor Peers` : This defines the location of peers which can be used for cross Org gossip communication.
     - This configuration/ value gets encoded in the genesis block.
     - Only this peer can connect/communicate to the Anchor Peers of different Org.  

* **Orderer Section:**  
    ```yaml
        Orderer: &OrdererDefaults
        OrdererType: solo
        Addresses:
            - orderer.example.com:7050

        BatchTimeout: 2s
        BatchSize:
            MaxMessageCount: 10
            AbsoluteMaxBytes: 99 MB
            PreferredMaxBytes: 512 KB  
    ```  
   - Orderer has two types
        - Solo : for Development use only
        - Kafka : Multi-orderer sutaible for production use
   - `Addresses`: This contains host and port details of orderer.
   - `BatchTimeout`: This value decides when to create a block.
   - In this example block will get created after 2s.(only when transaction gets received)
   - BatchSize:  
        - `MaxMessageCount`: This value specifies when to create a batch of Tx. i.e, max no of Tx. in a batch
        - `AbsoluteMaxBytes:` maximum number of bytes allowed for the serialized messages in a batch.  
        - `PreferredMaxBytes` : The preferred maximum number of bytes allowed for the serialized messages in a batch. A message larger than the preferred max bytes will result in a batch larger than preferred max bytes.
    -    >Note: With above configuration, block will get created after 2s or once we get 10Tx. (whichever comes first)  

* **Profile Section:**
    - This is very important section in the configtx.yaml file.
    - This section has two main parts
      - Genesis Block details
      - Channel Details  
      
    ```yaml  
        # Genesis Block Details
    
        Profiles:

            TwoOrgsOrdererGenesis:
            <<: *ChannelDefaults
            Orderer:
                <<: *OrdererDefaults
                Organizations:
                    - *OrdererOrg
                Capabilities:
                    <<: *OrdererCapabilities

    ```  
    - In above code we have created one profile named as `TwoOrgsOrdererGenesis` which is created for Orderer.
    - This will create a genesis block.
    - `Orderer` mentions that this profile is for Orderer
    - `OrdererDefaults`: It refers to the settings for the orderer. 
    - `Organizations` mentions the name of Orderer Organizations
    - `*OrdererOrg` contains the orderer cryptographic material and MSPID  
    > Note:  
    ```yaml
    <<: *ChannelDefaults 
    ```    
    - This syntax tells that copy the contents of ChannelDefaults and put it in the place of `<<:`
    - i.e This will try to find the name `&ChannelDefaults` and will put all the content in profile section.  

    ```yaml  
        Consortiums:
            SampleConsortium:
                Organizations:
                    - *Org1
                    - *Org2
    ```  
    - This section creates a logical consortium with the name SampleConsortium and includes Org1 & Org2 in it.
    - This secction mentions to which Org this orderer will serve, becaue Orderer can serve multiple Org.
    - In our case it is Org1 & Org2.
    > Note:  `*Org1` referes to the content of `&Org1`
    - Finally the genesis block will include public key of Org1 and Org2 so orderer can verify the requestes coming from each Org.  

* **Channel Section:**  
    ```yaml
       TwoOrgsChannel:
            Consortium: SampleConsortium
            Application:
                <<: *ApplicationDefaults
                Organizations:
                    - *Org1
                    - *Org2
    ```  
    - This section also does the same job as above i.e.,
        - creates consortium
        - Mention which Org will be part of the channel
