package com.zargo.fivejars.spring_server.common.exceptions;

public class CobolExecutionException extends RuntimeException {
    public CobolExecutionException(final String message) {
        super("COBOL Execution Failed: " + message);
    }
}
