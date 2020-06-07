## Understanding crypto-config.yaml
___

Crypto-config is a file which contains the information about your network participants. e.g., Organizations, Peers, Orderers etc.

This file is required to generate cryptographic material for above participants.

Hyperledger Fabric has provided a binary tool `"cryptogen"` using which we can generate the crypto-material for our network participants.

Contents of the crypto-config.yaml file:

* Organization details
* Peer details of each Org
* User details of each Org

```yaml
OrdererOrgs:
  - Name: Orderer
    Domain: example.com
    Specs:
      - Hostname: orderer
```

In above example

* OrdererOrgs:  
  - It contains the definition of organizations which will host the orderer nodes.
  - Certificates are tied to specific domain.
  - `Name`:  Name of the Orderer Org  
  - `Domain`: It acts as a namespace for your project.
     - Peers / Orderers will run under this domain.
     - Using domain name other parties will try fo find your peer / orderer.
     - In our example, “Name of the Orderer is **“Orderer”** & the domain is **example.com** So the final name for this Orderer will be `“{{.Hostname}}.{{.Domain}}”` i.e **`“orderer.example.com”`**
  - > Note : In this case we have only one orderer and which is used only for Developement purpose. This is not recommended for production use as this is a single point of failure. 


```yaml
PeerOrgs:
  - Name: Org1
    Domain: org1.example.com
    EnableNodeOUs: true
    Template:
      Count: 2
    Users:
      Count: 1
 ```

* PeerOrgs:
  - It contains the information about peer Organizations in the network. 
  - We can have `n` no of Org in the network.
  - Here `Org1` indicates the name of the Peer Org, and it is a part of the domain `example.com`, so the final name for this org is `{{.Hostname}}.{{.Domain}}”` i.e., `org1.example.com`
  - EnableNodeOUs : this indicates ability to classify identities as either a “client” or a “peer”. 
  - This allows you to create policies such as `Org.peer` and `Org.client` in addition to the existing `Org.member` and `Org.admin`
  - Template: 
    - Count : this indicates how many peers will be created under this Org.
  - Users:
    - Count: this indicates how many pre-defined user accounts to create in addition to admin.
  - The above code acts as a template to create more Org. 
