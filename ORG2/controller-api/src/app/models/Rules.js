import mongoose from "mongoose";
import autoIncrement from "mongoose-auto-increment";

import conn from "../../config/dbConnection";

mongoose.connect(conn.url);
autoIncrement.initialize(mongoose);

const RulesSchema = new mongoose.Schema(
    {
        name: {
            type: String,
            required: true,
            //unique: true
        },
        promise: {
            type: Number,
            required: true,
        },
        action: {
            type: String,
            required: true,
        },
        test_case: {
            type: String,
            required: true,
        },
        repeatable: {
            type: Boolean,
            required: true,
        },
        blockchain_shared: {
            type: Boolean,
            required: true,
        },
    },
    {
        versionKey: false,
        timestamps: true,
    }
);

RulesSchema.plugin(autoIncrement.plugin, {
    model: "Rules",
    field: "id",
    startAt: 1,
    incrementBy: 1,
});

export default mongoose.model("Rules", RulesSchema);
