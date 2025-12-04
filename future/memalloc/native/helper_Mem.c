#include "helper_Mem.h"
#include <time.h>
#include <stdio.h>

void navtiveMemoryAllocator(int num){
    clock_t start_clock = clock();
    // TODO: logic
    clock_t end_clock = clock();
    printf("C function time: %.f ms\n", ((double)(end_clock - start_clock) * 1000.0 / CLOCKS_PER_SEC));
}