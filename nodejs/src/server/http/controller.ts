import * as express from "express";
import { AppInterface } from "../interfaces/app.interface";

export abstract class Controller {
    protected router = express.Router();

    protected constructor(protected app: AppInterface) {}
}
