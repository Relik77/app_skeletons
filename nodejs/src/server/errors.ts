export class CustomError extends Error {
    status: number = 400;
    code: number   = 1;
    
    constructor(message: string, name: string) {
        super(message);
        
        this.name = name;
    }
    
    toJSON() {
        return {
            code: this.code,
            name: this.name,
            message: this.message
        };
    }
}

export class NotFoundException extends CustomError {
    status = 404;
    
    constructor(message: string = "Not found") {
        super(message, "NOT_FOUND");
    }
}

export class OAuthException extends CustomError {
    status: 401 | 403;
    
    constructor(message: string = "Error validating access token: The session is invalid", status: 401 | 403 = 401) {
        super(message, "OAuthException");
        
        if (status == 403 && !message) {
            this.message = "Error: You have been blocked";
        }
        this.status = status;
        this.code   = 2;
    }
}

export class AccessException extends CustomError {
    status: 403 = 403;
    
    constructor() {
        super("Forbidden", "AccessException");
    }
}

export class RequestException extends CustomError {
    constructor(message: string = "The syntax of the query is incorrect.") {
        super(message, "BAD_REQUEST");
    }
}
