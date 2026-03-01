package com.zargo.fivejars.spring_api.features.jars.controller;

import com.zargo.fivejars.spring_api.features.jars.dtos.CreateJarRequest;
import com.zargo.fivejars.spring_api.features.jars.dtos.JarResponse;
import com.zargo.fivejars.spring_api.features.jars.models.Jar;
import com.zargo.fivejars.spring_api.features.jars.service.JarsService;
import com.zargo.fivejars.spring_api.features.users.models.User;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/jars")
@RequiredArgsConstructor
public class JarsController {
    private final JarsService jarsService;

    @GetMapping
    public List<JarResponse> getMyAccounts() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        assert authentication != null;
        User currentUser = (User) authentication.getPrincipal();
        assert currentUser != null;

        return jarsService.getJars(currentUser.getId()).stream()
                .map(Jar::toResponse)
                .toList();
    }

    @PostMapping
    public ResponseEntity<JarResponse> createJar(
            @Valid @RequestBody CreateJarRequest request,
            @AuthenticationPrincipal User currentUser
    ) {
        final Jar newJar = jarsService.createJar(request, currentUser);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(Jar.toResponse(newJar));
    }
}
