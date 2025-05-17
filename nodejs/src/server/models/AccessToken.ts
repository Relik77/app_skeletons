import {
    AllowNull,
    AutoIncrement,
    Column,
    CreatedAt,
    DataType,
    Default,
    ForeignKey,
    Model,
    PrimaryKey,
    Table,
    Unique,
    UpdatedAt,
} from "sequelize-typescript";
import { objectID } from "../utils";
import { User } from "./User";

@Table({
    freezeTableName: true,
    tableName: "oauth_token",
    charset: "utf8mb4",
    collate: "utf8mb4_unicode_ci",
})
export class AccessToken extends Model<AccessToken> {
    @PrimaryKey
    @AutoIncrement
    @Column(DataType.INTEGER)
    id?: number = null;

    @AllowNull(false)
    @Unique
    @Default(objectID)
    @Column(DataType.STRING)
    tokenID: string;

    @AllowNull(true)
    @ForeignKey(() => User)
    @Column(DataType.STRING)
    userID: string;

    @AllowNull(false)
    @Column(DataType.STRING)
    tokenType: string;

    @AllowNull(false)
    @Column(DataType.STRING(1024))
    accessToken: string;

    @AllowNull(true)
    @Column(DataType.STRING(1024))
    refreshToken?: string;

    @AllowNull(false)
    @Column(DataType.DATE)
    expiresAt: Date;

    @AllowNull(false)
    @CreatedAt
    @Column(DataType.DATE)
    createdAt?: Date = null;

    @AllowNull(false)
    @UpdatedAt
    @Column(DataType.DATE)
    updatedAt?: Date = null;
}
