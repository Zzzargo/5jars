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
    @DisplayName("Should get the string \"Hi from COBOL!\" from COBOL")
    void shouldGetAStringFromCobol() {
        var string = engine.checkString();
        assertNotNull(string, "string should not be null");
        System.out.println(string);
    }
}
