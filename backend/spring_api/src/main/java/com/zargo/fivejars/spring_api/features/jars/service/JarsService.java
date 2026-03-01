package com.zargo.fivejars.spring_api.features.jars.service;

import com.zargo.fivejars.spring_api.features.jars.dtos.CreateJarRequest;
import com.zargo.fivejars.spring_api.features.jars.models.Jar;
import com.zargo.fivejars.spring_api.features.jars.repository.JarsRepository;
import com.zargo.fivejars.spring_api.features.users.models.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class JarsService {
    private final JarsRepository jarsRepository;

    public List<Jar> getJars(final UUID ownerId) {
        return jarsRepository.findAllByOwnerId(ownerId);
    }

    @Transactional
    public Jar createJar(final CreateJarRequest request, final User owner) {
        log.info("Creating new jar '{}' for user '{}'", request.name(), owner.getUsername());

        // TODO: Ensure total of coefficients <= 100

        Jar jar = Jar.builder()
                .name(request.name())
                .description(request.description())
                .coefficient(request.coefficient())
                .owner(owner)
                // Defaults
                .balance(BigDecimal.ZERO)
                .createdAt(Instant.now())
                .build();

        return jarsRepository.save(jar);
    }
}
