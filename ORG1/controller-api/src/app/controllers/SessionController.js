import jwt from "jsonwebtoken";
import Device from "../models/Device";

import auth from "../../config/auth";

class SessionController {
    async store(req, res) {
        const { device_name } = req.body;
        const password = "123456";
        try {
            const device = await Device.findOne({
                device_name,
            });

            if (!device) {
                return res
                    .status(404)
                    .json({ message: `Device ${device_name} not found.` });
            }

            if (!(await Device.checkPassword(password))) {
                return res
                    .status(401)
                    .json({ message: "Password does not match." });
            }

            const { id, name } = device;

            return res.json({
                device: {
                    id,
                    name,
                },
                token: jwt.sign({ id }, auth.secret, {
                    expiresIn: auth.expiresIn,
                }),
            });
        } catch (err) {
            return res.status(500).json({ message: `${err}` });
        }
    }
}

export default new SessionController();
