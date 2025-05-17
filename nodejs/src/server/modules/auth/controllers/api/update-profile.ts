import { NextFunction, Request, Response } from "express-serve-static-core";
import * as fs from "fs-extra";
import { OAuthException } from "../../../../errors";
import { Controller } from "../../../../http/controller";
import { User } from "../../../../models/User";
import _ = require("underscore");

export function updateProfile(this: Controller) {
    return (req: Request, res: Response, next: NextFunction) => {
        const user = req.user;
        const Body = req.body as {
            first_name?: string;
            last_name?: string;
            description?: string;
            language?: string;
            country?: string;
            timezone?: string;
            current_password?: string;
            new_password?: string;
        };

        User.findOne({
            where: {
                uuid: user.uuid,
            },
        })
            .then(async (user) => {
                if (!user) throw new OAuthException("User not found");

                if (Body.first_name) user.first_name = Body.first_name;
                if (Body.last_name) user.last_name = Body.last_name;
                if (Body.description) user.description = Body.description;
                if (Body.language) user.language = Body.language;
                if (Body.country) user.country = Body.country;
                if (Body.timezone) user.timezone = Body.timezone;

                await user.save();

                res.json({});
            })
            .catch(next)
            .finally(() => {
                _.values(req.files).forEach((file) => {
                    fs.unlink(file.path);
                });
            });
    };
}
