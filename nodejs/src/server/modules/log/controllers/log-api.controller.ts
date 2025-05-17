import { Controller } from "../../../http/controller";
import { AppInterface } from "../../../interfaces/app.interface";
import { createLog } from "./api/create-log";

export class LogApiController extends Controller {
    constructor(app: AppInterface) {
        super(app);

        app.express.use("/api/log", this.router);

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

        this.router.post("/", createLog.call(this));
    }
}
