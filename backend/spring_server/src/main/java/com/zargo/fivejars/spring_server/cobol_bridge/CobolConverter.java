package com.zargo.fivejars.spring_server.cobol_bridge;

import org.jspecify.annotations.NonNull;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.RoundingMode;

public class CobolConverter {
    /**
     * Converts BigDecimal to COMP-3 byte array.
     * @param value The value to convert
     * @param totalDigits Total digits in the COBOL PIC (e.g., 13 for S9(11)V99)
     * @param decimalPlaces number of digits after the decimal point
     */
    public static byte @NonNull [] decimalToComp3(
            final @NonNull BigDecimal value, final int totalDigits, final int decimalPlaces
    ) {
        // Unscale and get the raw digits
        StringBuilder digitsStringBuilder = new StringBuilder();
        BigInteger unscaledValue = value.setScale(decimalPlaces, RoundingMode.HALF_UP).unscaledValue().abs();
        digitsStringBuilder.append(unscaledValue);

        // Before adding the sign check whether the number of digits is even. If yes, pad the digits with a 0 so that
        // the nibbles with the digits + sign nibble are in an even number
        if (digitsStringBuilder.length() % 2 == 0) {
            digitsStringBuilder = new StringBuilder("0").append(digitsStringBuilder);
        }

        // Add the sign (D for signed negative, C for signed positive)
        digitsStringBuilder.append(value.signum() < 0 ? "D" : "C");

        // Calculate number of bytes needed to store the number in COMP-3 with the specified total digits:
        // roundUp((digits + 1 sign nibble) / 2)
        int numBytes = totalDigits / 2 + 1;

        // The rest of the bytes are filled with zeros
        int numZeros = numBytes * 2 - digitsStringBuilder.length();
        digitsStringBuilder = new StringBuilder().repeat("0", numZeros).append(digitsStringBuilder);

        byte[] comp3 = new byte[numBytes];

        for (int i = 0; i < numBytes; i++) {
            // Get the high and low nibbles from the digits string, in hex base
            int highNibble = Character.digit(digitsStringBuilder.charAt(i * 2), 16);
            int lowNibble = Character.digit(digitsStringBuilder.charAt(i * 2 + 1), 16);

            // Store them in the same byte in the packed decimal byte array
            comp3[i] = (byte) ((highNibble << 4) | lowNibble);
        }

        return comp3;
    }

    /**
     * Converts COMP-3 byte array back to BigDecimal.
     * @param bcd the COMP-3 byte array
     * @param decimals number of decimal places in the COMP-3 decimal
     */
    public static BigDecimal comp3ToDecimal(final byte[] bcd, final int decimals) {
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < bcd.length; i++) {
            // Get high nibble
            sb.append((bcd[i] >> 4) & 0x0F);

            // Get low nibble (unless it's the last byte, where is the sign nibble)
            if (i < bcd.length - 1) {
                sb.append(bcd[i] & 0x0F);
            } else {
                // Sign nibble
                int signNibble = bcd[i] & 0x0F;
                boolean negative = signNibble == 0x0D;

                BigDecimal val = new BigDecimal(sb.toString()).movePointLeft(decimals);
                return negative ? val.negate() : val;
            }
        }
        return BigDecimal.ZERO;
    }
}
