/* QSRT_QID_FINDPIVOT_R_RT Helper functions for Sort block in DSP System Toolbox, data-type = single precision.
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 */

#if (!defined(INTEGER_CODE) || !INTEGER_CODE)

#ifdef MW_DSP_RT
#include "src/dspsrt_rt.h"
#else
#include "dspsrt_rt.h"
#endif

LIBMW_SRC_API boolean_T MWDSP_SrtQidFindPivotR(const real32_T *qid_array, int_T *qid_index,
                               int_T i, int_T j, int_T *pivot )
{
    int_T  mid = (i+j)/2;
    int_T  k;
    real32_T a, b, c;

    qid_Order3(i,mid,j);    /* order the 3 values */
    a = *(qid_array + *(qid_index + i  ));
    b = *(qid_array + *(qid_index + mid));
    c = *(qid_array + *(qid_index + j  ));

    if (a < b) {   /* pivot will be higher of 2 values */
        *pivot = mid;
        return((boolean_T)1);
    }
    if (b < c) {
        *pivot = j;
        return((boolean_T)1);
    }
    for (k=i+1; k <= j; k++) {
        real32_T d = *(qid_array + *(qid_index + k));
        if (d != a) {
          *pivot = (d < a) ? i : k ;
          return((boolean_T)1);
        }
    }
    return((boolean_T)0);
}

#endif /* !INTEGER_CODE */

/* [EOF] srt_qid_findpivot_r_rt.c */
