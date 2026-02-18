package com.zargo.fivejars.spring_api.features.users.controllers;

import com.zargo.fivejars.spring_api.features.users.dtos.UserResponse;
import com.zargo.fivejars.spring_api.features.users.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;

    @GetMapping("/{username}")
    // TODO: restrict user access
    public UserResponse getUser(@PathVariable final String username) {
        var user = userService.getUserByUsername(username);
        return new UserResponse(user.getId(), user.getUsername(), user.getCreatedAt());
    }
}
