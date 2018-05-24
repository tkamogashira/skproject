/*
 *  is_little_endian_rt.c
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 */
#ifdef MW_DSP_RT
#include "src/dspendian_rt.h"
#else
#include "dspendian_rt.h"
#endif

LIBMW_SRC_API int_T isLittleEndian(void)
{
	int16_T  endck  = 1;
	int8_T  *pendck = (int8_T *)&endck;
	return(pendck[0] == (int8_T)1);
}

/* [EOF] is_little_endian_rt.c */