package com.zargo.fivejars.spring_server.features.transactions.repository;

import com.zargo.fivejars.spring_server.features.transactions.models.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.UUID;

public interface TransactionsRepository extends
        JpaRepository<Transaction, UUID>, JpaSpecificationExecutor<Transaction>
{ }
