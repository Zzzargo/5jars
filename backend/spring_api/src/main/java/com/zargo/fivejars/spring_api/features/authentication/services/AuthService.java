package com.zargo.fivejars.spring_api.features.authentication.services;

import com.zargo.fivejars.spring_api.common.exceptions.InvalidCredentialsException;
import com.zargo.fivejars.spring_api.common.exceptions.UsernameTakenException;
import com.zargo.fivejars.spring_api.features.authentication.dtos.AuthResponse;
import com.zargo.fivejars.spring_api.features.authentication.dtos.LoginRequest;
import com.zargo.fivejars.spring_api.features.authentication.dtos.RegisterRequest;
import com.zargo.fivejars.spring_api.features.users.repositories.UserRepository;
import com.zargo.fivejars.spring_api.features.users.models.User;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final AuthenticationManager authenticationManager;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthResponse register(final RegisterRequest request) {
        if (userRepository.findUserByUsername(request.username()).isPresent()) {
            throw new UsernameTakenException(request.username());
        }

        var user = User.builder()
                .username(request.username())
                .passwordHash(passwordEncoder.encode(request.password()))
                .build();

        user = userRepository.save(user);  // Let the db generate a UUID before using it for jwt generation
        var token = jwtService.generateToken(user);
        return new AuthResponse(token, user.getUsername());
    }

    public AuthResponse login(final LoginRequest request) {
        // The magic of DI
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.username(), request.password())
        );

        // If it didn't throw an exception, the login is successful
        var user = userRepository.findUserByUsername(request.username()).orElseThrow();  // Satisfy the runtime
        var token = jwtService.generateToken(user);
        return new AuthResponse(token, user.getUsername());
    }
}
