package com.zargo.fivejars.spring_api.common.exceptions;

public class UsernameTakenException extends UniqueConstraintViolationException {
    public UsernameTakenException(final String username) {
        super("Username " + username + " is already taken");
    }
}
