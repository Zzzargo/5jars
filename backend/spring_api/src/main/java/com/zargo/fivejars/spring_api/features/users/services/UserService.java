package com.zargo.fivejars.spring_api.features.users.services;

import com.zargo.fivejars.spring_api.common.exceptions.ResourceNotFoundException;
import com.zargo.fivejars.spring_api.features.users.models.User;
import com.zargo.fivejars.spring_api.features.users.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;

    public User getUserByUsername(final String username) {
        return userRepository.findUserByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User with username " + username + " not found"));
    }

    public User getUserById(final UUID id) {
        return userRepository.findUserById(id)
                .orElseThrow(() ->  new ResourceNotFoundException("User with id " + id + " not found"));
    }
}
