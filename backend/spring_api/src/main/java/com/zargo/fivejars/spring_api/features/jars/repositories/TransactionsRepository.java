package com.zargo.fivejars.spring_api.features.jars.repositories;

import com.zargo.fivejars.spring_api.features.jars.models.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface TransactionsRepository extends JpaRepository<Transaction, UUID> {

}
