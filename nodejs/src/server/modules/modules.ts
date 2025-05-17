import { ControllerModule } from "../interfaces/controller.interface";
import { authModule } from "./auth/auth.module";
import { logModule } from "./log/log.module";

export const modules: Array<ControllerModule> = [logModule, authModule];
