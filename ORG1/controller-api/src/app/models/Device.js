import mongoose, { VirtualType } from "mongoose";
import autoIncrement from "mongoose-auto-increment";
import bcrypt from "bcrypt";

import conn from "../../config/dbConnection";

mongoose.connect(conn.url);
autoIncrement.initialize(mongoose);

const DevicesSchema = new mongoose.Schema(
    {
        device_name: {
            type: String,
            required: true,
            unique: true,
        },
    },
    {
        versionKey: false,
        timestamps: true,
    }
);

function checkPassword(password) {
    return bcrypt.compare(password, this.password_hash);
}

DevicesSchema.plugin(autoIncrement.plugin, {
    model: "Devices",
    field: "id",
    startAt: 1,
    incrementBy: 1,
});

DevicesSchema.virtual("password").get(function () {
    return checkPassword(password);
});

export default mongoose.model("Devices", DevicesSchema);
