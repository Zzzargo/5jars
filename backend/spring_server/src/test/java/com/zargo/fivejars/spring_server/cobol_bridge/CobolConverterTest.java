package com.zargo.fivejars.spring_server.cobol_bridge;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

class CobolConverterTest {

    @Test
    @DisplayName("Converting an even digit decimal to COMP-3")
    void testDecimalToComp3Even() {
        BigDecimal val = new BigDecimal("150.50");
        // PIC S9(12)V999 -> 15 digits total, 3 decimals
        byte[] result = CobolConverter.decimalToComp3(val, 15, 3);

        // (15 + 1 sign nibble) / 2 = 8 bytes required for this number
        assertEquals(8, result.length);
        // Expected: 00 00 00 00 01 50 50 0C
        assertEquals(0x01, result[4] & 0xFF);
        assertEquals(0x50, result[5] & 0xFF);
        assertEquals(0x50, result[6] & 0xFF);
        assertEquals(0x0C, result[7] & 0xFF);
    }

    @Test
    @DisplayName("Converting a signed odd digit decimal to COMP-3")
    void testDecimalToComp3Odd() {
        BigDecimal val = new BigDecimal("-2150.50");
        byte[] result = CobolConverter.decimalToComp3(val, 15, 3);

        assertEquals(8, result.length);
        // Expected: 00 00 00 00 21 50 50 0D
        assertEquals(0x21, result[4] & 0xFF);
        assertEquals(0x50, result[5] & 0xFF);
        assertEquals(0x50, result[6] & 0xFF);
        assertEquals(0x0D, result[7] & 0xFF);
    }

    @Test
    @DisplayName("Converting a very big decimal to COMP-3")
    void testDecimalToComp3Large() {
        BigDecimal val = new BigDecimal("99274331951.331");
        byte[] result = CobolConverter.decimalToComp3(val, 15, 3);

        assertEquals(8, result.length);
        // Expected: 09 92 74 33 19 51 33 1C
        assertEquals(0x09, result[0] & 0xFF);
        assertEquals(0x92, result[1] & 0xFF);
        assertEquals(0x74, result[2] & 0xFF);
        assertEquals(0x33, result[3] & 0xFF);
        assertEquals(0x19, result[4] & 0xFF);
        assertEquals(0x51, result[5] & 0xFF);
        assertEquals(0x33, result[6] & 0xFF);
        assertEquals(0x1C, result[7] & 0xFF);
    }

    @Test
    @DisplayName("Converting a large signed COMP-3 decimal to a BigDecimal")
    void testComp3ToDecimalLarge() {
        byte [] comp3 = new byte[]{(byte) 0x84, (byte) 0x99, 0x74, 0x33, 0x19, 0x51, 0x33, 0x1D};
        // PIC S9(12)V999 -> 15 digits total, 3 decimals
        BigDecimal result = CobolConverter.comp3ToDecimal(comp3, 3);

        BigDecimal expected = new BigDecimal("-849974331951.331");

        assertEquals(result, expected);
    }

    @Test
    @DisplayName("Converting zero in COMP-3 decimal representation to a BigDecimal")
    void testComp3ToDecimalZero() {
        byte [] comp3 = new byte[8];
        BigDecimal result = CobolConverter.comp3ToDecimal(comp3, 3);

        BigDecimal expected = new BigDecimal("0.000");

        assertEquals(result, expected);
    }

    @ParameterizedTest
    @CsvSource({
            "591.19, 13, 2",
            "-10.00, 4, 2",
            "0.00, 13, 2",
            "999999999.99, 13, 2"
    })
    @DisplayName("Round-trip conversion should maintain value")
    void testRoundTrip(final String input, final int totalDigits, final int decimals) {
        BigDecimal decimal = new BigDecimal(input);
        byte[] comp3 = CobolConverter.decimalToComp3(decimal, totalDigits, decimals);
        BigDecimal unpacked = CobolConverter.comp3ToDecimal(comp3, decimals);

        assertEquals(0, decimal.compareTo(unpacked),
                "Failed round trip for " + input);
    }

    @Test
    @DisplayName("Should handle negative numbers and convert correctly to negative Decimals")
    void testNegativeSign() {
        BigDecimal neg = new BigDecimal("-1.23");
        byte[] packed = CobolConverter.decimalToComp3(neg, 3, 2);

        // Expected: (3 digits + 1 sign) / 2 = 2 bytes
        // Value: 12 3D
        assertEquals(2, packed.length);
        assertEquals(packed[0] & 0xFF, 0x12);
        assertEquals(packed[1] & 0xFF, 0x3D);
        assertTrue(CobolConverter.comp3ToDecimal(packed, 2).signum() < 0);
    }
}
