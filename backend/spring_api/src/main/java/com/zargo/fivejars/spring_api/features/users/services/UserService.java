package com.zargo.fivejars.spring_api.features.users.services;

import com.zargo.fivejars.spring_api.features.users.exceptions.UserNotFoundException;
import com.zargo.fivejars.spring_api.features.users.models.User;
import com.zargo.fivejars.spring_api.features.users.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;

    public User getUserByUsername(final String username) {
        return userRepository.findUserByUsername(username)
                .orElseThrow(() -> new UserNotFoundException(username));
    }

    public User getUserById(final UUID id) {
        return userRepository.findUserById(id)
                .orElseThrow(() ->  {
                    log.error("Attempted access to non-existent user UUID: {}", id);
                    return new UserNotFoundException();
                });
    }
}
