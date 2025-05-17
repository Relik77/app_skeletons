import { NextFunction, Request, Response } from "express-serve-static-core";
import { Controller } from "../../../../http/controller";
import { User } from "../../../../models/User";

export function getProfile(this: Controller) {
    return (req: Request, res: Response, next: NextFunction) => {
        const user = req.user as User;

        return User.findOne({
            where: {
                uuid: user.uuid,
            },
        }).then(async (user: User) => {
            if (!user) throw new Error();

            res.json({
                uuid: user.uuid,
                email: user.email,
                first_name: user.first_name,
                last_name: user.last_name,
                nickname: user.nickname,
                picture: user.picture,
                description: user.description,
                language: user.language,
                country: user.country,
                timezone: user.timezone,
                accessToken: user.accessToken || req.session.userToken,
            });
        });
    };
}
