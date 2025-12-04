#include <jni.h>
#include <stdio.h>
#include <time.h>
#include "benchmarking_Loop.h"
#include "helper_Loop.h"

JNIEXPORT void JNICALL Java_benchmarking_Loop_c_1sieve(JNIEnv *env, jobject obj, jint num) {
    printf("JNI ");
    nativeSieve(num);
};