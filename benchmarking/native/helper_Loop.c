#include "helper_Loop.h"
#include <time.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

void nativeSieve(int num){

    bool *isPrime = (bool *)malloc((num + 1) * sizeof(bool));
    if (isPrime == NULL) {
        printf("Memory allocation failed\n");
        return;
    }

    for (int i = 0; i <= num; i++)
        isPrime[i] = true;

    isPrime[0] = isPrime[1] = false;

    clock_t start_clock = clock();
    for (int p = 2; p * p <= num; p++) {
        if (isPrime[p]) {
            for (int i = p * p; i <= num; i += p)
                isPrime[i] = false;
        }
    }
    clock_t end_clock = clock();
    printf("C Sieve function time: %.f ms\n", ((double)(end_clock - start_clock) * 1000.0 / CLOCKS_PER_SEC));
    
    int count = 0;

    for (int i = 2; i <= num; i++) {
        if (isPrime[i])
            count++;
    }

    free(isPrime);
    printf("There are %d prime numbers up to %d.\n", count, num);
}