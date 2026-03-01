package com.zargo.fivejars.spring_api.features.jars.dtos;

import jakarta.validation.constraints.*;
import java.math.BigDecimal;

public record CreateJarRequest(
        @NotBlank(message = "Jar name is required")
        @Size(max = 100, message = "Jar name must be under 100 characters")
        String name,

        @Size(max = 255, message = "Description too long")
        String description,

        @NotNull(message = "Coefficient is required")
        @DecimalMin(value = "0.00", message = "Coefficient cannot be negative")
        @DecimalMax(value = "100.00", message = "Coefficient cannot exceed 100%")
        BigDecimal coefficient
) {}
