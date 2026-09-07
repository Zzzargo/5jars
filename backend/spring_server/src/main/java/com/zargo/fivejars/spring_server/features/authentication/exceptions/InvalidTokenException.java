package com.zargo.fivejars.spring_server.features.authentication.exceptions;

import org.springframework.security.core.AuthenticationException;

public class InvalidTokenException extends AuthenticationException {
    public InvalidTokenException() {
        super("Token is expired or invalid");
    }
}
