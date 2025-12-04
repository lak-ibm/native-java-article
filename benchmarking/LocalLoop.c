#include "native/helper_Loop.h"
#include <stdio.h>
#include <limits.h>

int main (){
    printf("Standalone ");
    nativeSieve(1000001L);
    return 0;
}