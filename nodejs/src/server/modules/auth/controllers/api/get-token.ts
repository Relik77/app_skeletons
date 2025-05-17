import { NextFunction, Request, Response } from "express-serve-static-core";
import { AccessToken } from "../../../../models/AccessToken";
import { User } from "../../../../models/User";
import { Shared } from "../../../../shared";
import { Controller } from "../../../../http/controller";
import * as moment from "moment";

export function getToken(this: Controller) {
    return (req: Request, res: Response, next: NextFunction) => {
        const user = req.user as User;
        const accessToken = user.accessToken;

        AccessToken.findOne({
            where: {
                userID: user.uuid,
                accessToken: accessToken.access_token,
            },
        })
            .then(async (token) => {
                if (!token) throw new Error("invalid access token");
                if (token.expiresAt < new Date()) {
                    throw new Error("access token expired");
                }

                token.expiresAt = moment().add(Shared.env.getNumber("OAUTH_TOKEN_EXPIRES_IN"), "seconds").toDate();
                await token.save();

                res.setHeader("Authorization", `${token.tokenType} ${token.accessToken}`);
                res.json({
                    accessToken: user.accessToken,
                    refreshToken: user.accessToken.refresh_token,
                });
            })
            .catch(next);
    };
}
