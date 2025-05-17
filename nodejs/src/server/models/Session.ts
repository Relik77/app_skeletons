import {
    AllowNull,
    Column,
    CreatedAt,
    DataType,
    ForeignKey,
    Model,
    PrimaryKey,
    Table,
    UpdatedAt,
} from "sequelize-typescript";
import { User } from "./User";

@Table({
    freezeTableName: true,
    tableName: "user_session",
    charset: "utf8mb4",
    collate: "utf8mb4_unicode_ci",
})
export class Session extends Model<Session> {
    @PrimaryKey
    @Column(DataType.STRING)
    sid: number;

    @AllowNull(true)
    @ForeignKey(() => User)
    @Column(DataType.STRING)
    userID: string;

    @AllowNull(true)
    @Column(DataType.TEXT)
    data: string;

    @AllowNull(true)
    @Column(DataType.DATE)
    expires: Date;

    @AllowNull(false)
    @CreatedAt
    @Column(DataType.DATE)
    createdAt: Date;

    @AllowNull(false)
    @UpdatedAt
    @Column(DataType.DATE)
    updatedAt: Date;
}
