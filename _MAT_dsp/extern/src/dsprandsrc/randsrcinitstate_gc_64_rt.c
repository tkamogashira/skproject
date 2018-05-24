/*
 *  randsrcinitstate_gc_64_rt.c
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
#include <math.h>

/* Assumed lengths:
 *  seed:   nChans
 *  state:  35*nChans
 */

LIBMW_SRC_API void MWDSP_RandSrcInitState_GC_64(const uint32_T *seed,  /* seed value vector */
                                  real64_T       *state, /* state vectors */
                                  int_T          nChans) /* number channels */
{
    MWDSP_RandSrcInitState_U_64(seed, state, nChans);
}

#endif /* !INTEGER_CODE */

/* [EOF] randsrcinitstate_gc_64_rt.c */
