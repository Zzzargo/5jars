package com.zargo.fivejars.spring_api.features.users.models;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.DynamicInsert;
import org.jspecify.annotations.Nullable;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "users")
@Getter @NoArgsConstructor @AllArgsConstructor @Builder
@DynamicInsert  // Allows for empty fields, postgres will set the default there
public final class User implements UserDetails {
    @Id
    @GeneratedValue  // Tell Hibernate to use the DB for UUID generation
    @Column(columnDefinition = "uuid", nullable = false, updatable = false)
    private UUID id;

    @Column(nullable = false, unique = true)
    private String username;

    @Column(name = "password_hash", nullable = false)
    private String passwordHash;

    @Column(name = "created_at", nullable = false)
    private Date createdAt;

    @Column(name = "last_access", nullable = false)
    private Date lastAccess;

    @Override @NonNull
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of();  // TODO: add roles later
    }

    @Override
    public String getPassword() {
        return passwordHash;
    }
}
