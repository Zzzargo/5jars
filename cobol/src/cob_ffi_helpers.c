#include <stddef.h>
#include <stdlib.h>
#include <libcob.h>

void ffi_test(char *buffer);

void cobol_init() {
    cob_init(0, NULL);
}

void cobol_destroy() {
    cob_tidy();
}

void ffi_test_c(char *buffer) {
    ffi_test(buffer);
}