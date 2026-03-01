package com.zargo.fivejars.spring_api.features.jars.dtos;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.math.BigDecimal;

public record IncomeRequest(
        @NotNull @Positive BigDecimal amount,
        @NotBlank String description
) {
}
