#include <stdio.h>
#include <stdlib.h>

// Exposed to COBOL
void testPrintDouble(char *numStr) {
    double num = atof(numStr);
    printf("%.2f", num);
}