/*
 *  randsrccreateseeds_64_rt.c
 *  DSP Random Source Run-Time Library Helper Function
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 */

#if (!defined(INTEGER_CODE) || !INTEGER_CODE)

#ifdef MW_DSP_RT
#include "src/dsprandsrc64bit_rt.h"
#else
#include "dsprandsrc64bit_rt.h"
#endif

/* Assumed lengths:
 *  seed:   nChans
 *  state:  35*nChans
 */

LIBMW_SRC_API void MWDSP_RandSrcCreateSeeds_64(uint32_T  initSeed,
                                 uint32_T *seedArray,
                                 uint32_T  numSeeds)
{
    real64_T state[35];
    real64_T tmp;
    real64_T min = 0.0;
    real64_T max = 1.0;
    MWDSP_RandSrcInitState_U_64(&initSeed,state,1);
    while (numSeeds--) {
        MWDSP_RandSrc_U_D(&tmp,&min,1,&max,1,state,1,1);
        /* scale by 2^31 = 2147483648 */
        *seedArray++ = (uint32_T)(tmp*2147483648U);
    }
}

#endif /* !INTEGER_CODE */

/* [EOF] randsrccreateseeds_64_rt.c */
