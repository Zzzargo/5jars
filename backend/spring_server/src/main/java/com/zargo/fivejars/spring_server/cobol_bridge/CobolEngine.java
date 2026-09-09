package com.zargo.fivejars.spring_server.cobol_bridge;

import com.zargo.fivejars.spring_server.common.exceptions.CobolExecutionException;
import org.springframework.stereotype.Component;

import java.lang.foreign.*;
import java.lang.invoke.MethodHandle;
import java.math.BigDecimal;
import java.nio.file.Path;

@Component
public class CobolEngine {
    // All COBOL PICs used for money are S9(13)V99 =>
    //      15 digits + 1 sign = 16 / 2 = 8 bytes for a number in COMP-3 format
    private static final int COMP3_NUMS_DIGITS = 15;
    private static final int COMP3_NUMS_DECIMALS = 2;
    private static final int COMP3_NUMS_BYTELEN = (COMP3_NUMS_DIGITS + 1) / 2;

    private final MethodHandle depositHandle;
    private final MethodHandle testStringHandle;

    public CobolEngine() {
        final SymbolLookup lookup = SymbolLookup.loaderLookup();
        final Linker linker = Linker.nativeLinker();

        // Load the cobol runtime library and initialize the runtime
        System.loadLibrary("cob");
        // TODO: get rid of this error <attempt to reference invalid memory address (signal)> by getting cob_init type
        //  void cob_init(int argc, char **argv) ?
        final MemorySegment initMemorySegment = lookup.find("cob_init").orElseThrow(RuntimeException::new);
        final FunctionDescriptor initDescriptor = FunctionDescriptor.ofVoid(ValueLayout.JAVA_INT, ValueLayout.ADDRESS);
        final MethodHandle cobInitHandle = linker.downcallHandle(initMemorySegment, initDescriptor);
        try {
            cobInitHandle.invokeExact(0, MemorySegment.NULL);
        } catch (Throwable e) {
            System.out.println("Error calling \"cob_init\": " + e.getMessage());
        }

        // Load the shared library
        // TODO: get the library from the COBOL root directory
        System.load(Path.of("libfivejars_cobol_kernel.so").toAbsolutePath().toString());

        this.depositHandle = linker.downcallHandle(
                lookup.find("DEPOSIT").orElseThrow(),
                FunctionDescriptor.ofVoid(ValueLayout.ADDRESS, ValueLayout.ADDRESS, ValueLayout.ADDRESS)
        );

        this.testStringHandle = linker.downcallHandle(
                lookup.find("COBOL__TEST").orElseThrow(),
                FunctionDescriptor.ofVoid((ValueLayout.ADDRESS))
        );
    }

    public BigDecimal deposit(final BigDecimal balance, final BigDecimal amount) {
        try (Arena arena = Arena.ofConfined()) {
            MemorySegment balanceSeg = arena.allocateFrom(
                    ValueLayout.JAVA_BYTE, CobolConverter.decimalToComp3(
                            balance, COMP3_NUMS_DIGITS, COMP3_NUMS_DECIMALS
                    )
            );
            MemorySegment amountSeg = arena.allocateFrom(
                    ValueLayout.JAVA_BYTE, CobolConverter.decimalToComp3(
                            amount, COMP3_NUMS_DIGITS, COMP3_NUMS_DECIMALS
                    )
            );
            MemorySegment resultSeg = arena.allocate(COMP3_NUMS_BYTELEN);

            depositHandle.invokeExact(balanceSeg, amountSeg, resultSeg);

            return CobolConverter.comp3ToDecimal(resultSeg.toArray(ValueLayout.JAVA_BYTE), COMP3_NUMS_DECIMALS);
        } catch (Throwable e) {
            throw new CobolExecutionException(e.getMessage());
        }
    }

    public String checkString() {
        try (Arena arena = Arena.ofConfined()) {
            // A non null-terminated string of max 20 alphanumerics
            MemorySegment resultSeg = arena.allocateFrom(ValueLayout.JAVA_BYTE, new byte[20]);
            testStringHandle.invokeExact(resultSeg);
            var cStyleString = resultSeg.toArray(ValueLayout.JAVA_BYTE);
            return new String(cStyleString).trim();
        } catch (Throwable e) {
            throw new CobolExecutionException(e.getMessage());
        }
    }
}
