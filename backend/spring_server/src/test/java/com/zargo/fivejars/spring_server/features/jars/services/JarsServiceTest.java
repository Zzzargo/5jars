package com.zargo.fivejars.spring_server.features.jars.services;

import com.zargo.fivejars.spring_server.cobol_bridge.CobolEngine;
import com.zargo.fivejars.spring_server.common.exceptions.BusinessLogicException;
import com.zargo.fivejars.spring_server.common.exceptions.ResourceNotFoundException;
import com.zargo.fivejars.spring_server.features.jars.dtos.MoneyOpRequest;
import com.zargo.fivejars.spring_server.features.jars.models.Jar;
import com.zargo.fivejars.spring_server.features.jars.repository.JarsRepository;
import com.zargo.fivejars.spring_server.features.transactions.models.Transaction;
import com.zargo.fivejars.spring_server.features.transactions.repository.TransactionsRepository;
import com.zargo.fivejars.spring_server.features.users.models.User;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Jars Service Test: Business Logic")
public class JarsServiceTest {
    @Mock
    private JarsRepository jarsRepository;
    @Mock
    private TransactionsRepository transactionsRepository;

    private CobolEngine cobolEngine;
    private JarsService jarsService;

    private User testUser;
    private UUID testJarId;
    private Jar testJar;

    @BeforeEach
    void setUp() {
        this.cobolEngine = new CobolEngine("");
        this.jarsService = new JarsService(jarsRepository, transactionsRepository, cobolEngine);

        this.testUser = User.builder().id(UUID.randomUUID()).username("alex").build();
        this.testJarId = UUID.randomUUID();
        this.testJar = Jar.builder()
                .id(testJarId)
                .name("Savings")
                .balance(new BigDecimal("200.00"))
                .coefficient(new BigDecimal("0.50"))
                .owner(testUser)
                .build();
    }

    @Nested
    @DisplayName("Deposit Tests")
    class DepositTests {

        @ParameterizedTest(name = "Deposit should reject negative amount: {0}")
        @ValueSource(strings = {"-0.01", "-1.00", "-500.00"})
        void depositShouldRejectNegativeAmounts(String invalidAmount) {
            MoneyOpRequest request = new MoneyOpRequest(new BigDecimal(invalidAmount), "Test");

            assertThrows(BusinessLogicException.class, () ->
                    jarsService.deposit(testJarId, testUser, request));

            // Verify database was not touched
            verifyNoInteractions(jarsRepository);
            verifyNoInteractions(transactionsRepository);
        }

        @Test
        @DisplayName("Deposit: Jar not found or wrong owner (BOLA) must throw ResourceNotFoundException")
        void depositShouldThrowWhenJarNotFoundOrWrongOwner() {
            UUID wrongJarId = UUID.randomUUID();
            MoneyOpRequest request = new MoneyOpRequest(new BigDecimal("50.00"), "Deposit");

            // Mock repository returning empty (either jar doesn't exist OR belongs to someone else)
            when(jarsRepository.findByIdAndOwnerId(wrongJarId, testUser.getId()))
                    .thenReturn(Optional.empty());

            assertThrows(ResourceNotFoundException.class, () ->
                    jarsService.deposit(wrongJarId, testUser, request));

            // Verify database was not touched
            verify(transactionsRepository, never()).save(any());
            verify(jarsRepository, never()).save(any());
        }
    }

    @Nested
    @DisplayName("Withdraw Operations")
    class WithdrawTests {

        @ParameterizedTest(name = "Withdraw should reject negative amount: {0}")
        @ValueSource(strings = {"-0.01", "-10.00"})
        void withdrawShouldRejectNegativeAmounts(String negativeAmount) {
            MoneyOpRequest request = new MoneyOpRequest(new BigDecimal(negativeAmount), "Invalid");

            assertThrows(BusinessLogicException.class, () ->
                    jarsService.withdraw(testJarId, testUser, request));

            verifyNoInteractions(jarsRepository);
            verifyNoInteractions(transactionsRepository);
        }

        @Test
        @DisplayName("Withdraw: Should reject when balance is insufficient")
        void withdrawShouldRejectInsufficientFunds() {
            // Balance is 200.00, trying to withdraw 200.01
            MoneyOpRequest request = new MoneyOpRequest(new BigDecimal("200.01"), "Overdraft attempt");

            when(jarsRepository.findByIdAndOwnerId(testJarId, testUser.getId()))
                    .thenReturn(Optional.of(testJar));

            BusinessLogicException ex = assertThrows(BusinessLogicException.class, () ->
                    jarsService.withdraw(testJarId, testUser, request));

            assertEquals("Business Logic Exception: Not enough balance", ex.getMessage());
            verify(transactionsRepository, never()).save(any());
        }

        @Test
        @DisplayName("Withdraw: Exact balance withdrawal should succeed and leave 0.00")
        void withdrawExactBalanceShouldLeaveZero() {
            MoneyOpRequest request = new MoneyOpRequest(new BigDecimal("200.00"), "Clear balance");

            when(jarsRepository.findByIdAndOwnerId(testJarId, testUser.getId()))
                    .thenReturn(Optional.of(testJar));
            when(jarsRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            Jar result = jarsService.withdraw(testJarId, testUser, request);

            assertEquals(0, BigDecimal.ZERO.compareTo(result.getBalance()));
            verify(transactionsRepository, times(1)).save(any());
        }
    }

    @Nested
    @DisplayName("Income Distribution Operations")
    class IncomeDistributionTests {

        @Test
        @DisplayName("Distribute: Should fail if jar coefficients do not sum to exactly 1.00")
        void distributeShouldFailIfCoefficientsDoNotSumToOne() {
            // Jar 1: 50%, Jar 2: 40% -> Total = 90% (Missing 10%)
            Jar jar2 = Jar.builder()
                    .id(UUID.randomUUID())
                    .coefficient(new BigDecimal("0.40"))
                    .owner(testUser)
                    .build();

            when(jarsRepository.findAllByOwnerId(testUser.getId())).thenReturn(List.of(testJar, jar2));

            MoneyOpRequest request = new MoneyOpRequest(new BigDecimal("1000.00"), "Paycheck");

            BusinessLogicException ex = assertThrows(BusinessLogicException.class, () ->
                    jarsService.distributeIncome(testUser, request));

            assertTrue(ex.getMessage().contains("exactly 100%"));
            verify(jarsRepository, never()).saveAll(any());
            verifyNoInteractions(transactionsRepository);
        }

        @Test
        @DisplayName("Distribute: All transactions must share the same correlation ID")
        void distributeShouldShareSameCorrelationIdAcrossAllTransactions() {
            // Setup two jars summing to 100% (50% and 50%)
            Jar jar2 = Jar.builder()
                    .id(UUID.randomUUID())
                    .name("Education")
                    .balance(new BigDecimal("100.00"))
                    .coefficient(new BigDecimal("0.50"))
                    .owner(testUser)
                    .build();

            when(jarsRepository.findAllByOwnerId(testUser.getId())).thenReturn(List.of(testJar, jar2));
            when(jarsRepository.saveAll(any())).thenAnswer(inv -> inv.getArgument(0));

            MoneyOpRequest request = new MoneyOpRequest(new BigDecimal("1000.00"), "Bonus");
            jarsService.distributeIncome(testUser, request);

            // Capture all saved transactions
            ArgumentCaptor<Transaction> txCaptor = ArgumentCaptor.forClass(Transaction.class);
            verify(transactionsRepository, times(2)).save(txCaptor.capture());

            List<Transaction> savedTxs = txCaptor.getAllValues();
            UUID correlationId1 = savedTxs.get(0).getCorrelationId();
            UUID correlationId2 = savedTxs.get(1).getCorrelationId();

            assertNotNull(correlationId1);
            assertEquals(correlationId1, correlationId2, "All transactions in a distribution split MUST share the same correlationId");
        }
    }
}
