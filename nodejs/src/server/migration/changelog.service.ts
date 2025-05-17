import * as fs                from "fs-extra";
import { ChangelogInterface } from "./changelog.interface";

export class ChangelogService {
    private static changelog: ChangelogInterface;
    
    public static getValue<K extends keyof ChangelogInterface>(key: K, defaultValue?: ChangelogInterface[K]): ChangelogInterface[K] {
        if (!this.changelog) this.loadChangelog();
        return this.changelog[key] || defaultValue;
    }
    
    public static setValue<K extends keyof ChangelogInterface>(key: K, value: ChangelogInterface[K]) {
        if (!this.changelog) this.loadChangelog();
        this.changelog[key] = value;
        this.saveChangelog();
    }
    
    private static loadChangelog() {
        if (fs.existsSync("changelog.json")) {
            this.changelog = fs.readJSONSync("changelog.json");
        } else {
            this.changelog = {};
        }
    }
    
    public static saveChangelog() {
        fs.outputJSONSync("changelog.json", this.changelog, {
            spaces: 4
        });
    }
}
