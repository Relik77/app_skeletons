import { AppInterface } from "../../../interfaces/app.interface";
import { Controller } from "../../../http/controller";
import { getProfile } from "./api/get-profile";
import { postSignIn } from "./api/post-sign-in";
import { getToken } from "./api/get-token";
import { getSignOut } from "./api/get-sign-out";
import { updateProfile } from "./api/update-profile";

export class AuthApiController extends Controller {
    constructor(app: AppInterface) {
        super(app);

        app.express.use("/api/auth", this.router);

        this.router.post("/sign-in", postSignIn.call(this));

        this.router.use(
            app.accessPermissions.ensurePermitted([
                [
                    "allow",
                    {
                        users: ["@"],
                    },
                ],
            ])
        );
        this.router.get("/token", getToken.call(this));
        this.router.get("/sign-out", getSignOut.call(this));
        this.router.get("/user", getProfile.call(this));
        this.router.post("/user", updateProfile.call(this));
    }
}
