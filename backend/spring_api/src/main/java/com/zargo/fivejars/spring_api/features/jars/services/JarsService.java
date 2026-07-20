package com.zargo.fivejars.spring_api.features.jars.services;

import com.zargo.fivejars.spring_api.common.exceptions.BusinessLogicException;
import com.zargo.fivejars.spring_api.common.exceptions.ResourceNotFoundException;
import com.zargo.fivejars.spring_api.features.jars.dtos.CreateJarRequest;
import com.zargo.fivejars.spring_api.features.jars.dtos.MoneyOpRequest;
import com.zargo.fivejars.spring_api.features.jars.models.Jar;
import com.zargo.fivejars.spring_api.features.jars.models.Transaction;
import com.zargo.fivejars.spring_api.features.jars.models.TransactionType;
import com.zargo.fivejars.spring_api.features.jars.repositories.JarsRepository;
import com.zargo.fivejars.spring_api.features.jars.repositories.TransactionsRepository;
import com.zargo.fivejars.spring_api.features.users.models.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class JarsService {
    private final JarsRepository jarsRepository;
    private final TransactionsRepository transactionsRepository;

    public List<Jar> getJars(final UUID ownerId) {
        return jarsRepository.findAllByOwnerId(ownerId);
    }

    @Transactional
    public Jar createJar(final CreateJarRequest request, final User owner) {
        log.info(
                "Creating new jar '{}' for user '{}' with coefficient {}",
                request.name(), owner.getUsername(), request.coefficient()
        );

        // Validate coefficients sum
        List<Jar> currentJars = jarsRepository.findAllByOwnerId(owner.getId());
        BigDecimal totalCoeff = currentJars.stream()
                .map(Jar::getCoefficient)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        if (totalCoeff.compareTo(new BigDecimal("1")) > 0) {
            throw new BusinessLogicException("Jar coefficients must not sum up to more than 100%");
        }

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

    @Transactional
    public List<Jar> distributeIncome(final User user, final MoneyOpRequest request) {
        final BigDecimal totalAmount = request.amount();

        if (totalAmount.compareTo(new BigDecimal("0")) < 0) {
            throw new BusinessLogicException("Can't distribute a negative income");
        }

        List<Jar> jars = jarsRepository.findAllByOwnerId(user.getId());

        // Validate coefficients sum
        BigDecimal totalCoeff = jars.stream()
                .map(Jar::getCoefficient)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        if (totalCoeff.compareTo(new BigDecimal("1")) != 0) {
            throw new BusinessLogicException("Jar coefficients must sum to exactly 100% before distributing income.");
        }

        UUID correlationId = UUID.randomUUID(); // Same correlation ID for all transactions

        for (Jar jar : jars) {
            // AmountToAdd = Total * Coefficient
            BigDecimal share = totalAmount.multiply(jar.getCoefficient())
                    .setScale(2, RoundingMode.HALF_UP);
            jar.setBalance(jar.getBalance().add(share));

            // Save the transaction
            Transaction tx = Transaction.builder()
                    .initiator(user)
                    .affectedJar(jar)
                    .amount(share)
                    .type(TransactionType.INCOME_DISTRIBUTION)
                    .correlationId(correlationId)
                    .createdAt(Instant.now())
                    .description("Income Distribution: " + request.description())
                    .build();

            transactionsRepository.save(tx);
        }

        return jarsRepository.saveAll(jars);
    }

    @Transactional
    public Jar deposit(final UUID jarId, final User user, final MoneyOpRequest request) {
        final BigDecimal amount = request.amount();

        if (amount.compareTo(new BigDecimal("0")) < 0) {
            throw new BusinessLogicException("Can't deposit a negative amount");
        }

        Jar jar = jarsRepository.findByIdAndOwnerId(jarId, user.getId()).orElseThrow(
                () -> new ResourceNotFoundException("Jar with invalid ID")
        );

        jar.setBalance(jar.getBalance().add(amount));

        Transaction transaction = Transaction.builder()
                .initiator(user)
                .affectedJar(jar)
                .amount(amount)
                .type(TransactionType.DEPOSIT)
                .description(request.description())
                .createdAt(Instant.now())
                .correlationId(UUID.randomUUID())
                .build();

        transactionsRepository.save(transaction);

        return jarsRepository.save(jar);
    }

    public Jar withdraw(final UUID accId, final User user, final MoneyOpRequest request) {
        final BigDecimal amount = request.amount();

        if (amount.compareTo(new BigDecimal("0")) < 0) {
            throw new BusinessLogicException("Can't withdraw a negative amount");
        }

        Jar jar = jarsRepository.findByIdAndOwnerId(accId, user.getId()).orElseThrow(
                () -> new ResourceNotFoundException("Jar with invalid ID")
        );

        if (jar.getBalance().compareTo(amount) < 0) {
            throw new BusinessLogicException("Not enough balance");
        }

        jar.setBalance(jar.getBalance().subtract(amount));

        Transaction transaction = Transaction.builder()
                .initiator(user)
                .affectedJar(jar)
                .amount(amount)
                .type(TransactionType.WITHDRAWAL)
                .description(request.description())
                .createdAt(Instant.now())
                .correlationId(UUID.randomUUID())
                .build();

        transactionsRepository.save(transaction);

        return jarsRepository.save(jar);
    }
}