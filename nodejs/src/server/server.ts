import cluster from "cluster";
import { Socket } from "net";
import * as net from "net";
import * as redis from "redis";
import { createAdapter } from "socket.io-redis";

import { AppComponent } from "./app.component";
import { environment } from "./environment";
import { EnvironmentInterface } from "./environment/environment.interface";
import { ServerOptions } from "./interfaces/server.interface";

export class Server {
    private env: EnvironmentInterface<ServerOptions>;
    private nb_processes: number;

    constructor() {
        this.env = environment;
        this.nb_processes = require("os").cpus().length;

        if (this.env.isSet("CORE_LIMIT")) {
            const core_limit = this.env.getNumber("CORE_LIMIT");
            if (core_limit > 0 && core_limit < this.nb_processes) {
                this.nb_processes = core_limit;
            }
        }

        if (!this.env.getBoolean("ENABLE_MULTICORE")) {
            this.runAsSingle();
        } else if (cluster.isPrimary) {
            this.runAsMaster();
        } else {
            this.runAsWorker();
        }
    }

    private runAsMaster() {
        // This stores our workers. We need to keep them to be able to reference
        // them based on source IP address. It's also useful for auto-restart,
        // for example.
        const workers = [];

        // Helper function for spawning worker at index 'i'.
        const spawn = (i) => {
            workers[i] = cluster.fork();

            // Optional: Restart worker on exit
            workers[i].on("exit", (code, signal) => {
                console.log("respawning worker", i);
                spawn(i);
            });
        };

        // Spawn workers.
        for (let i = 0; i < this.nb_processes; i++) {
            spawn(i);
        }

        // Helper function for getting a worker index based on IP address.
        // This is a hot path so it should be really fast. The way it works
        // is by converting the IP address to a number by removing non numeric
        // characters, then compressing it to the number of slots we have.
        //
        // Compared against "real" hashing (from the sticky-session code) and
        // "real" IP number conversion, this function is on par in terms of
        // worker index distribution only much faster.
        const worker_index = (ip, len) => {
            let s = "";
            for (let i = 0, _len = ip.length; i < _len; i++) {
                if (!isNaN(ip[i])) {
                    s += ip[i];
                }
            }

            return Number(s) % len;
        };

        // Create the outside facing server listening on our port.
        net.createServer({ pauseOnConnect: true }, (connection) => {
            // We received a connection and need to pass it to the appropriate
            // worker. Get the worker for this connection's source IP and pass
            // it the connection.
            const worker =
                workers[
                    worker_index(connection.remoteAddress, this.nb_processes)
                ];
            worker.send("sticky-session:connection", connection);
        }).listen(this.env.getNumber("NODE_PORT"));
    }

    private runAsSingle() {
        const app = new AppComponent();
        app.server.listen(this.env.getNumber("NODE_PORT"));

        console.log("Magic happens on port " + this.env.getNumber("NODE_PORT"));
    }

    private runAsWorker() {
        // Note we don't use a port here because the master listens on it for us.
        // Don't expose our internal server to the outside.
        const app = new AppComponent();
        app.server.listen(0, "localhost");

        console.log(
            "Worker %d running on port %d!",
            cluster.worker.id,
            this.env.getNumber("NODE_PORT")
        );

        if (app.io) {
            // Tell Socket.IO to use the redis adapter. By default, the redis
            // server is assumed to be on localhost:6379. You don't have to
            // specify them explicitly unless you want to change them.

            const host = this.env.getString("REDIS_HOST");
            const port = this.env.getNumber("REDIS_PORT");
            const pubClient = redis.createClient({
                url: `redis://${host}:${port}`,
                password: this.env.getString("REDIS_PASSWORD"),
            });
            const subClient = pubClient.duplicate();
            app.io.adapter(
                createAdapter({
                    pubClient: pubClient,
                    subClient: subClient,
                })
            );
        }

        // Listen to messages sent from the master. Ignore everything else.
        process.on("message", (message, connection: Socket) => {
            if (message !== "sticky-session:connection") {
                return;
            }

            // Emulate a connection event on the server by emitting the
            // event with the connection the master sent us.
            app.server.emit("connection", connection);

            connection.resume();
        });
    }
}
