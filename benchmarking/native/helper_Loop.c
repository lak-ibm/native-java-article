#include "helper_Loop.h"
#include <time.h>
#include <stdio.h>

// static volatile int count;

void navtiveLoopCounterHelper(int num){
    volatile int count = 0;
    clock_t start_clock = clock();
    for(int i=0; i<num; i++){
        count++;
    }
    clock_t end_clock = clock();
    printf("C function time: %.f ms\n", ((double)(end_clock - start_clock) * 1000.0 / CLOCKS_PER_SEC));
}