package com.zargo.fivejars.spring_api.features.transactions.services;

import com.zargo.fivejars.spring_api.features.transactions.models.Transaction;
import com.zargo.fivejars.spring_api.features.transactions.dtos.TransactionResponse;
import com.zargo.fivejars.spring_api.features.transactions.repository.TransactionsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class TransactionsService {
    private final TransactionsRepository transactionRepository;

    public List<TransactionResponse> getGlobalHistory(final UUID userId, final Pageable pageable) {
        return transactionRepository.findAllByInitiatorIdOrderByCreatedAtDesc(userId, pageable)
                .getContent()
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    public List<TransactionResponse> getJarHistory(final UUID userId, final UUID jarId, final Pageable pageable) {
        return transactionRepository.findAllByAffectedJarIdAndInitiatorIdOrderByCreatedAtDesc(jarId, userId, pageable)
                .getContent()
                .stream()
                .map(this::mapToResponse)
                .toList();
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
