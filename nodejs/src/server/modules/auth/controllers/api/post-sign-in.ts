import { NextFunction, Request, Response } from "express-serve-static-core";
import { OAuthException } from "../../../../errors";
import { AccessToken } from "../../../../models/AccessToken";
import { Controller } from "../../../../http/controller";
import { User } from "../../../../models/User";

export function postSignIn(this: Controller) {
    return (req: Request, res: Response, next: NextFunction) => {
        const Body: {
            type: "password";
            login: string;
            password: string;
        } = req.body;

        User.findOne({ where: { email: Body.login } }).then(async (user) => {
            if (!user) throw new OAuthException("User not found");

            // if (user.password !== Body.password) throw new OAuthException("Invalid password");

            const accessToken = new AccessToken();
            // TODO
            await accessToken.save();

            res.json({});
        });
    };
}
