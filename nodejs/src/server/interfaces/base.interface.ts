export class BaseError extends Error {
    code: string;
    hint?: string;

    constructor(code: string, hint?: string, message?: string) {
        super(message || hint || code);
        this.code = code;
        this.hint = hint;
    }
}
