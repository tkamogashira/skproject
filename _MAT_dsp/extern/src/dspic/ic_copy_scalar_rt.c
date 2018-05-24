/* 
 * ic_copy_scalar_rt.c
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

LIBMW_SRC_API void MWDSP_CopyScalarICs( byte_T       *dstBuff, 
                          const byte_T *ICBuff, 
                          int_T         numElems, 
                          const int_T   bytesPerElem )
{
    while (numElems-- > 0) {
        memcpy( dstBuff, ICBuff, bytesPerElem );
        dstBuff += bytesPerElem;
    }
}

/* [EOF] ic_copy_scalar_rt.c */
