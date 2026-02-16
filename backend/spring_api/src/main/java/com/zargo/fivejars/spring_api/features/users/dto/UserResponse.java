package com.zargo.fivejars.spring_api.features.users.dto;

import java.util.Date;

public record UserResponse(String username, String passwordHash, Date lastAccess) {
}
