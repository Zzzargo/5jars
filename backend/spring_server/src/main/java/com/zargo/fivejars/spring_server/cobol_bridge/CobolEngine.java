package com.zargo.fivejars.spring_server.cobol_bridge;

import org.springframework.stereotype.Component;

import java.lang.foreign.*;
import java.lang.invoke.MethodHandle;
import java.math.BigDecimal;
import java.nio.file.Path;

@Component
public class CobolEngine {
    private final MethodHandle depositHandle;
    private final MethodHandle testStringHandle;

    public CobolEngine() {
        // Load the shared library
        System.load(Path.of("libfivejars_cobol_kernel.so").toAbsolutePath().toString());
        SymbolLookup lookup = SymbolLookup.loaderLookup();
        Linker linker = Linker.nativeLinker();

        FunctionDescriptor initDescriptor = FunctionDescriptor.ofVoid();
        MethodHandle cobInitHandle = linker.downcallHandle(lookup.find("cob_init").orElseThrow(), initDescriptor);

        try {
            cobInitHandle.invokeExact();
        } catch (Throwable ex) {
            System.out.println("Da ya sho ebanulsya");
        }

        this.depositHandle = linker.downcallHandle(
                lookup.find("DEPOSIT").orElseThrow(),
                FunctionDescriptor.ofVoid(ValueLayout.ADDRESS, ValueLayout.ADDRESS, ValueLayout.ADDRESS)
        );

        this.testStringHandle = linker.downcallHandle(
                lookup.find("COBOL__TEST").orElseThrow(),
                FunctionDescriptor.ofVoid((ValueLayout.ADDRESS))
        );
    }

    // Generic execution wrapper
    public void call(String programId, Object... args) {
    }

    public BigDecimal deposit(final BigDecimal balance, final BigDecimal amount) {
        try (Arena arena = Arena.ofConfined()) {
            MemorySegment balanceSeg = arena.allocateFrom(
                    ValueLayout.JAVA_BYTE, CobolConverter.decimalToComp3(balance, 15, 3)
            );
            MemorySegment amountSeg = arena.allocateFrom(
                    ValueLayout.JAVA_BYTE, CobolConverter.decimalToComp3(amount, 15, 3)
            );
            MemorySegment resultSeg = arena.allocate(8);

            depositHandle.invokeExact(balanceSeg, amountSeg, resultSeg);

            return CobolConverter.comp3ToDecimal(resultSeg.toArray(ValueLayout.JAVA_BYTE), 3);
        } catch (Throwable e) {
            throw new RuntimeException("COBOL Execution Failed", e);
        }
    }

    public String checkString() {
        try (Arena arena = Arena.ofConfined()) {
            // A non null-terminated string of max 20 alphanumerics
            MemorySegment resultSeg = arena.allocate(20);
            testStringHandle.invoke(resultSeg);
            var cStyleString = resultSeg.toArray(ValueLayout.JAVA_BYTE);
            return new String(cStyleString).trim();
        } catch (Throwable e) {
            throw new RuntimeException("COBOL Execution Failed", e);
        }
    }
}
