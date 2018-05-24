/* QSRT_QID_PARTITION_D_RT Helper functions for Sort block in DSP System Toolbox, data-type = double precision.
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 */

#if (!defined(INTEGER_CODE) || !INTEGER_CODE)

#ifdef MW_DSP_RT
#include "src/dspsrt_rt.h"
#else
#include "dspsrt_rt.h"
#endif

LIBMW_SRC_API int_T MWDSP_SrtQidPartitionD(const real_T *qid_array, int_T *qid_index,
                           int_T i, int_T j, int_T pivot )
{
    real_T pval = *(qid_array + *(qid_index + pivot));

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

/* [EOF] srt_qid_partition_d_rt.c */

