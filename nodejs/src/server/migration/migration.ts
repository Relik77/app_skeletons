import * as fs from "fs-extra";
import * as lodash from "lodash";
import * as moment from "moment";
import { QueryTypes } from "sequelize";
import { Sequelize } from "sequelize-typescript";
import { Shared } from "../shared";
import { MigrationInterface } from "./changelog.interface";
import { ChangelogService } from "./changelog.service";
import { MigrateInterface } from "./migrate.interface";
import { MigrateScripts } from "./scripts";

export class Migration {
    private cache: MigrationInterface;
    private migrators: MigrateInterface[] = [];

    constructor(private sequelize: Sequelize) {
        this.cache = ChangelogService.getValue("migration", {
            installed: [],
        });
        for (let Migrator of MigrateScripts) {
            const migrator = new Migrator(this.sequelize);

            if (
                lodash.find(
                    this.cache.installed,
                    (installationInfo) =>
                        installationInfo.version == migrator.version
                )
            ) {
                continue;
            }
            this.migrators.push(migrator);
        }
    }

    public async run() {
        const database = this.sequelize.getDatabaseName();

        const tables = await this.sequelize.query(`SHOW TABLES`, {
            type: QueryTypes.SHOWTABLES,
        });
        if (tables.length <= 1) {
            Shared.logger.verbose("init bdd first time");
            await this.sequelize.query(
                fs.readFileSync("data/init.sql", {
                    encoding: "utf8",
                })
            );
        }

        for (let migrator of this.migrators) {
            Shared.logger.verbose(`migrate to ${migrator.version}...`);
            await migrator.run();
            this.cache.installed.push({
                version: migrator.version,
                date: moment.utc().format(),
            });
            ChangelogService.setValue("migration", this.cache);
            Shared.logger.verbose(`${migrator.version} installed.`);
            await this.sequelize.query(`USE \`${database}\`;`);
        }
        if (this.migrators.length > 0) {
            Shared.logger.verbose(`Migration successful.`);
        }

        // await this.updateData();
    }

    private async updateData() {
        // await this.sequelize.query("SET FOREIGN_KEY_CHECKS = 0;");
        // Shared.logger.verbose(`Updating email templates...`);
        // await this.sequelize.query(
        //     fs.readFileSync("data/email_template.sql", {
        //         encoding: "utf8",
        //     })
        // );
        // for (let emailType of fs.readdirSync("data/emails")) {
        //     for (let language of fs.readdirSync(`data/emails/${emailType}`)) {
        //         const email: EmailTemplate = await EmailTemplate.findOne({
        //             where: {
        //                 type: emailType,
        //                 language: path.basename(language, ".html"),
        //             },
        //         });
        //         if (email) {
        //             email.template = fs.readFileSync(
        //                 `data/emails/${emailType}/${language}`,
        //                 {
        //                     encoding: "utf8",
        //                 }
        //             );
        //             await email.save();
        //         }
        //     }
        // }
        // await this.sequelize.query("SET FOREIGN_KEY_CHECKS = 1;");

        Shared.logger.verbose(`Data updated.`);
    }
}
