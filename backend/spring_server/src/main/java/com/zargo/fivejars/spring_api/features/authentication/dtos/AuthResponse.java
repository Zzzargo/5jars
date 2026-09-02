package com.zargo.fivejars.spring_api.features.authentication.dtos;

import com.zargo.fivejars.spring_api.features.users.dtos.UserResponse;

public record AuthResponse(String token, UserResponse user) {
}
