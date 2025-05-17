import { AppInterface } from "../../interfaces/app.interface";
import { Controller } from "../controller";

export class ApiController extends Controller {
    constructor(app: AppInterface) {
        super(app);

        app.express.use("/api", this.router);
    }
}
