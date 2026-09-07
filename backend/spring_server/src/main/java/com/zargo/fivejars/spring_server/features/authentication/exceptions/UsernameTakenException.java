package com.zargo.fivejars.spring_server.features.authentication.exceptions;

import com.zargo.fivejars.spring_server.common.exceptions.UniqueConstraintViolationException;

public class UsernameTakenException extends UniqueConstraintViolationException {
    public UsernameTakenException(final String username) {
        super("Username " + username + " is already taken");
    }
}
