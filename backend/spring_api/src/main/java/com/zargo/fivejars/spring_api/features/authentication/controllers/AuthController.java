package com.zargo.fivejars.spring_api.features.authentication.controllers;

import com.zargo.fivejars.spring_api.features.authentication.dtos.AuthResponse;
import com.zargo.fivejars.spring_api.features.authentication.dtos.LoginRequest;
import com.zargo.fivejars.spring_api.features.authentication.dtos.RegisterRequest;
import com.zargo.fivejars.spring_api.features.authentication.services.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@RequestBody final RegisterRequest registerRequest) {
        return ResponseEntity.ok(authService.register(registerRequest));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody final LoginRequest loginRequest) {
        return ResponseEntity.ok(authService.login(loginRequest));
    }
}
