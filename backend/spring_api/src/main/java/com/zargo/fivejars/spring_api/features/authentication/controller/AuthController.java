package com.zargo.fivejars.spring_api.features.authentication.controller;

import com.zargo.fivejars.spring_api.features.authentication.dtos.AuthResponse;
import com.zargo.fivejars.spring_api.features.authentication.dtos.LoginRequest;
import com.zargo.fivejars.spring_api.features.authentication.dtos.RegisterRequest;
import com.zargo.fivejars.spring_api.features.authentication.services.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@RequestBody final RegisterRequest registerRequest) {
        AuthResponse response = authService.register(registerRequest);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(response);
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody final LoginRequest loginRequest) {
        // TODO: update lastAccess
        return ResponseEntity.ok(authService.login(loginRequest));
    }
}
