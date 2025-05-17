import { Logger as LoggerInstance } from "winston";
import { AppOptions } from "./interfaces/app.interface";
import { environment } from "./environment";
import { EnvironmentInterface } from "./environment/environment.interface";
import { LoggerBuilder } from "./logger";

export class Shared {
    public static env: EnvironmentInterface<AppOptions> = environment;
    private static _logger: LoggerInstance;
    public static get logger() {
        if (this._logger) return this._logger;
        return (this._logger = LoggerBuilder.createLogger());
    }

    public static set logger(logger: LoggerInstance) {
        this._logger = logger;
    }
}
