import { ControllerModule } from "../../interfaces/controller.interface";
import { LogApiController } from "./controllers/log-api.controller";
import { Log } from "./models/Log";

export const logModule: ControllerModule = {
    controllers: [LogApiController],
    socketListeners: [],
    models: [Log],
};
