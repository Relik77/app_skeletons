import { NextFunction, Request, Response } from "express-serve-static-core";
import { User } from "../../../../models/User";
import { AccessToken } from "../../../../models/AccessToken";
import { Controller } from "../../../../http/controller";
import { Shared } from "../../../../shared";

export function getSignOut(this: Controller) {
    return (req: Request, res: Response, next: NextFunction) => {
        const user = req.user as User;
        const accessToken = user.accessToken;

        if (!accessToken) {
            res.json({
                success: true,
            });
            return;
        }
        AccessToken.findOne({
            where: {
                userID: user.smanck_id,
                accessToken: accessToken.access_token,
            },
        })
            .then(async (token) => {
                if (token) {
                    await token.destroy();
                }
                req.logout(() => {});

                req.session.destroy((err) => {
                    if (err) {
                        Shared.logger.error(err);
                    }
                    res.json({
                        success: true,
                    });
                });
            })
            .catch(next);
    };
}
