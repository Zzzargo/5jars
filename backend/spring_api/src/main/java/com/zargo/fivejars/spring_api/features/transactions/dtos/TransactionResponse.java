package com.zargo.fivejars.spring_api.features.transactions.dtos;

import com.zargo.fivejars.spring_api.features.transactions.models.TransactionType;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record TransactionResponse(
        UUID id,
        UUID jarId,
        String jarName, // The user will want the jar name, not the ID
        BigDecimal amount,
        TransactionType type,
        String description,
        UUID correlationId,
        Instant createdAt
) {}
