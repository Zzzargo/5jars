package com.zargo.fivejars.spring_api.features.authentication.exceptions;

import org.springframework.security.core.AuthenticationException;

public class InvalidTokenException extends AuthenticationException {
    public InvalidTokenException() {
        super("Token is expired or invalid");
    }
}
