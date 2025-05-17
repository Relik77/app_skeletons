export interface ServerOptions {
    NODE_PORT: number;

    ENABLE_MULTICORE: "yes" | "no";
    CORE_LIMIT: number;
    REDIS_HOST: string;
    REDIS_PORT: number;
    REDIS_PASSWORD: string;
}
