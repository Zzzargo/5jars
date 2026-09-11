package com.zargo.fivejars.spring_server.cobol_bridge;

import org.junit.jupiter.api.*;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@DisplayName("COBOL Math Engine Tests")
public class CobolEngineTest {
    private CobolEngine engine;
    @BeforeAll
    public void setup() {
        this.engine = new CobolEngine();
    }

    @AfterAll
    public void tearDown() {
        engine.stop();
    }

    @Test
    @DisplayName("Should instantiate the engine and shut it off without problems")
    void shouldTurnOnOffWithoutErrors() {
        System.err.println("HI IN RED! IF THERE IS NO OTHER RED TEXT YOU'RE ONE LUCKY BASTARD!");
    }

    @Test
    @DisplayName("Should get the string \"Hi from COBOL!\" from COBOL")
    void shouldGetAStringFromCobol() {
        var string = engine.checkString();
        assertEquals("Hi from COBOL!", string);
    }

    @ParameterizedTest(name = "[{index}] {0} + {1} = {2}")
    @CsvSource({
            "591.19,                8.81,                600.00",
            "1.01,                  2.2,                3.21",
            "0.00,                  0.00,                0.00",
            "150.50,                0.00,                150.50",
            "-5.21,                 2.21,               -3.00",
            "-100.00,             100.00,                0.00",

            // Sub-cent rounding (Half-Up to 2 decimal places)
            "2.014,                 2.986,               5.00",
            "0.005,                 0.000,               0.01",

            // Large financial numbers within S9(13)V99 (13 digits integer, 2 decimals)
            "-1520382765446.207,   2298204982546.777,   777822217100.57",
            "9999999999999.98,      0.01,                9999999999999.99"
    })
    @DisplayName("Check deposit (basic addition) integrity")
    void verifyDepositCalculations(String balance, String amount, String expected) {
        BigDecimal currBalance = new BigDecimal(balance);
        BigDecimal amountToDeposit = new BigDecimal(amount);
        BigDecimal expectedResult = new BigDecimal(expected);

        BigDecimal actualResult = engine.deposit(currBalance, amountToDeposit);

        assertEquals(0, expectedResult.compareTo(actualResult),
                () -> String.format("Expected %s but received %s for inputs (%s + %s)",
                        expectedResult, actualResult, balance, amount));

        assertEquals(2, actualResult.scale(), "Result scale must strictly equal 2 decimal places");
    }

    @Test
    @DisplayName("Should reject null arguments before allocating native off-heap memory")
    void shouldThrowOnNullInput() {
        assertThrows(NullPointerException.class, () -> engine.deposit(null, BigDecimal.TEN));
        assertThrows(NullPointerException.class, () -> engine.deposit(BigDecimal.TEN, null));
    }
}
