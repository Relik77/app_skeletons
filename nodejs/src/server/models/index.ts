import { ModelCtor } from "sequelize-typescript/dist/model/model/model";
import { AccessToken } from "./AccessToken";
import { RemoteConfig } from "./RemoteConfig";
import { User } from "./User";

export const models: Array<ModelCtor> = [AccessToken, RemoteConfig, User];
