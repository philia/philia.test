#include <stdio.h>

#define PDDBG(fmt, arg...) { printf("PD: %s:%s:%d: ", __FILE__, __FUNCTION__, __LINE__); printf(fmt, ##arg); printf("\n"); }
