package com.zargo.fivejars.spring_api.features.users.repository;

import com.zargo.fivejars.spring_api.features.users.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface UserRepository extends JpaRepository<User, UUID> {
    Optional<User> findByUsername(final String username);
}
