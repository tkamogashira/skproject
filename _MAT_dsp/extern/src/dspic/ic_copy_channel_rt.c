/* 
 * ic_copy_channel_rt.c
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

LIBMW_SRC_API void MWDSP_CopyChannelICs( byte_T       *dstBuff, 
                           const byte_T *ICBuff, 
                           int_T         numChans, 
                           const int_T   sampsPerChan,
                           const int_T   bytesPerElem )
{
    while (numChans-- > 0) {
        int_T spc = sampsPerChan;
        
        /* Scalar expansion of current IC element over current channel elements */
        while (spc-- > 0) {
            memcpy( dstBuff, ICBuff, bytesPerElem );
            dstBuff += bytesPerElem;
        }

        ICBuff += bytesPerElem;
    }
}

/* [EOF] ic_copy_channel_rt.c */
