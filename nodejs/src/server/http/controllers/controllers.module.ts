import { models } from "../../models";
import { ControllerModule } from "../../interfaces/controller.interface";
import { ApiController } from "./api.controller";
import { PageController } from "./page.controller";

export const controllerModule: ControllerModule = {
    controllers: [ApiController, PageController],
    models: models,
};
