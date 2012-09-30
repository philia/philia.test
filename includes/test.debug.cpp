#include "debug.h"

int main(int argc, char* argv[]) {
    PDDBG("debug test without format");
    PDDBG("%d, %s", 999, "test with format string and carriage return \n\n inside");
    return 0;
}
