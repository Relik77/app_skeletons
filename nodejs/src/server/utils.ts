import { ObjectID } from "bson";
import * as crypto from "crypto";
import { BinaryToTextEncoding } from "crypto";
import * as fs from "fs-extra";
import * as moment from "moment";
import { Moment } from "moment";
import * as path from "path";
import sqlColorize from "sequelize-log-syntax-colors";
import * as sharp from "sharp";

export function getMentionedUsers(
    text: string,
    users: Array<{
        username: string;
        userID: string;
    }>,
    prefix = "@"
): Array<string> {
    const mentionedUsers = [];
    for (const user of users) {
        const searchString = `<span class="mention" user_id="${user.userID}">${prefix}${user.username}</span>`;
        if (text.includes(searchString)) {
            mentionedUsers.push(user.userID);
        }
    }
    return mentionedUsers;
}

export function getMentionedRoles(
    text: string,
    roles: Array<{
        name: string;
        roleID: string;
    }>,
    prefix = "@"
): Array<string> {
    const mentionedRoles = [];
    for (const role of roles) {
        const searchString = `<span class="mention" role_id="${role.roleID}">${prefix}${role.name}</span>`;
        if (text.includes(searchString)) {
            mentionedRoles.push(role.roleID);
        }
    }
    return mentionedRoles;
}

export const hmacSha256 = (data: string, key: string, digest: BinaryToTextEncoding | "buffer" = "hex") => {
    return crypto
        .createHmac("sha256", key)
        .update(data)
        .digest(digest == "buffer" ? undefined : digest);
};

export const sha256 = (data: string) => {
    return crypto.createHash("sha256").update(data).digest("hex");
};

export const getHostName = (url: string) => {
    const match = url.match(/^https?:\/\/([^\/?#]*)/);
    return match ? match[1] : null;
};

export const encodePath = (path: string) => {
    path = decodeURIComponent(path.replace(/\+/g, " "));
    path = encodeURIComponent(path).replace(/[!'()*]/g, (c) => "%" + c.charCodeAt(0).toString(16).toUpperCase());
    path = path.replace(/%2F/g, "/");
    return path;
};

export interface FileUploadInputInterface {
    fieldName?: string;
    originalFilename: string;
    path?: string;
    size?: number;
    name?: string;
    type?: string;
    headers?: {
        [name: string]: string;
    };
}

export interface Base64FileUploadInputInterface {
    originalFilename: string;
    data: string;
}

export function objectID(): string {
    return new ObjectID().toHexString();
}

export async function imageOptimizer(file: FileUploadInputInterface) {
    const originalFilePath = file.path;
    const image = sharp(originalFilePath);
    const metadata = await image.metadata();

    if (metadata.width > 1920) {
        image.resize({
            width: 1920,
        });
    }

    image.webp({
        quality: 70,
    });

    const filePath = path.dirname(originalFilePath);
    const fileName = objectID();
    const fullPath = `${filePath}/${fileName}.webp`;
    await image.toFile(fullPath);

    fs.unlink(originalFilePath).catch((err) => {});

    const stats = fs.statSync(fullPath);
    file.originalFilename = path.basename(file.originalFilename, path.extname(file.originalFilename)) + ".webp";
    file.name = fileName + ".webp";
    file.path = fullPath;
    file.type = "image/webp";
    file.size = stats.size;
}

export function waitTimeout(value: number) {
    return new Promise((resolve) => {
        setTimeout(resolve, value);
    });
}

export function toTimestamp(value: Moment | Date | number | string | null): number | null {
    if (value === null) return null;
    const date = moment(value);
    if (!date.isValid()) return null;
    return date.valueOf();
}

export const toBoolean: (value: any) => boolean = (value: any) => {
    if (typeof value === "string") {
        return /^(true|t|yes|y|1)$/i.test(value.trim());
    }

    if (typeof value === "number") {
        return value > 0;
    }

    if (typeof value === "boolean") {
        return value;
    }

    return false;
};

export const sequelizeLogger = (text) => console.log(sqlColorize(text));
