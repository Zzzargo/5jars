package com.zargo.fivejars.spring_server.features.authentication.dtos;

import com.zargo.fivejars.spring_server.features.users.dtos.UserResponse;

public record AuthResponse(String token, UserResponse user) {
}
