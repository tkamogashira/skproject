/*
 *  randsrcinitstate_gc_32_rt.c
 *  DSP Random Source Run-Time Library Helper Function
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 */

#if (!defined(INTEGER_CODE) || !INTEGER_CODE)

#ifdef MW_DSP_RT
#include "src/dsprandsrc32bit_rt.h"
#else
#include "dsprandsrc32bit_rt.h"
#endif
#include <math.h>

/* Assumed lengths:
 *  seed:   nChans
 *  state:  35*nChans
 */

LIBMW_SRC_API void MWDSP_RandSrcInitState_GC_32(const uint32_T *seed,  /* seed value vector */
                                                        real32_T       *state, /* state vectors */
                                                        int_T          nChans) /* number channels */
{
    MWDSP_RandSrcInitState_U_32(seed, state, nChans);
}

#endif /* !INTEGER_CODE */

/* [EOF] randsrcinitstate_gc_32_rt.c */
