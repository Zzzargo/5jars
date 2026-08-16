package com.zargo.fivejars.spring_api.features.transactions.controller;

import com.zargo.fivejars.spring_api.features.transactions.dtos.TransactionResponse;
import com.zargo.fivejars.spring_api.features.transactions.services.TransactionsService;
import com.zargo.fivejars.spring_api.features.users.models.User;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
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
    public List<TransactionResponse> getHistory(
            @AuthenticationPrincipal User user,
            @RequestParam(required = false) UUID jarId,
            @PageableDefault(size = 20) Pageable pageable
    ) {
        if (jarId != null) {
            // For queries get only the requested jar's history
            return transactionService.getJarHistory(user.getId(), jarId, pageable);
        }

        return transactionService.getGlobalHistory(user.getId(), pageable);
    }
}
