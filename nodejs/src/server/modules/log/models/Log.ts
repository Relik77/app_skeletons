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
import { objectID } from "../../../utils";

@Table({
    freezeTableName: true,
    tableName: "app_log",
})
export class Log extends Model {
    @PrimaryKey
    @AutoIncrement
    @Column(DataType.INTEGER)
    log_id: number;

    @Default(objectID)
    @Column(DataType.STRING)
    uuid: string;

    @AllowNull(false)
    @Column(DataType.TEXT)
    log_data: string;

    @AllowNull(true)
    @Column(DataType.TEXT)
    log_comment: string;

    @AllowNull(false)
    @Column(DataType.STRING)
    log_md5: string;

    @AllowNull(false)
    @Column(DataType.STRING)
    log_type: string;

    @AllowNull(false)
    @Column(DataType.STRING)
    log_source: string;

    @AllowNull(false)
    @Column(DataType.ENUM("new", "ignored", "not a bug", "solved", "archived"))
    log_status: "new" | "ignored" | "not a bug" | "solved" | "archived";

    @AllowNull(false)
    @Default(1)
    @Column(DataType.INTEGER)
    log_produced: number;

    @AllowNull(false)
    @Column(DataType.DATE)
    first_seen: Date;

    @AllowNull(false)
    @Column(DataType.DATE)
    last_seen: Date;

    @AllowNull(false)
    @CreatedAt
    @Column(DataType.DATE)
    log_insert: Date;

    @AllowNull(false)
    @UpdatedAt
    @Column(DataType.DATE)
    log_update: Date;
}
