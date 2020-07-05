import { Router } from "express";
import cors from "cors";

import SessionController from "./app/controllers/SessionController";
import DevicesController from "./app/controllers/DevicesController";
import RulesController from "./app/controllers/RulesController";

const routes = new Router();

routes.use(cors());

routes.post("/devices", DevicesController.store);
routes.get("/devices", DevicesController.index);
routes.put("/devices/:id", DevicesController.update);

routes.get("/", (req, res) => {
    return res.send("Bem-vindo");
});

routes.get("/rules", RulesController.index);
routes.post("/rules", RulesController.store);
routes.put("/rules/:id", RulesController.update);
routes.delete("/rules/:id", RulesController.delete);

export default routes;
