#include <stdlib.h>
#include <limits.h>  /* for USHRT_MAX */

#include <immintrin.h>

#include "min.h"
/* reference implementation in C */
short min_C(long size, short * a) {
    short result = SHRT_MAX;
    for (int i = 0; i < size; ++i) {
        if (a[i] < result)
            result = a[i];
    }
    return result;
}

short minAVX(long size, short * a) {
    short f = SHRT_MAX;
    __m256i minArray = _mm256_set1_epi16(f);
    int i = 0;
    for (; i + 16 <= size; i += 16) {
         __m256i a_part = _mm256_loadu_si256((__m256i*) &a[i]);
         minArray = _mm256_min_epi16(minArray, a_part);
    }

    short extracted_min_arr[16];
    _mm256_storeu_si256((__m256i*) &extracted_min_arr, minArray);

    
    for(int j = 0; j < 16; j++){
        if(extracted_min_arr[j] < f){
            f = extracted_min_arr[j];
        }
    }

    for(; i < size; i++){
        if(a[i] < f){
            f = a[i];
        }
    }

    return f;
}


/* This is the list of functions to test */
function_info functions[] = {
    {min_C, "C (local)"},
    // add entries here!
    {minAVX, "minAVX (C)"},
};
