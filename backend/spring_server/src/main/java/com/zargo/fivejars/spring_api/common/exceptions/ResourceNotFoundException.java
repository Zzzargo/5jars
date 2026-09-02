package com.zargo.fivejars.spring_api.common.exceptions;

public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(final String resName) {
        super("Resource not found: " + resName);
    }
}
