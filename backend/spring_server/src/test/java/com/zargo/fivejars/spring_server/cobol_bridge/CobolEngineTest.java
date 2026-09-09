package com.zargo.fivejars.spring_server.cobol_bridge;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

public class CobolEngineTest {
    private CobolEngine engine;
    @BeforeEach
    public void setup() {
        this.engine = new CobolEngine();
    }

    @Test
    @DisplayName("591.19 + 8.81 should be equal to 600.00")
    void simpleAdditionShouldEqual600() {
        BigDecimal currBalance = new BigDecimal("591.19");
        BigDecimal amountToDeposit = new BigDecimal("8.81");

        BigDecimal res = engine.deposit(currBalance, amountToDeposit);

        assertEquals(0, new BigDecimal("600.00").compareTo(res));
    }

    @Test
    @DisplayName("1.01 + 2.2 should be equal to 3.21")
    void shouldHandleDecimalsCorrectly() {
        BigDecimal currBalance = new BigDecimal("1.01");
        BigDecimal amountToDeposit = new BigDecimal("2.2");

        BigDecimal res = engine.deposit(currBalance, amountToDeposit);

        assertEquals(0, new BigDecimal("3.21").compareTo(res));
    }

    @Test
    @DisplayName("2.014 + 2.986 should be equal to 5.00")
    void shouldRoundFinerDecimalsCorrectly() {
        BigDecimal currBalance = new BigDecimal("2.014");
        BigDecimal amountToDeposit = new BigDecimal("2.986");

        BigDecimal res = engine.deposit(currBalance, amountToDeposit);

        assertEquals(0, new BigDecimal("5.00").compareTo(res));
    }

    @Test
    @DisplayName("-5.21 + 2.21 should be equal to -3.00")
    void shouldAddNegativeNumbersCorrectly() {
        BigDecimal currBalance = new BigDecimal("-5.21");
        BigDecimal amountToDeposit = new BigDecimal("2.21");

        BigDecimal res = engine.deposit(currBalance, amountToDeposit);

        assertEquals(0, new BigDecimal("-3.00").compareTo(res));
    }

    @Test
    @DisplayName("-1520382765446.207 + 2298204982546.777 should be equal to 777822217100.570")
    void testLargeSignRoundingDecimalExcess() {
        BigDecimal currBalance = new BigDecimal("-1520382765446.207");
        BigDecimal amountToDeposit = new BigDecimal("2298204982546.777");

        BigDecimal res = engine.deposit(currBalance, amountToDeposit);

        assertEquals(0, new BigDecimal("777822217100.570").compareTo(res));
    }

    @Test
    @DisplayName("Should get the string \"Hi from COBOL!\" from COBOL")
    void shouldGetAStringFromCobol() {
        var string = engine.checkString();
        assertEquals("Hi from COBOL!", string);
    }
}
