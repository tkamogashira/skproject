/* MWDSP_Sort_Ins_Val_R Function to sort an input array of real
 * singles for Sort block in DSP System Toolbox
 *
 *  Implement Insertion sort-by-index algorithm
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 */

#if (!defined(INTEGER_CODE) || !INTEGER_CODE)

#ifdef MW_DSP_RT
#include "src/dspsrt_rt.h"
#else
#include "dspsrt_rt.h"
#endif

LIBMW_SRC_API void MWDSP_Sort_Ins_Idx_R(const real32_T *a, uint32_T *idx, int_T n)
{
    uint32_T i0 = idx[0];
    real32_T t0 = a[i0];
    int_T i;
    for (i=1; i<n; i++) {
        uint32_T i1 = idx[i];
        real32_T t1 = a[i1];
        if (t0 > t1) {
            int_T j;
            idx[i] = i0;
            for (j=i-1; j>0; j--) {
                uint32_T i2 = idx[j-1];
                real32_T t2 = a[i2];
                if (t2 > t1) {
                    idx[j] = i2;
                } else {
                    break;
                }
            }
            idx[j] = i1;
        } else {
            t0 = t1;
            i0 = i1;
        }
    }
}

#endif /* !INTEGER_CODE */

/* [EOF] */
