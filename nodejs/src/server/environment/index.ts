import * as dotenv from "dotenv";
import { EventEmitter } from "events";
import * as fs from "fs-extra";
import * as generator from "generate-password";
import * as lodash from "lodash";
import * as Mustache from "mustache";
import { RemoteConfig } from "../models/RemoteConfig";
import {
    EnvironmentConfigKey,
    EnvironmentConfigKeys,
    EnvironmentInterface,
    EnvironmentKeys,
} from "./environment.interface";

class ConfigParam {
    constructor(private _name: string, private config: EnvironmentConfigKey) {}

    get name() {
        return this._name;
    }

    getType(defaultValue?: string) {
        return this.config && this.config.type ? this.config.type : defaultValue;
    }

    getDescription(defaultValue?: string) {
        return this.config && this.config.description ? this.config.description : defaultValue;
    }

    getDefaultValue(defaultValue?: string) {
        if (defaultValue) return defaultValue;
        return this.config && this.config.defaultValue ? this.config.defaultValue : null;
    }
}

class ConfigParser {
    private config: EnvironmentConfigKeys;

    constructor() {
        if (fs.pathExistsSync("data/environment.json")) {
            this.config = fs.readJSONSync("data/environment.json");
        }
    }

    hasKey(key: string) {
        return this.config.hasOwnProperty(key);
    }

    getKeys() {
        return lodash.keys(this.config);
    }

    getParam(name: string) {
        return new ConfigParam(name, this.config[name]);
    }
}

export class Environment implements EnvironmentInterface<EnvironmentKeys> {
    private readonly env: EnvironmentKeys;
    private readonly appConfig: Map<string, any> = new Map<string, any>();
    private readonly eventEmitter = new EventEmitter();

    constructor() {
        if (fs.pathExistsSync(".env")) {
            this.env = dotenv.parse(fs.readFileSync(".env"));
        } else {
            const env = Mustache.render(
                fs.readFileSync(".env.example", {
                    encoding: "utf-8",
                }),
                {
                    SESSION_SECRET: generator.generate({
                        length: 12,
                        numbers: true,
                        symbols: true,
                        lowercase: true,
                        uppercase: true,
                    }),
                }
            );
            fs.outputFileSync(".env", env, {
                encoding: "utf-8",
            });
            this.env = dotenv.parse(env);
        }
    }

    public on(eventName: "log", listener: (...args: any[]) => void) {
        this.eventEmitter.on(eventName, listener);
    }

    async sync() {
        await RemoteConfig.sync();
        const config = new ConfigParser();

        let environmentConfig: RemoteConfig = await RemoteConfig.findOne({
            where: {
                name: "CURRENT_ENV",
                enable: true,
            },
        });
        if (!environmentConfig) {
            const defaultEnvConfig = config.getParam("CURRENT_ENV");
            const defaultValue: string = this.env["CURRENT_ENV"] || this.env["NODE_ENV"] || "prod";
            environmentConfig = new RemoteConfig();
            environmentConfig.name = defaultEnvConfig.name;
            environmentConfig.value = defaultEnvConfig.getDefaultValue(defaultValue);
            environmentConfig.type = defaultEnvConfig.getType("string");
            environmentConfig.description = defaultEnvConfig.getDescription(null);
            await environmentConfig.save();
        }
        this.env[environmentConfig.name] = environmentConfig.value;

        let remoteConfigs: Record<string, RemoteConfig> = lodash.keyBy(
            await RemoteConfig.findAll({
                where: {
                    environment: environmentConfig.value,
                    enable: true,
                },
            }),
            "name"
        );
        for (let remoteConfig of lodash.values(remoteConfigs)) {
            if (!config.hasKey(remoteConfig.name)) {
                await remoteConfig.destroy();
            }
        }

        const paramKeys = lodash.without(config.getKeys(), "CURRENT_ENV");
        for (let paramKey of paramKeys) {
            const param = config.getParam(paramKey);
            let remoteConfig: RemoteConfig = remoteConfigs[paramKey];
            if (!remoteConfig) {
                const defaultValue: string = this.env[param.name] || null;
                remoteConfig = new RemoteConfig();
                remoteConfig.name = param.name;
                remoteConfig.value = param.getDefaultValue(defaultValue);
                remoteConfig.type = param.getType("string");
                remoteConfig.description = param.getDescription(null);
                remoteConfig.environment = environmentConfig.value;
            } else {
                if (!remoteConfig.description) remoteConfig.description = param.getDescription(null);
            }
            await remoteConfig.save();
            this.env[remoteConfig.name] = remoteConfig.value;
        }
    }

    getString<K extends keyof EnvironmentKeys>(key: K, defaultValue?: string): any {
        if (!this.isSet(key)) return defaultValue;
        return this.env[key];
    }

    getBoolean<K extends keyof EnvironmentKeys>(key: K, defaultValue?: boolean): any {
        if (!this.isSet(key)) return defaultValue;
        switch (this.env[key]) {
            case "true":
            case "yes":
                return true;
            default:
                return false;
        }
    }

    getNumber<K extends keyof EnvironmentKeys>(key: K, defaultValue?: number): any {
        if (!this.isSet(key)) return defaultValue;
        let value = parseInt(this.env[key]);
        if (Number.isNaN(value)) return defaultValue;
        return value;
    }

    getJSON<K extends keyof EnvironmentKeys>(key: K, defaultValue?: Object): any {
        if (!this.isSet(key)) return defaultValue;
        try {
            return JSON.parse(this.env[key]);
        } catch (e) {
            return defaultValue;
        }
    }

    equal(key: string, value: string): boolean {
        return this.env[key] === value;
    }

    isSet<K extends keyof EnvironmentKeys>(key: K): boolean {
        const value = this.env[key];
        return value !== null && value !== undefined && value !== "";
    }
}

export const environment = new Environment();
