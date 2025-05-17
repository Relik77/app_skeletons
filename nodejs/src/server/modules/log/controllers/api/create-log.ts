import { NextFunction, Request, Response } from "express-serve-static-core";
import { Controller } from "../../../../http/controller";
import { LogService } from "../../services/log.service";
import { Shared } from "../../../../shared";

export function createLog(this: Controller) {
    return (req: Request, res: Response, next: NextFunction) => {
        const Body: {
            message: string;
            type: string;
            source: string;
        } = req.body;

        if (!Body.message || !Body.type || !Body.source) {
            return res.status(400).end();
        }

        res.status(201).json({
            success: true,
        });

        LogService.createLog({
            data: Body.message,
            type: Body.type,
            source: Body.source,
        }).catch((err) => Shared.logger.error(err));
    };
}
