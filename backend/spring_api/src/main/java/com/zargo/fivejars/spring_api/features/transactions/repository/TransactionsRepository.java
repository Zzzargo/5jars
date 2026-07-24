package com.zargo.fivejars.spring_api.features.transactions.repository;

import com.zargo.fivejars.spring_api.features.transactions.models.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface TransactionsRepository extends JpaRepository<Transaction, UUID> {
    List<Transaction> findAllByInitiatorIdOrderByCreatedAtDesc(UUID initiatorId);
    List<Transaction> findAllByAffectedJarIdAndInitiatorIdOrderByCreatedAtDesc(UUID affectedJarId, UUID initiatorId);
}
