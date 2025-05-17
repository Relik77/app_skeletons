export enum SOCKET_EVENTS {
    CONNECTION_READY = "system:ready",
    LOG = "system:log",
    ERROR = "system:error",
    UPDATING_SERVER = "system:updating",

    /************************/
    /**** Receive events ****/
    /************************/

    /***********************/
    /***** Emit events *****/
    // User
    SEND_USER_CONNECT = `user:connect`,
    SEND_USER_DISCONNECT = `user:disconnect`,
}

export interface SocketEmitEventInterface {
    [SOCKET_EVENTS.CONNECTION_READY]: () => void;

    [SOCKET_EVENTS.LOG]: (data: string) => void;

    [SOCKET_EVENTS.ERROR]: (data: string) => void;

    [SOCKET_EVENTS.UPDATING_SERVER]: (data: { message: string; date: number }) => void;

    [SOCKET_EVENTS.SEND_USER_CONNECT]: (data: { socket_id?: string; userID: string }) => void;
    [SOCKET_EVENTS.SEND_USER_DISCONNECT]: (userID: string) => void;
}

export interface SocketEventInterface {}
