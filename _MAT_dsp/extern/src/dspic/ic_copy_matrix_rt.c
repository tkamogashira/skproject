/* 
 * ic_copy_matrix_rt.c
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

LIBMW_SRC_API void MWDSP_CopyMatrixICs( byte_T       *dstBuff, 
                          const byte_T *ICBuff, 
                          const int_T   numElems, 
                          const int_T   bytesPerElem )
{
    memcpy( dstBuff, ICBuff, numElems * bytesPerElem );
}

/* [EOF] ic_copy_matrix_rt.c */
