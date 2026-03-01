package com.zargo.fivejars.spring_api.features.jars.repository;

import com.zargo.fivejars.spring_api.features.jars.models.Jar;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface JarsRepository extends JpaRepository<Jar, UUID> {
    List<Jar> findAllByOwnerId(UUID ownerId);
}
