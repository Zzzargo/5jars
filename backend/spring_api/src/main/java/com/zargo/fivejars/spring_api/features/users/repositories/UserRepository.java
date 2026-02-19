package com.zargo.fivejars.spring_api.features.users.repositories;

import com.zargo.fivejars.spring_api.features.users.models.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface UserRepository extends JpaRepository<User, UUID> {
    Optional<User> findUserByUsername(String username);

    Optional<User> findUserById(UUID id);
}
