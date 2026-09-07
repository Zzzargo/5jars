package com.zargo.fivejars.spring_server.features.users.dtos;

import java.time.Instant;
import java.util.UUID;

public record UserResponse(UUID id, String username, Instant createdAt) {
}
