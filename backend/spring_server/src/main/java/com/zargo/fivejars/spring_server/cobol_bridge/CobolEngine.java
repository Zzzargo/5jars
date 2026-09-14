package com.zargo.fivejars.spring_server.cobol_bridge;

import com.zargo.fivejars.spring_server.common.exceptions.CobolExecutionException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.SmartLifecycle;
import org.springframework.stereotype.Component;

import java.lang.foreign.*;
import java.lang.invoke.MethodHandle;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.NoSuchElementException;

@Component
@Slf4j
public class CobolEngine implements SmartLifecycle {
    // All COBOL PICs used for money are S9(13)V99 =>
    //      15 digits + 1 sign = 16 / 2 = 8 bytes for a number in COMP-3 format
    private static final int COMP3_NUMS_DIGITS = 15;
    private static final int COMP3_NUMS_DECIMALS = 2;
    private static final int COMP3_NUMS_BYTELEN = (COMP3_NUMS_DIGITS + 1) / 2;

    private final MethodHandle testStringHandle;
    private final MethodHandle depositHandle;

    // -----------------------------------------------------------------------------------------------------------------
    // Lifecycle: because the COBOL engine calls cob_stop_run() which can ultimately stop the JVM
    // Gotta make sure the engine is deconstructed dead last
    private boolean isRunning = false;
    private final MethodHandle cleanupHandle;

    public CobolEngine(@Value("${app.cobol.kernel-path}") String cobolKernelPath) {
        final Linker linker = Linker.nativeLinker();

        this.loadLibraries(cobolKernelPath);

        // A loader lookup works only with the libraries that were loaded prior to the lookup's creation
        final SymbolLookup loadedLibrariesLookup = SymbolLookup.loaderLookup();

        // Initialize the COBOL runtime. void cob_init(const int, char **)
        final MemorySegment initMemorySegment = loadedLibrariesLookup.find("cob_init").orElseThrow();
        final FunctionDescriptor initDescriptor = FunctionDescriptor.ofVoid(ValueLayout.JAVA_INT, ValueLayout.ADDRESS);
        final MethodHandle initHandle = linker.downcallHandle(initMemorySegment, initDescriptor);
        try {
            initHandle.invokeExact(0, MemorySegment.NULL);
        } catch (Throwable e) {
            log.error("Error calling \"cob_init\": {}", e.getMessage());
            throw new NoSuchElementException("cob_init not found");
        }

        // To successfully destroy the CobolEngine instance the launched COBOL runtime needs to be cleaned up
        // void cob_stop_run(int ret_code) exits the program
        // int cob_tidy() only deallocates resources set up by the runtime
        // Don't know why but cob_tidy just keeps throwing segfaults at me while cob_stop_run is kind, so I choose that
        final MemorySegment cleanupMemorySegment = loadedLibrariesLookup.find("cob_stop_run").orElseThrow();
        final FunctionDescriptor cleanupDescriptor = FunctionDescriptor.ofVoid(ValueLayout.JAVA_INT);
        this.cleanupHandle = linker.downcallHandle(cleanupMemorySegment, cleanupDescriptor);

        this.depositHandle = linker.downcallHandle(
                loadedLibrariesLookup.find("DEPOSIT").orElseThrow(),
                FunctionDescriptor.ofVoid(ValueLayout.ADDRESS, ValueLayout.ADDRESS, ValueLayout.ADDRESS)
        );

        this.testStringHandle = linker.downcallHandle(
                loadedLibrariesLookup.find("COBOL__TEST").orElseThrow(),
                FunctionDescriptor.ofVoid((ValueLayout.ADDRESS))
        );
    }

    private void loadLibraries(final String cobolKernelPath) {
        // Load the cobol runtime library. The loadLibrary method searches in common system library paths
        System.loadLibrary("cob");

        // Load the custom shared library
        if (cobolKernelPath == null || cobolKernelPath.isBlank()) {
            log.warn("COBOL kernel path was not injected via app config. Searching for env var...");
            String kernelLibPathEnv = System.getenv("COBOL_KERNEL_PATH");

            if (kernelLibPathEnv != null && !kernelLibPathEnv.isBlank()) {
                Path p = Path.of(kernelLibPathEnv);
                if (Files.exists(p)) {
                    System.load(p.toAbsolutePath().toString());
                    log.info("COBOL kernel library loaded from env var path: {}", p.toAbsolutePath());
                } else {
                    throw new RuntimeException("COBOL kernel library at " + p.toAbsolutePath() + "doesn't exist");
                }
            } else {
                throw new NullPointerException("COBOL kernel path not found neither in env vars");
            }
        } else {
            Path p = Path.of(cobolKernelPath).toAbsolutePath();
            System.load(p.toString());
            log.info("COBOL kernel library loaded from app property path: {}", p);
        }
    }

    @Override
    public void start() {
        this.isRunning = true;
    }

    @Override
    public void stop() {
        if (this.isRunning) {
            this.isRunning = false;
            try {
                this.cleanupHandle.invokeExact(0);
            } catch (Throwable e) {
                // Could ignore that but it can be useful
                System.out.println("Error calling \"cob_stop_run\": " + e.getMessage());
            }
        }
    }

    @Override
    public boolean isRunning() {
        return this.isRunning;
    }

    @Override
    public int getPhase() {
        // Integer.MIN_VALUE ensures this bean is stopped LAST during context shutdown
        return Integer.MIN_VALUE;
    }

    // -----------------------------------------------------------------------------------------------------------------

    public BigDecimal deposit(final BigDecimal balance, final BigDecimal amount) throws RuntimeException {
        if (balance == null || amount == null) {
            throw new NullPointerException("Balance or amount is null");
        }
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
