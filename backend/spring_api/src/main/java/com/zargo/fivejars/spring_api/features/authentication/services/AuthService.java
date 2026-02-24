package com.zargo.fivejars.spring_api.features.authentication.services;

import com.zargo.fivejars.spring_api.features.authentication.exceptions.InvalidCredentialsException;
import com.zargo.fivejars.spring_api.features.authentication.exceptions.UsernameTakenException;
import com.zargo.fivejars.spring_api.features.authentication.dtos.AuthResponse;
import com.zargo.fivejars.spring_api.features.authentication.dtos.LoginRequest;
import com.zargo.fivejars.spring_api.features.authentication.dtos.RegisterRequest;
import com.zargo.fivejars.spring_api.features.users.repositories.UserRepository;
import com.zargo.fivejars.spring_api.features.users.models.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Slf4j
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
        Authentication auth;
        try {
            auth = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.username(), request.password())
            );
        } catch (AuthenticationException e) {
            log.warn("Failed login attempt for username {}", request.username());
            throw new InvalidCredentialsException();
        }

        // This runs only if exceptions were not thrown
        var user = (User) auth.getPrincipal();
        assert user != null;  // To be sure. The user can't be null because the auth manager throws an exception inside
        var token = jwtService.generateToken(user);
        return new AuthResponse(token, user.getUsername());
    }
}
