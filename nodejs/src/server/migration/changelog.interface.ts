export interface VersionInfo {
    version: string;
    date: string;
}

export interface MigrationInterface {
    installed: VersionInfo[];
}

export interface ChangelogInterface {
    migration?: MigrationInterface;
}
