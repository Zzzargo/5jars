package com.zargo.fivejars.spring_api.features.transactions.services;

import com.zargo.fivejars.spring_api.features.transactions.models.Transaction;
import com.zargo.fivejars.spring_api.features.transactions.dtos.TransactionResponse;
import com.zargo.fivejars.spring_api.features.transactions.models.TransactionType;
import com.zargo.fivejars.spring_api.features.transactions.repository.TransactionSpecifications;
import com.zargo.fivejars.spring_api.features.transactions.repository.TransactionsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class TransactionsService {
    private final TransactionsRepository transactionRepository;

    public Slice<TransactionResponse> getTransactions(
            final UUID userId,
            final UUID jarId,
            final TransactionType type,
            final Pageable pageable
    ) {
        // A user should only ever see their own transactions
        Specification<Transaction> spec = Specification.where(TransactionSpecifications.hasInitiatorId(userId));

        // Add optional filters
        if (jarId != null) {
            spec = spec.and(TransactionSpecifications.hasJarId(jarId));
        }
        if (type != null) {
            spec = spec.and(TransactionSpecifications.hasType(type));
        }

        return transactionRepository.findAll(spec, pageable)
                .map(this::mapToResponse);
    }

    private TransactionResponse mapToResponse(final Transaction tx) {
        return new TransactionResponse(
                tx.getId(),
                tx.getAffectedJar().getId(),
                tx.getAffectedJar().getName(),
                tx.getAmount(),
                tx.getType(),
                tx.getDescription(),
                tx.getCorrelationId(),
                tx.getCreatedAt()
        );
    }
}
