package com.zargo.fivejars.spring_api.features.users.model;

import jakarta.persistence.*;
import lombok.Getter;

import java.util.Date;
import java.util.UUID;

@Entity
@Table(name = "users")
@Getter
public final class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private UUID id;

    @Column(nullable = false, unique = true)
    private String username;

    @Column(name = "password_hash", nullable = false)
    private String passwordHash;

    @Column(name = "created_at", nullable = false)
    private Date createdAt;

    @Column(name = "last_access", nullable = false)
    private Date lastAccess;
}
