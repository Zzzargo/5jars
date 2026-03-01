package com.zargo.fivejars.spring_api.features.jars.models;

import com.zargo.fivejars.spring_api.features.jars.dtos.JarResponse;
import com.zargo.fivejars.spring_api.features.users.models.User;
import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import lombok.*;
import org.hibernate.annotations.DynamicInsert;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "jars")
@Getter @NoArgsConstructor @AllArgsConstructor @Builder
@DynamicInsert
public class Jar {
    @Id
    @GeneratedValue
    @Column(columnDefinition = "uuid", nullable = false, updatable = false)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)  // This will not load the user data if not specified explicitly
    @JoinColumn(name = "owner_id", nullable = false)
    private User owner;

    @Column(nullable = false, length = 100)
    private String name;

    private String description;

    @DecimalMin("0.00")
    @DecimalMax("100.00")
    @Column(precision = 5, scale = 2, nullable = false)
    private BigDecimal coefficient;

    @Column(precision = 15, scale = 4, nullable = false)
    private BigDecimal balance;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    public static JarResponse toResponse(final Jar jar) {
        return new JarResponse(
                jar.getId(),
                jar.getName(),
                jar.getDescription(),
                jar.getBalance(),
                jar.getCoefficient(),
                jar.getCreatedAt()
        );
    }
}
