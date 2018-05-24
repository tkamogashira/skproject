/* QSRT_R_RT Function to sort an input array of complex singles for Sort block in DSP System Toolbox.
 *
 * Implement Quicksort algorithm using indices (qid)
 * Note: this algorithm is different from MATLAB's sorting
 * for complex values with same magnitude.
 *
 * Sorts an array of singles based on the "Quicksort" algorithm,
 * using an index vector rather than the data itself.
 *
 *  Copyright 2013 The MathWorks, Inc.
 */

#ifdef MW_DSP_RT
#include "src/dspsrt_rt.h"
#else
#include "dspsrt_rt.h"
#endif
#if (!defined(INTEGER_CODE) || !INTEGER_CODE) && defined(CREAL_T)

LIBMW_SRC_API void MWDSP_SrtQkRecC(const creal32_T *qid_array, int_T *qid_index, real32_T *sort,
                        int_T i, int_T j )
{
    int_T pivot,cntr;
    for(cntr=0;cntr<=j;cntr++) {
        creal32_T val = qid_array[cntr];
        sort[cntr] = CMAGSQ(val);
    }
    if (MWDSP_SrtQidFindPivotR(sort, qid_index, i, j, &pivot)) {
        int_T k = MWDSP_SrtQidPartitionR(sort, qid_index, i, j, pivot);
        MWDSP_SrtQkRecR(sort, qid_index, i, k-1);
        MWDSP_SrtQkRecR(sort, qid_index, k, j);
    }
}

#endif /* !INTEGER_CODE && CREAL_T */

/* [EOF] srt_qkrec_c_rt.c */

