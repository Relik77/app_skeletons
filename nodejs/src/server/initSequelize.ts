import { Sequelize } from "sequelize-typescript";
import { ModelCtor } from "sequelize-typescript/dist/model/model/model";
import { controllerModule } from "./http/controllers";
import { Session } from "./models/Session";
import { modules } from "./modules/modules";
import { Shared } from "./shared";

export function initSequelize() {
    const sequelize = new Sequelize({
        host: Shared.env.getString("BDD_HOST", "localhost"),
        database: Shared.env.getString("BDD_NAME"),
        username: Shared.env.getString("BDD_USERNAME", "root"),
        password: Shared.env.getString("BDD_PASSWORD", ""),
        port: Shared.env.getNumber("BDD_PORT", 3306),
        dialect: Shared.env.getString("BDD_DIALECT", "mysql"),
        logging: false,
        dialectOptions: {
            multipleStatements: true,
        },
    });

    const models: Array<ModelCtor> = [Session];
    models.push(...controllerModule.models);

    modules.forEach((module) => {
        if (module.models) {
            models.push(...module.models);
        }
    });
    sequelize.addModels(models);

    return sequelize;
}
