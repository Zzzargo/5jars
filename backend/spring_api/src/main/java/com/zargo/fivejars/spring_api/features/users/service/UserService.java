package com.zargo.fivejars.spring_api.features.users.service;

import com.zargo.fivejars.spring_api.common.exceptions.ResourceNotFoundException;
import com.zargo.fivejars.spring_api.features.users.dto.UserResponse;
import com.zargo.fivejars.spring_api.features.users.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;

    public UserResponse getUserByUsername(final String username) {
        return userRepository.findByUsername(username)
                .map(u -> new UserResponse(u.getUsername(), u.getPasswordHash(), u.getLastAccess()))
                .orElseThrow(() -> new ResourceNotFoundException("User with username " + username + " not found"));
    }
}
