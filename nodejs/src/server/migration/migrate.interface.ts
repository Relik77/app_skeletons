import { Sequelize } from "sequelize-typescript";

export interface MigrateInterface {
    version: string;
    
    run(): Promise<void>;
}

export interface MigrateConstructor {
    new(
        sequelize: Sequelize
    ): MigrateInterface;
}
