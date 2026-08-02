package com.zargo.fivejars.spring_api.features.transactions.repository;

import com.zargo.fivejars.spring_api.features.transactions.models.Transaction;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface TransactionsRepository extends JpaRepository<Transaction, UUID> {
    Slice<Transaction> findAllByInitiatorIdOrderByCreatedAtDesc(UUID initiatorId, Pageable pageable);
    Slice<Transaction> findAllByAffectedJarIdAndInitiatorIdOrderByCreatedAtDesc(
            UUID affectedJarId, UUID initiatorId, Pageable pageable
    );
}
