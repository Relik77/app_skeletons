import { ControllerModule } from "../../interfaces/controller.interface";
import { AuthApiController } from "./controllers/auth-api.controller";

export const authModule: ControllerModule = {
    controllers: [AuthApiController],
    models: [],
};
