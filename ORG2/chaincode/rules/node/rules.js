/*
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
*/

"use strict";
const shim = require("fabric-shim");
const util = require("util");

let Chaincode = class {
  // The Init method is called when the Smart Contract 'fabcar' is instantiated by the blockchain network
  // Best practice is to have any Ledger initialization in separate function -- see initLedger()
  async Init(stub) {
    console.info("=========== Instantiated fabcar chaincode ===========");
    return shim.success();
  }

  // The Invoke method is called as a result of an application request to run the Smart Contract
  // 'fabcar'. The calling application program has also specified the particular smart contract
  // function to be called, with arguments
  async Invoke(stub) {
    let ret = stub.getFunctionAndParameters();
    console.info(ret);

    let method = this[ret.fcn];
    if (!method) {
      console.error("no function of name:" + ret.fcn + " found");
      throw new Error("Received unknown function " + ret.fcn + " invocation");
    }
    try {
      let payload = await method(stub, ret.params);
      return shim.success(payload);
    } catch (err) {
      console.log(err);
      return shim.error(err);
    }
  }

  async queryRule(stub, args) {
    if (args.length != 1) {
      throw new Error(
        "Incorrect number of arguments. Expecting RuleNumber ex: RULE01"
      );
    }
    let ruleNumber = args[0];

    let ruleAsBytes = await stub.getState(ruleNumber); //get the rule from chaincode state
    if (!ruleAsBytes || ruleAsBytes.toString().length <= 0) {
      throw new Error(ruleNumber + " does not exist: ");
    }
    console.log(ruleAsBytes.toString());
    return ruleAsBytes;
  }

  async initLedger(stub, args) {
    console.info("============= START : Initialize Ledger ===========");
    let rules = [];
    rules.push({
      name: "Toyota",
      premise: "Prius",
      action: "blue",
      test_case: "Tomoko",
    });

    for (let i = 0; i < rules.length; i++) {
      rules[i].docType = "rule";
      await stub.putState("RULE" + i, Buffer.from(JSON.stringify(rules[i])));
      console.info("Added <--> ", rules[i]);
    }
    console.info("============= END : Initialize Ledger ===========");
  }

  async createRule(stub, args) {
    console.info("============= START : Create Rule ===========");
    if (args.length != 5) {
      throw new Error("Incorrect number of arguments. Expecting 5");
    }

    var rule = {
      docType: "rule",
      name: args[1],
      premise: args[2],
      action: args[3],
      test_case: args[4],
    };

    await stub.putState(args[0], Buffer.from(JSON.stringify(rule)));
    console.info("============= END : Create Rule ===========");
  }

  async queryAllRules(stub, args) {
    let startKey = "RULE0";
    let endKey = "RULE999";

    let iterator = await stub.getStateByRange(startKey, endKey);

    let allResults = [];
    while (true) {
      let res = await iterator.next();

      if (res.value && res.value.value.toString()) {
        let jsonRes = {};
        console.log(res.value.value.toString("utf8"));

        jsonRes.Key = res.value.key;
        try {
          jsonRes.Record = JSON.parse(res.value.value.toString("utf8"));
        } catch (err) {
          console.log(err);
          jsonRes.Record = res.value.value.toString("utf8");
        }
        allResults.push(jsonRes);
      }
      if (res.done) {
        console.log("end of data");
        await iterator.close();
        console.info(allResults);
        return Buffer.from(JSON.stringify(allResults));
      }
    }
  }
};

shim.start(new Chaincode());
