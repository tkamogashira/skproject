/*
 *  randsrcinitstate_gz_rt.c
 *  DSP Random Source Run-Time Library Helper Function
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 */


#ifdef MW_DSP_RT
#include "src/dsprandsrc64bit_rt.h"
#else
#include "dsprandsrc64bit_rt.h"
#endif
#include <math.h>

/* Assumed lengths:
 *  seed:   nChans   
 *  state:  2*nChans
 */

LIBMW_SRC_API void MWDSP_RandSrcInitState_GZ(const uint32_T *seed,  /* seed value vector */
                                     uint32_T *state, /* state vectors */
                                     int_T    nChans) /* number of channels */
{
    while (nChans--) {
        *state++ = 362436069;
        *state++ = (*seed == 0) ? 521288629 : *seed;
        seed++;
    }
}

/* [EOF] randsrcinitstate_gz_rt.c */
