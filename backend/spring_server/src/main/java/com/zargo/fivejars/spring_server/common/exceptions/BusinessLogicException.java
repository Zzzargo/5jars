package com.zargo.fivejars.spring_server.common.exceptions;

public class BusinessLogicException extends RuntimeException {
    public BusinessLogicException(final String message) {
        super("Business Logic Exception: " + message);
    }
}
