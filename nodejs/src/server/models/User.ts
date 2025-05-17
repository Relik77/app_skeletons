import {
    AllowNull,
    AutoIncrement,
    Column,
    CreatedAt,
    DataType,
    Default,
    Model,
    PrimaryKey,
    Table,
    UpdatedAt,
} from "sequelize-typescript";
import { objectID } from "../utils";
import { ProjectionAlias, Sequelize } from "sequelize";
import moment = require("moment");

interface UserAccessToken {
    token_type?: string;
    access_token: string;
    refresh_token?: string;
    expires_at?: Date;
}

@Table({
    freezeTableName: true,
    tableName: "users",
})
export class User extends Model<User> {
    @PrimaryKey
    @AutoIncrement
    @Column(DataType.INTEGER)
    id?: number = null;

    @Default(objectID)
    @Column(DataType.STRING)
    uuid: string;

    @Column(DataType.VIRTUAL)
    accessToken: UserAccessToken;

    @Column(DataType.STRING)
    email: string;

    @Column(DataType.STRING)
    first_name: string;

    @Column(DataType.STRING)
    last_name: string;

    @Column(DataType.STRING)
    nickname: string;

    @Column(DataType.STRING)
    picture: string;

    @Column(DataType.TEXT)
    description: string;

    @Column(DataType.STRING)
    language: string;

    @Column(DataType.STRING)
    country: string;

    @Column(DataType.STRING)
    timezone: string;

    @Column(DataType.STRING)
    mobile_phone: string;

    @Default("active")
    @Column(DataType.ENUM("waiting", "active", "demeted"))
    status: "waiting" | "active" | "demeted";

    @AllowNull(false)
    @CreatedAt
    @Column(DataType.DATE)
    created_at: Date;

    @AllowNull(false)
    @UpdatedAt
    @Column(DataType.DATE)
    updated_at: Date;

    get shortName(): string {
        if (this.first_name) {
            return this.first_name;
        }
        if (this.last_name) {
            return this.last_name;
        }
        if (this.nickname) {
            return this.nickname;
        }
        if (this.email) {
            return this.email.split("@")[0].replace(/[._]/g, " ");
        }
        return "";
    }

    get fullName(): string {
        if (this.first_name && this.last_name) {
            return `${this.first_name} ${this.last_name}`;
        }
        return this.shortName;
    }
}
