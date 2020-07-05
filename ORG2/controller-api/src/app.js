import express from "express";
import http from "http";
import io from "socket.io";
import http from "http";
import routes from "./routes";

class App {
    constructor() {
        this.app = express();
        this.server = http.Server(this.app);
        this.middlewares();
        this.socket();
        this.routes();

        this.connectedUsers = {};
    }

    socket() {
        this.io = io(this.server);

        this.io.on("connection", (socket) => {
            const { user_id } = socket.handshake.query;
            this.connectedUsers[user_id] = socket.id;
        });
    }

    middlewares() {
        this.app.use(express.json());

        this.app.use((req, res, next) => {
            req.io = this.io;

            next();
        });
    }

    routes() {
        this.app.use(routes);
    }
}

export default new App().server;
