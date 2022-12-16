#include <stdlib.h>

#include <immintrin.h>

#include "dot_product.h"
/* reference implementation in C */
unsigned int dot_product_C(long size, unsigned short * a, unsigned short *b) {
    unsigned int sum = 0;
    for (int i = 0; i < size; ++i) {
        sum += a[i] * b[i];
    }
    return sum;
}

// add prototypes here!
extern unsigned int dot_product_gcc7_O3(long size, unsigned short * a, unsigned short *b);

unsigned int dot_product_AVX(long size, unsigned short * a, unsigned short *b) {

    __m256i partial_sums = _mm256_setzero_si256();
    int i = 0;
    for (; i + 8 <= size; i += 8) {
        __m128i a_as_vector = _mm_loadu_si128((__m128i*) &a[i]);
        __m256i a_converted = _mm256_cvtepu16_epi32(a_as_vector);
        
        __m128i b_as_vector = _mm_loadu_si128((__m128i*) &b[i]);
        __m256i b_converted = _mm256_cvtepu16_epi32(b_as_vector);

        __m256i mult = _mm256_mullo_epi32(a_converted, b_converted);
        partial_sums = _mm256_add_epi32(partial_sums, mult);
    }

    unsigned int extracted_partial_sums[8];
    _mm256_storeu_si256((__m256i*) &extracted_partial_sums, partial_sums);

    unsigned int sum = 0;
    for(int j = 0; j < 8; j++){
        sum += extracted_partial_sums[j];
    }

    for(; i < size; i++){
        sum+=a[i];
    }

    return sum;
}

function_info functions[] = {
    {dot_product_C, "C (local)"},
    {dot_product_gcc7_O3, "C (compiled with GCC7.2 -O3 -mavx2)"},
    {dot_product_AVX, "AVX"},
};
