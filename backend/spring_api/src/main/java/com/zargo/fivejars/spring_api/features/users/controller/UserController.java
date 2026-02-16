package com.zargo.fivejars.spring_api.features.users.controller;

import com.zargo.fivejars.spring_api.features.users.dto.UserResponse;
import com.zargo.fivejars.spring_api.features.users.service.UserService;
import lombok.RequiredArgsConstructor;
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
    public UserResponse getUser(@PathVariable final String username) {
        return userService.getUserByUsername(username);
    }
}
