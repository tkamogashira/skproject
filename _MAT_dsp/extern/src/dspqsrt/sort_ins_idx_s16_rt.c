/* MWDSP_Sort_Ins_Val_S16 Function to sort an input array of real
 * int16_T for Sort block in DSP System Toolbox
 *
 *  Implement Insertion sort-by-index algorithm
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 */

#ifdef MW_DSP_RT
#include "src/dspsrt_rt.h"
#else
#include "dspsrt_rt.h"
#endif

LIBMW_SRC_API void MWDSP_Sort_Ins_Idx_S16(const int16_T *a, uint32_T *idx, int_T n)
{
    uint32_T i0 = idx[0];
    int16_T t0 = a[i0];
    int_T i;
    for (i=1; i<n; i++) {
        uint32_T i1 = idx[i];
        int16_T t1 = a[i1];
        if (t0 > t1) {
            int_T j;
            idx[i] = i0;
            for (j=i-1; j>0; j--) {
                uint32_T i2 = idx[j-1];
                int16_T t2 = a[i2];
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

/* [EOF] */
