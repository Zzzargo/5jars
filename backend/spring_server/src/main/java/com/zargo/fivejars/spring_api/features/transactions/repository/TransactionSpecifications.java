package com.zargo.fivejars.spring_api.features.transactions.repository;

import com.zargo.fivejars.spring_api.features.transactions.models.Transaction;
import com.zargo.fivejars.spring_api.features.transactions.models.TransactionType;
import org.springframework.data.jpa.domain.Specification;

import java.util.UUID;

// All those are just optional filters for querying transactions
public class TransactionSpecifications {
    public static Specification<Transaction> hasInitiatorId(final UUID userId) {
        return (root, query, cb)
                -> cb.equal(root.get("initiator").get("id"), userId);
    }

    public static Specification<Transaction> hasJarId(final UUID jarId) {
        return (root, query, cb)
                -> cb.equal(root.get("affectedJar").get("id"), jarId);
    }

    public static Specification<Transaction> hasType(final TransactionType type) {
        return (root, query, cb)
                -> cb.equal(root.get("type"), type);
    }
}
