import * as winston from "winston";
import { Logger as LoggerInstance } from "winston";
import * as DailyRotateFile from "winston-daily-rotate-file";
import * as Transport from "winston-transport";

export class LoggerBuilder {
    private static logger: LoggerInstance;
    private static transports: {
        error?: Transport;
        file?: Transport;
        console?: Transport;
    } = {};
    private static isProd: boolean = true;

    public static createLogger() {
        if (this.logger) return this.logger;

        this.logger = winston.createLogger({
            level: "debug",
            format: winston.format.combine(winston.format.timestamp(), winston.format.errors({ stack: true })),
            transports: [],
        });
        this.addErrorTransport();
        this.addConsoleTransport();
        return this.logger;
    }

    private static setEnv(env: "dev" | string) {
        const isProd: boolean = env !== "dev";
        if (isProd == this.isProd) return;
        this.isProd = isProd;

        this.addErrorTransport();
    }

    private static addErrorTransport() {
        this.createLogger();
        if (this.transports.error) {
            this.logger.remove(this.transports.error);
        }
        this.transports.error = new DailyRotateFile({
            level: "error",
            format: winston.format.combine(winston.format.prettyPrint()),
            datePattern: "YYYY-MM-DD",
            filename: "%DATE%_error.log",
            dirname: "logs",
            maxFiles: this.isProd ? "30d" : "1d",
            utc: true,
            createSymlink: true,
            symlinkName: "logs/error.log",
        });
        this.logger.add(this.transports.error);
    }

    public static addFileTransport() {
        this.createLogger();
        this.removeTransport("file");
        this.transports.file = new DailyRotateFile({
            format: winston.format.printf(({ level, message, timestamp }) => {
                return `${timestamp} ${level}: ${message}`;
            }),
            datePattern: "YYYY-MM-DD",
            filename: "%DATE%_server.log",
            dirname: "logs",
            maxFiles: "7d",
            utc: true,
            createSymlink: true,
            symlinkName: "logs/server.log",
        });
        this.logger.add(this.transports.file);
    }

    public static removeTransport(transport: "file" | "console") {
        this.createLogger();
        switch (transport) {
            case "file":
                if (this.transports.file) {
                    this.logger.remove(this.transports.file);
                }
                break;
            case "console":
                if (this.transports.console) {
                    this.logger.remove(this.transports.console);
                }
                break;
        }
    }

    public static addConsoleTransport() {
        this.createLogger();
        this.removeTransport("console");
        this.transports.console = new winston.transports.Console({
            format: winston.format.combine(
                winston.format.colorize(),
                winston.format.printf((info) => {
                    let level: string = info.level;
                    let message: string = info.message as string;
                    let stack: string = (info.stack as string) || "";
                    if (stack != "") {
                        stack = stack.substring(stack.indexOf("\n"));
                        let lines: Array<string> = stack.split("\n");
                        stack = lines.splice(0, 3).join("\n");
                    }
                    return `${level}: ${message}${stack}`;
                })
            ),
        });
        this.logger.add(this.transports.console);
    }
}
