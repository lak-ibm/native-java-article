#include <jni.h>
#include <stdio.h>
#include <time.h>
#include "benchmarking_Loop.h"
#include "helper_Loop.h"

JNIEXPORT void JNICALL Java_benchmarking_Loop_c_1counter(JNIEnv *env, jobject obj, jint num) {
    printf("JNI ");
    navtiveLoopCounterHelper(num);
};

JNIEXPORT void JNICALL Java_benchmarking_Loop_asm_1counter(JNIEnv *env, jobject obj, jint num) {
    volatile int count = 0;
    volatile int dummy = 0; 
    clock_t start = clock();
    __asm__ volatile (
        "xor %%eax, %%eax\n"        // eax = 0
        "1:\n\t"
        "cmp %[num], %%eax\n\t"     // compare i to num
        "jge 2f\n\t"                // if i >= num, jump to end
        "add $1, %%eax\n\t"         // i++
        "mov %%eax, %[d]\n\t"       // store to dummy (volatile write)
        "jmp 1b\n"                  // loop
        "2:\n\t"
        : [d] "=m" (dummy)          // output: write to dummy to prevent optimization
        : [num] "r" (num)           // input: num
        : "%eax"                    // clobbered register
    );

    clock_t end = clock();
    printf("JNI ASM function time: %.f ms\n", ((double)(end - start) * 1000.0 / CLOCKS_PER_SEC));
};

/**************** maybe for future use ****************/

JNIEXPORT jint JNICALL Java_benchmarking_Loop_CSort(JNIEnv *env, jobject obj, jint target) {
    printf(" - Inside C program: CSort() - \n");

    // this just searches for now

    int length = 9;
    int arr[9] = {3, 2, 1, 8, 4, 9, 0, 5, 7};

    for(int i=0; i<length; i++){
        if(arr[i] == target)
            return i;
    }
    return -1;
};