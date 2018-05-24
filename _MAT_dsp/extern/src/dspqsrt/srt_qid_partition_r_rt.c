/* QSRT_HELPER_R_RT Helper functions for Sort block Single-precision in DSP System Toolbox
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 */

#if (!defined(INTEGER_CODE) || !INTEGER_CODE)

#ifdef MW_DSP_RT
#include "src/dspsrt_rt.h"
#else
#include "dspsrt_rt.h"
#endif

LIBMW_SRC_API int_T MWDSP_SrtQidPartitionR(const real32_T *qid_array, int_T *qid_index,
                           int_T i, int_T j, int_T pivot )
{
    real32_T pval = *(qid_array + *(qid_index + pivot));

    while (i <= j) {
        while( *( qid_array + *(qid_index+i) ) <  pval) {
            ++i;
        }
        while( *( qid_array + *(qid_index+j) ) >= pval) {
            --j;
        }
        if (i<j) {
            qid_Swap(i,j)
            ++i; --j;
        }
    }
    return(i);
}

#endif /* !INTEGER_CODE */

/* [EOF] srt_qid_partition_r_rt.c */




