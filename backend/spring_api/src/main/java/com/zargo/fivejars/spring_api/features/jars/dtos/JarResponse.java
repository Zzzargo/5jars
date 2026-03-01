package com.zargo.fivejars.spring_api.features.jars.dtos;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record JarResponse(
        UUID id,
        String name,
        String description,
        BigDecimal balance,
        BigDecimal coefficient,
        Instant createdAt
) {
}
