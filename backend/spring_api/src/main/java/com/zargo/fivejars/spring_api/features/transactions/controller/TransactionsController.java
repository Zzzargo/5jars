package com.zargo.fivejars.spring_api.features.transactions.controller;

import com.zargo.fivejars.spring_api.features.transactions.dtos.TransactionResponse;
import com.zargo.fivejars.spring_api.features.transactions.models.TransactionType;
import com.zargo.fivejars.spring_api.features.transactions.services.TransactionsService;
import com.zargo.fivejars.spring_api.features.users.models.User;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/transactions")
@RequiredArgsConstructor
public class TransactionsController {
    private final TransactionsService transactionService;

    @GetMapping
    public ResponseEntity<List<TransactionResponse>> getTransactions(
            @AuthenticationPrincipal User user,
            @RequestParam(required = false) UUID jarId,
            @RequestParam(required = false) TransactionType type,
            // Default: 20 items per page, sorted by newest first
            @PageableDefault(size = 20, sort = "createdAt", direction = Sort.Direction.DESC) Pageable pageable
    ) {
        final Slice<TransactionResponse> slice = transactionService.getTransactions(
                user.getId(), jarId, type, pageable
        );

        // Add a custom header to tell the frontend if there's more data
        return ResponseEntity.ok()
                .header("X-Has-Next", String.valueOf(slice.hasNext()))
                .body(slice.getContent());
    }
}
