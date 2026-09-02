package com.zargo.fivejars.spring_api.common.exceptions;

public class UniqueConstraintViolationException extends RuntimeException {
    public UniqueConstraintViolationException(final String message) {
        super(message);
    }
}
