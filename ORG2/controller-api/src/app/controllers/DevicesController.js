import Device from "../models/Device";

class DeviceController {
    async index(req, res) {
        try {
            const devices = await Device.find();

            return res.json(devices);
        } catch (err) {
            return res.status(500).json({ error: err });
        }
    }

    async store(req, res) {
        const { device_name } = req.body;

        try {
            const verifyDevice = await Device.findOne({ device_name });

            if (verifyDevice) {
                return res.json({ message: "Device already exists." });
            }

            const device = await Device.create(req.body);

            return res.json(device);
        } catch (err) {
            return res.status(500).json({ error: err });
        }
    }

    async update(req, res) {
        const DeviceToUpdate = await Device.findOne({
            id: req.params.id,
        });

        if (!DeviceToUpdate) {
            return res
                .status(400)
                .json({ error: "Rule requested doesn't exists." });
        }

        const rule = await Device.update(req.body);

        req.io.emit("Device", req.body);

        return res.status(201).json({ message: "Updated!" });
    }
}

export default new DeviceController();
