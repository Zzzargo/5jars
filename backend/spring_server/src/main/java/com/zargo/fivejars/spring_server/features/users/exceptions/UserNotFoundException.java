package com.zargo.fivejars.spring_server.features.users.exceptions;

import com.zargo.fivejars.spring_server.common.exceptions.ResourceNotFoundException;

public class UserNotFoundException extends ResourceNotFoundException {
    public UserNotFoundException(final String identifier) {
        super("User " + identifier + " not found");
    }

    public UserNotFoundException() {
        super("User not found");
    }
}
