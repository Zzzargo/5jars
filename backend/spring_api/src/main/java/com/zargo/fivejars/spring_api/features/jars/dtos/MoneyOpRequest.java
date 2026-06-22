package com.zargo.fivejars.spring_api.features.jars.dtos;

import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

public record MoneyOpRequest(
        @NotNull BigDecimal amount,
        String description
) {
}