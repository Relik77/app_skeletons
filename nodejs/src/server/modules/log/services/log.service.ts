import * as md5 from "md5";
import { Log } from "../models/Log";
import { Op } from "sequelize";

export class LogService {
    static async createLog(options: { data: string; type: string; source: string }): Promise<void> {
        const md5sum = md5(options.data);

        return Log.findOne({
            where: {
                log_md5: md5sum,
                log_type: options.type,
                log_source: options.source,
                log_status: {
                    [Op.in]: ["new", "ignored", "not a bug"],
                },
            },
        }).then((log) => {
            if (log) {
                log.log_produced++;
                log.last_seen = new Date();
                if (log.log_status === "ignored") {
                    log.log_status = "new";
                }
                log.save();
            } else {
                log = new Log();
                log.log_data = options.data;
                log.log_md5 = md5sum;
                log.log_type = options.type;
                log.log_source = options.source;
                log.log_status = "new";
                log.log_produced = 1;
                log.first_seen = new Date();
                log.last_seen = new Date();
                log.save();
            }
        });
    }
}
