import { Socket } from "socket.io";
import { SocketEmitEventInterface } from "../socket-event.interface";
import { AppInterface } from "../interfaces/app.interface";
import { User } from "../models/User";

export abstract class SocketListener {
    protected constructor(
        protected app: AppInterface,
        protected socket: Socket<SocketEmitEventInterface>,
        protected user: User
    ) {}
}
