import * as bodyParser from "body-parser";
import * as createSequelizeStore from "connect-session-sequelize";
import * as cookieParser from "cookie-parser";
import * as cors from "cors";
import * as express from "express";
import * as formData from "express-form-data";
import * as expressLimiter from "express-limiter";
import { ExpressPermissionRules } from "express-permission-rules";
import { expressPermissionRules } from "express-permission-rules/lib";
import { Express, NextFunction, Request, Response } from "express-serve-static-core";
import * as session from "express-session";
import helmet from "helmet";
import * as http from "http";
import { Server as HTTPServer } from "http";
import * as os from "os";
import * as passport from "passport";
import * as passportSocketIo from "passport.socketio";
import * as redis from "redis";
import { Sequelize } from "sequelize-typescript";
import { Socket, Server as SocketIOServer } from "socket.io";
import * as _ from "underscore";
import * as S from "string";
import { SOCKET_EVENTS, SocketEmitEventInterface, SocketEventInterface } from "./socket-event.interface";
import { controllerModule } from "./http/controllers";
import { initSequelize } from "./initSequelize";
import { AppInterface, ServerInterface } from "./interfaces/app.interface";
import { LoggerBuilder } from "./logger";
import { Migration } from "./migration/migration";
import { User } from "./models/User";
import { modules } from "./modules/modules";
import { BearerStrategy } from "./passport/bearer.strategy";
import { Shared } from "./shared";
import { waitTimeout } from "./utils";

class PermissionRules extends ExpressPermissionRules {
    constructor(options: expressPermissionRules.PermissionRulesOptions) {
        super(options);
    }

    protected authenticate(req: Request, res: Response, next: NextFunction): void {
        passport.authenticate("bearer", {
            session: true,
            failWithError: true,
        })(req, res, (err) => {
            if (err) return next(new Error("Error"));
            next();
        });
    }
}

export class AppComponent implements AppInterface, ServerInterface {
    public express: Express;
    public server: HTTPServer;
    public io: SocketIOServer;
    public sequelize: Sequelize;
    public accessPermissions: ExpressPermissionRules;
    private ready: boolean = false;

    constructor() {
        Shared.logger = LoggerBuilder.createLogger();
        Shared.env.on("log", (msg) => {
            Shared.logger.verbose(msg);
        });

        this.express = express();
        // this.express.all("/", (req, res, next) => {
        //     if (this.ready) return next();
        //     res.sendFile(path.resolve("maintenance.html"));
        // });
        this.server = http.createServer(this.express);
        this.io = new SocketIOServer(this.server, {
            cors: {
                // origin: "https://app-preprod.smanck.com",
                origin: "*",
                methods: ["GET", "POST"],
                credentials: true,
            },
            cookie: {
                name: Shared.env.getString("SESSION_NAME", "sessionId"),
                httpOnly: true,
                sameSite: Shared.env.getString("COOKIE_SAME_SITE", "none"),
                secure: Shared.env.getBoolean("COOKIE_SECURE", true),
            },
        });
        this.io.on("connection", (socket: Socket<SocketEventInterface>) => {
            socket.disconnect(true);
        });

        this.init().catch((err) => {
            Shared.logger.error(err);
        });
    }

    private async initSequelize(): Promise<void> {
        return new Promise(async (resolve, reject) => {
            this.sequelize = initSequelize();
            let ok = false;
            let nbErrors = 0;
            while (true) {
                try {
                    await this.sequelize.authenticate();
                    ok = true;
                    break;
                } catch (err) {
                    if (nbErrors % 10 === 0) {
                        Shared.logger.error(err);
                    }
                    nbErrors++;
                    await waitTimeout(1000 * 5);
                }
            }
            if (!ok) return reject("Unable to connect to database");
            Shared.logger.verbose("Database connected");
            resolve();
        });
    }

    private async init() {
        await this.initSequelize();
        await Shared.env.sync();

        if (Shared.env.getString("CURRENT_ENV") !== "dev") {
            LoggerBuilder.removeTransport("console");
            LoggerBuilder.addFileTransport();
        }

        Shared.logger.verbose("Starting server...");

        await new Migration(this.sequelize).run();

        this.accessPermissions = new PermissionRules({
            userProperty: "user",
            defaultRuleAccess: "deny",
            rolenameProperty: "role",
        });

        this.initExpressApp();
        this.initControllers();
        this.initSockets();

        this.ready = true;
    }

    private initExpressApp() {
        const app = this.express;

        // const csrfProtection = csurf({
        //     cookie: true,
        //     ignoreMethods: ["GET", "HEAD", "OPTIONS"],
        // });

        if (Shared.env.isSet("REDIS_HOST")) {
            const host = Shared.env.getString("REDIS_HOST");
            const port = Shared.env.getNumber("REDIS_PORT");
            const client = redis.createClient({
                url: `redis://${host}:${port}`,
                password: Shared.env.getString("REDIS_PASSWORD"),
            });
            const limiter = expressLimiter(app, client);
            limiter({
                path: "/auth/sign-in",
                method: "post",
                lookup: ["connection.remoteAddress"],
                // requests per hour
                total: 60,
                expire: 1000 * 60 * 60,
            });
        }

        app.use(
            helmet({
                contentSecurityPolicy: {
                    useDefaults: true,
                    directives: {
                        "script-src": [
                            "'self'",
                            "'unsafe-inline'",
                            "code.jquery.com",
                            "kit.fontawesome.com",
                            "js.userflow.com",
                            "client.crisp.chat",
                            "dns.google",
                        ],
                        // "media-src": ["'self'", "data:", "blob:"],
                        "connect-src": [
                            "'self'",
                            "*.fontawesome.com",
                            "wss://*.userflow.com",
                            "client.crisp.chat",
                            "wss://*.crisp.chat",
                            "dns.google",
                        ],
                        // "img-src": ["*", "data:"],
                        "frame-src": [
                            // "*",
                            "visio-app.smanck.com",
                        ],
                    },
                },
                crossOriginResourcePolicy: {
                    policy: "cross-origin",
                },
            })
        );
        app.use(
            cors({
                origin: ["https://app.smanck.com", "https://app-preprod.smanck.com"],
                credentials: true,
                methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
                allowedHeaders: [
                    "Content-Type",
                    "Authorization",
                    "SessionID",
                    "XSRF-TOKEN",
                    "language",
                    "timezone-offset",
                ],
                exposedHeaders: ["Authorization", "SessionID"],
                maxAge: 1728000,
            })
        );

        app.use(express.static("public"));

        app.use(
            bodyParser.urlencoded({
                limit: Shared.env.getString("MAX_BODY_SIZE", "10mb"),
                extended: true,
            })
        );
        app.use(
            bodyParser.json({
                limit: Shared.env.getString("MAX_BODY_SIZE", "10mb"),
            })
        );
        app.use(cookieParser());

        // parse a data with connect-multiparty.
        app.use(
            formData.parse({
                // autoFiles: true
                uploadDir: os.tmpdir(),
                autoClean: false,
            })
        );
        // clear all empty files (size == 0)
        app.use(formData.format());
        // change file objects to node stream.Readable
        // app.use(formData.stream());
        // union body and files
        app.use(formData.union());

        // app.use(csrfProtection, (req, res, next): void => {
        //     res.cookie("XSRF-TOKEN", req.csrfToken(), { httpOnly: false });
        //     next();
        // });

        // app.use(express.static("dist/www"));
        // app.use(express.static("public"));

        const SequelizeStore = createSequelizeStore(session.Store);
        const sessionStore = new SequelizeStore({
            db: this.sequelize,
            table: "Session",
            extendDefaultFields: (defaults, session) => {
                return {
                    data: defaults.data,
                    expires: defaults.expires,
                    userID: _.property(["passport", "user", "smanck_id"])(session),
                };
            },
            checkExpirationInterval: 15 * 60 * 1000, // The interval at which to cleanup expired sessions.
            expiration: Shared.env.getNumber("SESSION_TIMEOUT"), // The maximum age (in milliseconds) of a valid session. Used when cookie.expires is not set.
        });
        sessionStore.sync();

        app.use(
            session({
                name: Shared.env.getString("SESSION_NAME", "sessionId"),
                secret: Shared.env.getString("SESSION_SECRET"),
                store: sessionStore,
                resave: true,
                rolling: true,
                saveUninitialized: true,
                cookie: {
                    httpOnly: true,
                    maxAge: Shared.env.getNumber("SESSION_TIMEOUT"),
                    sameSite: Shared.env.getString("COOKIE_SAME_SITE", "none"),
                    secure: Shared.env.getBoolean("COOKIE_SECURE", true),
                },
            })
        );
        this.io.use(
            passportSocketIo.authorize({
                cookieParser: cookieParser as any, //optional your cookie-parser middleware function. Defaults to require('cookie-parser')
                key: Shared.env.getString("SESSION_NAME", "sessionId"), //make sure is the same as in your session settings in app.js
                secret: Shared.env.getString("SESSION_SECRET"), //make sure is the same as in your session settings in app.js
                store: sessionStore as any, //you need to use the same sessionStore you defined in the app.use(session({... in app.js
                //success:      onAuthorizeSuccess,  // *optional* callback on success
                fail: (data, message, critical, accept) => {
                    const user = data.user;
                    user.key = (data.query && data.query.key) || (data._query && data._query.key);
                    // if (data.socketio_version_1) {
                    //     accept(new Error(message));
                    // } else {
                    //     accept(null, false);
                    // }
                    accept();
                }, // *optional* callback on fail/error
            }) as any
        );

        this.express.use(
            passport.initialize({
                userProperty: "user",
            })
        );
        this.express.use(passport.session());
        passport.serializeUser<{ smanck_id: string; accessToken: string }>((user, done) => {
            let accessToken = user.accessToken;
            let obj = {
                smanck_id: user.smanck_id,
                accessToken: accessToken ? accessToken.access_token : null,
            };
            done(null, obj);
        });
        passport.deserializeUser<{ smanck_id: string; accessToken: string }>((data, done) => {
            if (!data.smanck_id) {
                return done(null, null);
            }

            User.findOne({
                where: {
                    smanck_id: data.smanck_id,
                },
            })
                .then((user) => {
                    if (!user) {
                        return done(null, null);
                    }
                    user.accessToken = {
                        access_token: data.accessToken,
                    };
                    done(null, user);
                })
                .catch(done);
        });

        passport.use("bearer", BearerStrategy);
        app.use((req: Request, res: Response, next: NextFunction) => {
            Shared.logger.verbose("(" + req.method + ") " + req.originalUrl);

            // for local development ?
            res.setHeader(
                "Access-Control-Allow-Origin",
                S(req.headers.origin || req.headers.referer || "*").chompRight("/").s
            );
            res.setHeader("SessionID", req.sessionID);

            if (req.user) {
                // req.user.accessToken = req.session.userToken;
            }
            req.session.cookie.expires = new Date(Date.now() + Shared.env.getNumber("SESSION_TIMEOUT"));
            req.session.save((err) => {
                if (err) {
                    Shared.logger.error(err);
                }
            });

            next();
        });
    }

    private initControllers() {
        controllerModule.controllers.forEach((Controller) => new Controller(this));

        modules.forEach((module) => {
            module.controllers.forEach((Controller) => new Controller(this));
        });
        this.express.use((err: any, req: Request, res: Response, next: NextFunction) => {
            Shared.logger.error(err.toString(), req.originalUrl);

            if (req.headers.accept == "application/json") {
                return res.status(err.status || 400).json({
                    message: err.message,
                });
            }
            if (
                req.originalUrl.match(/^\/assets\//) ||
                req.originalUrl.match(/\.(css)|(js)|(map)|(json)|(html)|(png)|(svg)|(jpe?g)($|\?)/)
            ) {
                return res.status(404).end();
            }
            return res.status(err.status || 400).redirect("/");
        });
    }

    public getUsersInRoom(roomName: string): User[] {
        const users: { [id: string]: User } = {};
        const socketIds = this.io.sockets.adapter.rooms.get(roomName);

        if (socketIds) {
            for (const socketId of socketIds) {
                const clientSocket = this.io.sockets.sockets.get(socketId);
                if (!clientSocket) continue;
                const user: User = clientSocket.request["user"];
                if (user) {
                    users[user.smanck_id] = user;
                }
            }
        }
        return _.values(users);
    }

    private initSockets() {
        this.io.removeAllListeners("connection");
        this.io.on("connection", (socket: Socket<SocketEmitEventInterface>) => {
            // console.log("socket connection");

            const user: User & { logged_in: boolean } = socket.request["user"];

            if (user && user.logged_in) {
                Shared.logger.verbose("Socket connection established. User: " + user.fullName);
                socket.emit(SOCKET_EVENTS.LOG, "Connection established");
                socket.join(`user:${user.smanck_id}`);

                if (controllerModule.socketListeners) {
                    controllerModule.socketListeners.forEach(
                        (SocketListener) => new SocketListener(this, socket, user)
                    );
                }
                modules.forEach((module) => {
                    if (module.socketListeners) {
                        module.socketListeners.forEach((SocketListener) => new SocketListener(this, socket, user));
                    }
                });
                socket.emit(SOCKET_EVENTS.CONNECTION_READY);

                socket.broadcast.emit(SOCKET_EVENTS.SEND_USER_CONNECT, {
                    userID: user.smanck_id,
                    socket_id: socket.id,
                });
                socket.on("disconnect", () => {
                    const socketIds = this.io.sockets.adapter.rooms.get(`user:${user.smanck_id}`);
                    if (socketIds && socketIds.size > 0) return;

                    socket.broadcast.emit(SOCKET_EVENTS.SEND_USER_DISCONNECT, user.smanck_id);
                });
            } else {
                socket.emit(SOCKET_EVENTS.ERROR, "Not authorized");
                socket.disconnect(true);
            }
        });
    }
}
