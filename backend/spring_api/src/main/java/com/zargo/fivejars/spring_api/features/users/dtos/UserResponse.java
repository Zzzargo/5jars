package com.zargo.fivejars.spring_api.features.users.dtos;

import java.util.Date;
import java.util.UUID;

public record UserResponse(UUID id, String username, Date createdAt) {
}
