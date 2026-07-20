package com.zargo.fivejars.spring_api.features.jars.repositories;

import com.zargo.fivejars.spring_api.features.jars.models.Jar;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface JarsRepository extends JpaRepository<Jar, UUID> {
    List<Jar> findAllByOwnerId(UUID ownerId);

    // The extra condition for the owner ID is mandatory for security
    Optional<Jar> findByIdAndOwnerId(UUID id, UUID ownerId);
}