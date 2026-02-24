package com.zargo.fivejars.spring_api.features.users.controllers;

import com.zargo.fivejars.spring_api.features.users.dtos.UserResponse;
import com.zargo.fivejars.spring_api.features.users.models.User;
import com.zargo.fivejars.spring_api.features.users.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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
    // Don't allow users other than [username] to access the endpoint
    @PreAuthorize("#username == authentication.principal.username")
    public UserResponse getUser(@PathVariable final String username) {
        var user = userService.getUserByUsername(username);
        return new UserResponse(user.getId(), user.getUsername(), user.getCreatedAt());
    }

    @GetMapping("/me")
    public UserResponse getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        assert authentication != null;  // It will never go there, but it's good to not trust oneself
        User currentUser = (User) authentication.getPrincipal();
        assert currentUser != null;  // Same here

        return new UserResponse(currentUser.getId(), currentUser.getUsername(), currentUser.getCreatedAt());
    }
}
