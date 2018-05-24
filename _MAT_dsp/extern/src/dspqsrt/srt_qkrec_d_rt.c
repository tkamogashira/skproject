/* QSRT_D_RT Function to sort an input array of real doubles for Sort block in DSP System Toolbox
 *
 * Implement Quicksort algorithm using indices (qid)
 * Note: this algorithm is different from MATLAB's sorting
 * for complex values with same magnitude.
 *
 * Sorts an array of doubles based on the "Quicksort" algorithm,
 * using an index vector rather than the data itself.
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 */

#if (!defined(INTEGER_CODE) || !INTEGER_CODE)

#ifdef MW_DSP_RT
#include "src/dspsrt_rt.h"
#else
#include "dspsrt_rt.h"
#endif

/* The recursive quicksort routine: */
LIBMW_SRC_API void MWDSP_SrtQkRecD(const real_T *qid_array, int_T *qid_index, int_T i, int_T j )
{
    int_T pivot;
    if (MWDSP_SrtQidFindPivotD(qid_array, qid_index, i, j, &pivot)) {
        int_T k = MWDSP_SrtQidPartitionD(qid_array, qid_index, i, j, pivot);
        MWDSP_SrtQkRecD(qid_array, qid_index, i, k-1);
        MWDSP_SrtQkRecD(qid_array, qid_index, k, j);
    }
}

#endif /* !INTEGER_CODE */


/* [EOF] srt_qkrec_d_rt.c */
