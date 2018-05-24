/*
 *  dspblms_rt.h   Runtime functions for DSP Blockset BLOCK LMS Adaptive filter block.
 *
 *
 *  Copyright 1995-2013 The MathWorks, Inc.
 */
#ifndef dspblms_rt_h
#define dspblms_rt_h

#include "dsp_rt.h"
#ifdef MW_DSP_RT
#include "src/libmw_src_util.h"
#else
#include "libmw_src_util.h"
#endif
/*
 * Function naming glossary
 * ---------------------------
 *
 * MWDSP = MathWorks DSP Blockset
 *
 * Data types - (describe inputs to functions, not outputs)
 * R = real single-precision
 * C = complex single-precision
 * D = real double-precision
 * Z = complex double-precision
 */

/* Function naming convention
 * --------------------------
 *
 * MWDSP_blms_a[y/n]_w[y/n]_<Input_Signal_DataType><Desired_Signal_DataType>
 *
 *    1) MWDSP_ is a prefix used with all Mathworks DSP runtime library
 *       functions.
 *    2) The second field indicates that this function is implementing the
 *       BLOCK LMS Adaptive filter algorithm.
 *    3) The third field a[y/n] indicates whether there is adapt input port or not
 *       'ay' means there is adapt input port, 'an' means no adapt input port
 *    4) The fourth field w[y/n] indicates whether there is weight output port or not
 *       'wy' means there is weight output port, 'wn' means no weight output port
 *    5) The third field enumerates the data type from the above list.
 *       Single/double precision and complexity are specified within a single letter.
 *       The input data type is indicated.
 *
 *    Examples:
 *       MWDSP_blms_ay_wn_ZZ is the Block LMS Adaptive filter run time function for
 *       double precision complex input signal, double precision complex desired signal
 *       with adapt input port and no weight output port
 */

#ifdef __cplusplus
extern "C" {
#endif

/* 000 */
LIBMW_SRC_API void MWDSP_blms_an_wn_DD(const real_T *inSigU,
                                const real_T *deSigU,
                                const real_T  muU,
                                real_T       *inBuff,
                                real_T       *wgtBuff,
                                const int_T   FilterLength,
                                const int_T   BlockLength,
                                const real_T  LkgFactor,
                                const int_T   FrmLen,
                                real_T       *outY,
                                real_T       *errY);
/* 001 */
#ifdef CREAL_T
LIBMW_SRC_API void MWDSP_blms_an_wn_ZZ(const creal_T *inSigU,
                                const creal_T *deSigU,
                                const real_T  muU,
                                creal_T       *inBuff,
                                creal_T       *wgtBuff,
                                const int_T   FilterLength,
                                const int_T   BlockLength,
                                const real_T  LkgFactor,
                                const int_T   FrmLen,
                                creal_T       *outY,
                                creal_T       *errY);
#endif /* CREAL_T */

/* 002 */
LIBMW_SRC_API void MWDSP_blms_an_wn_RR(const real32_T *inSigU,
                                const real32_T *deSigU,
                                const real32_T  muU,
                                real32_T       *inBuff,
                                real32_T       *wgtBuff,
                                const int_T   FilterLength,
                                const int_T   BlockLength,
                                const real32_T  LkgFactor,
                                const int_T   FrmLen,
                                real32_T       *outY,
                                real32_T       *errY);
/* 003 */
#ifdef CREAL_T
LIBMW_SRC_API void MWDSP_blms_an_wn_CC(const creal32_T *inSigU,
                                const creal32_T *deSigU,
                                const real32_T  muU,
                                creal32_T       *inBuff,
                                creal32_T       *wgtBuff,
                                const int_T   FilterLength,
                                const int_T   BlockLength,
                                const real32_T  LkgFactor,
                                const int_T   FrmLen,
                                creal32_T       *outY,
                                creal32_T       *errY);
#endif /* CREAL_T */

/* 004 */
LIBMW_SRC_API void MWDSP_blms_an_wy_DD(const real_T *inSigU,
                                const real_T *deSigU,
                                const real_T  muU,
                                real_T       *inBuff,
                                real_T       *wgtBuff,
                                const int_T   FilterLength,
                                const int_T   BlockLength,
                                const real_T  LkgFactor,
                                const int_T   FrmLen,
                                real_T       *outY,
                                real_T       *errY,
                                real_T       *wgtY);
/* 005 */
#ifdef CREAL_T
LIBMW_SRC_API void MWDSP_blms_an_wy_ZZ(const creal_T *inSigU,
                                const creal_T *deSigU,
                                const real_T  muU,
                                creal_T       *inBuff,
                                creal_T       *wgtBuff,
                                const int_T   FilterLength,
                                const int_T   BlockLength,
                                const real_T  LkgFactor,
                                const int_T   FrmLen,
                                creal_T       *outY,
                                creal_T       *errY,
                                creal_T       *wgtY);
#endif /* CREAL_T */

/* 006 */
LIBMW_SRC_API void MWDSP_blms_an_wy_RR(const real32_T *inSigU,
                                const real32_T *deSigU,
                                const real32_T  muU,
                                real32_T       *inBuff,
                                real32_T       *wgtBuff,
                                const int_T   FilterLength,
                                const int_T   BlockLength,
                                const real32_T  LkgFactor,
                                const int_T   FrmLen,
                                real32_T       *outY,
                                real32_T       *errY,
                                real32_T       *wgtY);
/* 007 */
#ifdef CREAL_T
LIBMW_SRC_API void MWDSP_blms_an_wy_CC(const creal32_T *inSigU,
                                const creal32_T *deSigU,
                                const real32_T  muU,
                                creal32_T       *inBuff,
                                creal32_T       *wgtBuff,
                                const int_T   FilterLength,
                                const int_T   BlockLength,
                                const real32_T  LkgFactor,
                                const int_T   FrmLen,
                                creal32_T       *outY,
                                creal32_T       *errY,
                                creal32_T       *wgtY);
#endif /* CREAL_T */

/* 008 */
LIBMW_SRC_API void MWDSP_blms_ay_wn_DD(const real_T *inSigU,
                                const real_T *deSigU,
                                const real_T  muU,
                                real_T       *inBuff,
                                real_T       *wgtBuff,
                                const int_T   FilterLength,
                                const int_T   BlockLength,
                                const real_T  LkgFactor,
                                const int_T   FrmLen,
                                real_T       *outY,
                                real_T       *errY,
                                const boolean_T     NeedAdapt);
/* 009 */
#ifdef CREAL_T
LIBMW_SRC_API void MWDSP_blms_ay_wn_ZZ(const creal_T *inSigU,
                                const creal_T *deSigU,
                                const real_T  muU,
                                creal_T       *inBuff,
                                creal_T       *wgtBuff,
                                const int_T   FilterLength,
                                const int_T   BlockLength,
                                const real_T  LkgFactor,
                                const int_T   FrmLen,
                                creal_T       *outY,
                                creal_T       *errY,
                                const boolean_T     NeedAdapt);
#endif /* CREAL_T */

/* 010 */
LIBMW_SRC_API void MWDSP_blms_ay_wn_RR(const real32_T *inSigU,
                                const real32_T *deSigU,
                                const real32_T  muU,
                                real32_T       *inBuff,
                                real32_T       *wgtBuff,
                                const int_T   FilterLength,
                                const int_T   BlockLength,
                                const real32_T  LkgFactor,
                                const int_T   FrmLen,
                                real32_T       *outY,
                                real32_T       *errY,
                                const boolean_T     NeedAdapt);
/* 011 */
#ifdef CREAL_T
LIBMW_SRC_API void MWDSP_blms_ay_wn_CC(const creal32_T *inSigU,
                                const creal32_T *deSigU,
                                const real32_T  muU,
                                creal32_T       *inBuff,
                                creal32_T       *wgtBuff,
                                const int_T   FilterLength,
                                const int_T   BlockLength,
                                const real32_T  LkgFactor,
                                const int_T   FrmLen,
                                creal32_T       *outY,
                                creal32_T       *errY,
                                const boolean_T     NeedAdapt);
#endif /* CREAL_T */

/* 012 */
LIBMW_SRC_API void MWDSP_blms_ay_wy_DD(const real_T *inSigU,
                                const real_T *deSigU,
                                const real_T  muU,
                                real_T       *inBuff,
                                real_T       *wgtBuff,
                                const int_T   FilterLength,
                                const int_T   BlockLength,
                                const real_T  LkgFactor,
                                const int_T   FrmLen,
                                real_T       *outY,
                                real_T       *errY,
                                real_T       *wgtY,
                                const boolean_T     NeedAdapt);
/* 013 */
#ifdef CREAL_T
LIBMW_SRC_API void MWDSP_blms_ay_wy_ZZ(const creal_T *inSigU,
                                const creal_T *deSigU,
                                const real_T  muU,
                                creal_T       *inBuff,
                                creal_T       *wgtBuff,
                                const int_T   FilterLength,
                                const int_T   BlockLength,
                                const real_T  LkgFactor,
                                const int_T   FrmLen,
                                creal_T       *outY,
                                creal_T       *errY,
                                creal_T       *wgtY,
                                const boolean_T     NeedAdapt);
#endif /* CREAL_T */

/* 014 */
LIBMW_SRC_API void MWDSP_blms_ay_wy_RR(const real32_T *inSigU,
                                const real32_T *deSigU,
                                const real32_T  muU,
                                real32_T       *inBuff,
                                real32_T       *wgtBuff,
                                const int_T   FilterLength,
                                const int_T   BlockLength,
                                const real32_T  LkgFactor,
                                const int_T   FrmLen,
                                real32_T       *outY,
                                real32_T       *errY,
                                real32_T       *wgtY,
                                const boolean_T     NeedAdapt);
/* 015 */
#ifdef CREAL_T
LIBMW_SRC_API void MWDSP_blms_ay_wy_CC(const creal32_T *inSigU,
                                const creal32_T *deSigU,
                                const real32_T  muU,
                                creal32_T       *inBuff,
                                creal32_T       *wgtBuff,
                                const int_T   FilterLength,
                                const int_T   BlockLength,
                                const real32_T  LkgFactor,
                                const int_T   FrmLen,
                                creal32_T       *outY,
                                creal32_T       *errY,
                                creal32_T       *wgtY,
                                const boolean_T     NeedAdapt);
#endif /* CREAL_T */

#ifdef __cplusplus
}
#endif


#endif  /*  dspblms_rt_hpp */
