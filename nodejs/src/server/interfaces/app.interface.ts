import { ExpressPermissionRules } from "express-permission-rules/lib";
import { Express } from "express-serve-static-core";
import { Server } from "http";
import { Dialect } from "sequelize";
import { Sequelize } from "sequelize-typescript";
import * as SocketIO from "socket.io";
import { Server as SocketIOServer } from "socket.io";
import { SocketEmitEventInterface } from "../../_models/socket-event.interface";
import { User as UserModel } from "../models/User";
import { STORAGE_TYPE } from "../services/storage.service";

declare module "http" {
    interface IncomingHttpHeaders extends NodeJS.Dict<string | string[]> {
        language?: string;
        timezone?: string;
    }
}

declare module "express-session" {
    export interface SessionData {
        userToken: string;
    }
}

declare global {
    namespace Express {
        interface User extends UserModel {}
        interface Request {
            files?: {
                [fieldname: string]: {
                    fieldName: string;
                    originalFilename: string;
                    path: string;
                    size: number;
                    name: string;
                    type: string;
                };
            };
        }
    }
}

export interface AppOptions {
    CURRENT_ENV: "dev" | "prod" | "preprod";
    NODE_PORT: number;

    API_SERVER_URL: string;

    CONNECT_URL: string;
    OAUTH_CLIENT_ID: string;
    OAUTH_CLIENT_SECRET: string;
    OAUTH_TOKEN_URL: string;
    OAUTH_PROFILE_URL: string;
    OAUTH_REVOKE_URL: string;

    BDD_HOST: string;
    BDD_PORT: number;
    BDD_NAME: string;
    BDD_USERNAME: string;
    BDD_PASSWORD: string;
    BDD_DIALECT: Dialect;

    REDIS_HOST: string;
    REDIS_PORT: number;
    REDIS_PASSWORD: string;

    SESSION_NAME: string;
    SESSION_SECRET: string;
    SESSION_TIMEOUT: number;
    OAUTH_TOKEN_EXPIRES_IN: number;

    COOKIE_SECURE: boolean;
    COOKIE_SAME_SITE: "none" | "lax" | "strict";

    CONNECT_API_KEY: string;

    STORAGES: string;
    DEFAULT_STORAGE: STORAGE_TYPE;
    OVH_CONFIG: any;

    MAX_BODY_SIZE: string;

    PUSHER_INSTANCE_ID: string;
    PUSHER_KEY: string;
}

export interface ServerInterface {
    server: Server;
    io: SocketIO.Server;
}

export interface AppInterface {
    express: Express;
    io: SocketIOServer<SocketEmitEventInterface>;
    sequelize: Sequelize;
    accessPermissions: ExpressPermissionRules;
    updatePlanned?: {
        message: string;
        date: number;
    };

    getUsersInRoom(roomName: string): UserModel[];
}
