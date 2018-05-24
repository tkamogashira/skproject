/*
 *  dspendian_rt.h
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 */
#ifndef dspendian_rt_h
#define dspendian_rt_h

#include "dsp_rt.h"
#ifdef MW_DSP_RT
#include "src/libmw_src_util.h"
#else
#include "libmw_src_util.h"
#endif
#ifdef __cplusplus
extern "C" {
#endif

LIBMW_SRC_API int_T isLittleEndian(void);

#ifdef __cplusplus
}
#endif

#endif  /* dspendian_rt_h */

/* [EOF] dspendian_rt.h */
