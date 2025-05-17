export interface EnvironmentKeys {
    [name: string]: any;
}

export interface ServerConfig {
    port: string;
    database: {
        host: string;
        db: string;
        user: string;
        password: string;
        port: string;
    };
}

export interface EnvironmentConfigKey {
    type: string;
    description?: string;
    defaultValue?: string;
}

export interface EnvironmentConfigKeys {
    [name: string]: EnvironmentConfigKey;
}

export interface EnvironmentInterface<T> {
    on(eventName: "log", listener: (...args: any[]) => void): void;

    sync(): Promise<void>;

    getString<K extends keyof T>(key: K, defaultValue?: string): T[K];

    getBoolean<K extends keyof T>(key: K, defaultValue?: boolean): T[K];

    getNumber<K extends keyof T>(key: K, defaultValue?: number): T[K];

    getJSON<K extends keyof T>(key: K, defaultValue?: Object): T[K];

    equal(key: keyof T, value: string): boolean;

    isSet(key: keyof T): boolean;
}
