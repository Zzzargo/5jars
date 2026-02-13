package com.zargo.fivejars.spring_api.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public final class HomeController {
    @GetMapping("/")
    public Map<String, String> index() {
        return Map.of(
                "status", "online",
                "message", "Five Jars Ultra Spring API is running",
                "version", "4.0.2"
        );
    }
}
