/**********************/
/*
 * blms_an_wn_rr_rt.c - DSP System Toolbox Block LMS adaptive filter run-time function
 *
 * Specifications:
 *
 * - Non-complex (single precision) Input Signal
 * - Non-complex (single precision) Desired Signal
 * - All outputs Non-complex (single precision)
 * - Adapt input port - NO
 * - Weight output port - NO
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 */

#if (!defined(INTEGER_CODE) || !INTEGER_CODE)
 #ifdef MW_DSP_RT
#include "src/dspblms_rt.h"
#else
#include "dspblms_rt.h"
#endif
LIBMW_SRC_API void MWDSP_blms_an_wn_RR(   const real32_T *inSigU,
                                const real32_T *deSigU,
                                const real32_T  muU,
                                real32_T       *inBuff,
                                real32_T       *wgtBuff,
                                const int_T   FilterLength,
                                const int_T   BlockLength,
                                const real32_T  LkgFactor,
                                const int_T   FrmLen,
                                real32_T       *outY,
                                real32_T       *errY)
{
int_T i,j,k,m=0;
const int_T FiltLen_minus_1 = FilterLength-1;
const int_T NumberOfFrame   = (int_T)(FrmLen/BlockLength + 0.5); /* To avoid precision problem */
const int_T bytesPerFiltLen = FilterLength*sizeof(real32_T);
const int_T bytesPerBlkLen  = BlockLength*sizeof(real32_T);

memset(outY,0,sizeof(real32_T)*FrmLen);

for (i=0; i<NumberOfFrame; i++)
{
  /* Step-1: Copy new BlockLength samples at the END of the linear buffer (has length = FilterLength+BlockLength */
       memmove(inBuff, (inBuff + BlockLength), bytesPerFiltLen);
       memcpy((inBuff + FilterLength), inSigU + i*BlockLength, bytesPerBlkLen);

  /* Step-2: convolve inBuff_vector (length= FilterLength+BlockLength) and wgtIC_vector(length=FilterLength) (not yet updated) and */
  /* resultantLen = FilterLength+BlockLength + FilterLength - 1, but we need only FilterLength+1:(FilterLength+BlockLength) */
       for (j=0; j <BlockLength; j++)
       {
         int_T j_plus_1 = j+1;
         for (k=0; k < FilterLength; k++)
         {
            outY[m] += wgtBuff[FiltLen_minus_1-k] * inBuff[k+j_plus_1];
         }
          /* Step-3: get error for the current sample in the block */
         errY[m] = deSigU[m] - outY[m];
         m++;
       }

  /* Step-4: correlate inBuff_vector (length= FilterLength+BlockLength) and errY_vector(length=BlockLength) and  */
  /* resultantLen = FilterLength+BlockLength + FilterLength - 1, but we need only BlockLength+1:(FilterLength+BlockLength) */
       m=i*BlockLength;
       for (j=0; j <FilterLength; j++)
       {
         real32_T tmpSum = 0;
         int_T j_plus_1 = j+1;
         for (k=0; k < BlockLength; k++)
         {
            tmpSum += muU * errY[m+k] * inBuff[k+j_plus_1];
         }
         wgtBuff[FiltLen_minus_1-j] = tmpSum + LkgFactor*wgtBuff[FiltLen_minus_1-j];
       }
   m=(i+1)*BlockLength;
}
}

#endif /* !INTEGER_CODE */
/* [EOF] blms_an_wn_rr_rt.c */

