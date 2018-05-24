/* 
 * ic_copy_vector_rt.c
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 *
 * Abstract:
 *   Copy functions for the initial condition handler.
 */

#ifdef MW_DSP_RT
#include "src/dsp_ic_rt.h"
#else
#include "dsp_ic_rt.h"
#endif

LIBMW_SRC_API void MWDSP_CopyVectorICs( byte_T       *dstBuff, 
                          const byte_T *ICBuff, 
                          int_T         numChans, 
                          const int_T   bytesPerChan )
{
    while (numChans-- > 0) {
        memcpy( dstBuff, ICBuff, bytesPerChan );
        dstBuff += bytesPerChan;
    }
}

/* [EOF] ic_copy_vector_rt.c */
