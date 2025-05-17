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

@Table({
    freezeTableName: true,
    tableName: "remote_config",
    charset: "utf8mb4",
    collate: "utf8mb4_unicode_ci",
})
export class RemoteConfig extends Model<RemoteConfig> {
    @PrimaryKey
    @AutoIncrement
    @Column(DataType.INTEGER)
    id?: number = null;

    @AllowNull(false)
    @Column(DataType.STRING)
    name: string;

    @AllowNull(true)
    @Default(null)
    @Column(DataType.STRING(1024))
    value: string;

    @AllowNull(false)
    @Column(DataType.STRING)
    type: string;

    @AllowNull(true)
    @Default(null)
    @Column(DataType.STRING)
    description: string;

    @AllowNull(true)
    @Default(null)
    @Column(DataType.STRING)
    environment: string;

    @AllowNull(false)
    @Default(true)
    @Column(DataType.BOOLEAN)
    enable: boolean;

    @AllowNull(false)
    @CreatedAt
    @Column(DataType.DATE)
    createdAt?: Date = null;

    @AllowNull(false)
    @UpdatedAt
    @Column(DataType.DATE)
    updatedAt?: Date = null;
}
