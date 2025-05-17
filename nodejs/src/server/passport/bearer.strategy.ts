import { Request } from "express-serve-static-core";
import { IVerifyOptions, Strategy } from "passport-http-bearer";
import { OAuthException } from "../errors";
import { AccessToken } from "../models/AccessToken";
import { User } from "../models/User";
import * as moment from "moment";
import { Shared } from "../shared";

export const BearerStrategy = new Strategy(
    {
        scope: "",
        realm: "Users",
        passReqToCallback: true,
    },
    (req: Request, token: string, done: (error: any, user?: any, options?: IVerifyOptions | string) => void) => {
        Shared.logger.verbose("Checking bearer token");
        AccessToken.findOne({
            where: {
                accessToken: token,
            },
        })
            .then((accessToken) => {
                if (!accessToken || moment().isAfter(accessToken.expiresAt)) {
                    Shared.logger.verbose("Token invalid or expired");
                    return done(new OAuthException("Token invalid or expired"), false);
                }

                Shared.logger.verbose("Token valid");
                return User.findOne({
                    where: {
                        smanck_id: accessToken.userID,
                    },
                }).then((user) => {
                    user.accessToken = {
                        access_token: accessToken.accessToken,
                        expires_at: accessToken.expiresAt,
                        token_type: accessToken.tokenType,
                    };
                    Shared.logger.verbose("User found");
                    return done(null, user);
                });
            })
            .catch(done);
    }
);
