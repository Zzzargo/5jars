package com.zargo.fivejars.spring_api.features.users.exceptions;

import com.zargo.fivejars.spring_api.common.exceptions.ResourceNotFoundException;

public class UserNotFoundException extends ResourceNotFoundException {
    public UserNotFoundException(final String identifier) {
        super("User " + identifier + " not found");
    }

    public UserNotFoundException() {
        super("User not found");
    }
}
