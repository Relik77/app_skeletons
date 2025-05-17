import { Readable } from "stream";
import { AppInterface } from "../../interfaces/app.interface";
import { Controller } from "../controller";

class ReadablePackage extends Readable {
    _read() {}
}

export class PageController extends Controller {
    constructor(app: AppInterface) {
        super(app);

        app.express.use("/", this.router);
    }
}
