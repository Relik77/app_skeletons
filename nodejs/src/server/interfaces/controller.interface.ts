import { RequestHandler } from "express-serve-static-core";
import { ModelCtor } from "sequelize-typescript/dist/model/model/model";
import { Socket } from "socket.io";
import { SocketEmitEventInterface, SocketEventInterface } from "../../_models/socket-event.interface";

import { AppInterface } from "./app.interface";
import { User } from "../models/User";
import { Controller } from "../http/controller";
import { SocketListener } from "../http/socket.listener";

export declare type EventNames = keyof SocketEventInterface;

export interface ControllerConstructor {
    new (app: AppInterface): Controller;
}

export interface ControllerFunction extends Function {
    (this: Controller): RequestHandler;
}

export interface SocketListenerConstructor {
    new (app: AppInterface, socket: Socket<SocketEmitEventInterface>, user: User): SocketListener;
}

export interface SocketListenerFunction<Ev extends EventNames> extends Function {
    (this: SocketListener): SocketEventInterface[Ev];
}

export interface ControllerModule {
    controllers: Array<ControllerConstructor>;
    socketListeners?: Array<SocketListenerConstructor>;
    models?: Array<ModelCtor>;
}
