#include "debug.h"

int main(int argc, char* argv[]) {
    PDDBG("debug test");
    PDDBG("%d, %s\n", 999, "test with format string and carriage return\n\ninside\n");
    return 0;
}
