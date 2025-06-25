#include <jni.h>
#include <stdio.h>
#include <time.h>
#include "memalloc_Mem.h"
#include "helper_Mem.h"

JNIEXPORT void JNICALL Java_memalloc_Mem_c_1allocator(JNIEnv *env, jobject obj, jint num) {
    printf("JNI ");
    navtiveMemoryAllocator(num);
};