package com.zargo.fivejars.spring_api.common.exceptions;

public class BusinessLogicException extends RuntimeException {
    public BusinessLogicException(final String message) {
        super("BusinessLogicException: " + message);
    }
}
