import Rules from "../models/Rules";
import { exec } from "child_process";

class RulesController {
    // GET
    async index(req, res) {
        console.log("GET /rules");

        try {
            if (req.query.rule) {
                const rules = await Rules.find({
                    name: { $all: req.query.rule },
                });

                return res.status(200).json(rules);
            }

            const rules = await Rules.find();

            return res.status(200).json(rules);
        } catch (err) {
            return res.status(500).json({ error: err });
        }
    }

    // POST
    async store(req, res) {
        const { name } = req.body;

        const verification = await Rules.findOne({ name });

        if (verification) {
            return res.status(400).json({ message: "Rule already exists" });
        }
        try {
            const rule = await Rules.create(req.body);

            req.io.emit("rules", rule);

            const {
                name,
                action,
                promise,
                test_case,
                blockchain_shared,
            } = req.body;

            console.log(req.body);

            if (blockchain_shared) {
                exec(
                    //TODO: exportar path como env var
                    `/Users/rafael/Documents/GitHub/uiot/blockchainhids-sbseg/ORG2/createRule.sh '"${name}"' '"${name}"' '"${promise}"' '"${action}"' '"${test_case}"'`,
                    (error, stdout, stderr) => {
                        if (error) {
                            console.log(`error: ${error.message}"`);
                            return;
                        }
                        if (stderr) {
                            console.log(`stderr: ${stderr}`);
                            return;
                        }
                        console.log(`stdout: ${stdout}`);
                    }
                );
            }

            return res.status(201).json(req.body);
        } catch (err) {
            return res.status(500).json({ error: err });
        }
    }

    // PUT
    async update(req, res) {
        const RuleToUpdate = await Rules.findOne({
            id: req.params.id,
        });

        if (!RuleToUpdate) {
            return res
                .status(400)
                .json({ error: "Rule requested doesn't exists." });
        }

        const rule = await Rules.update(req.body);

        req.io.emit("rules", req.body);

        return res.status(201).json({ message: "Updated!" });
    }

    // DELETE
    async delete(req, res) {
        const RulesToDelete = await Rules.findOne({
            id: req.params.id,
        });

        if (!RulesToDelete) {
            return res.status(500).json({ error: "Rule doesn't exists." });
        }

        const result = await Rules.deleteOne({ id: req.params.id });

        return res.status(204).json({ message: "Rule has been deleted." });
    }
}

export default new RulesController();
