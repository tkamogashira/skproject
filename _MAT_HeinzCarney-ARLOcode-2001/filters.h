/**
   This file defines several filters that is used in the program
 */
#ifndef _FILTER_H
#define _FILTER_H
#include <math.h>
#include <stdlib.h>
#include "complex.h"

#ifndef TWOPI
#define TWOPI 6.2831853
#endif
/*// Maximum order of the filter */
#define MAX_ORDER 10

/*/######################################################################## */
/* interface the users */
typedef struct __LowPass TLowPass;
typedef struct __HighPass THighPass;
typedef struct __GammaTone TGammaTone;
/*// Construct the filter with time_resolustion(1/F_s), cutoff frequency, gain, filter order */
TLowPass* getLowPass(double _tdres,double _Fc,double _gain,int _LPorder);
void initLowPass(TLowPass* p,double _tdres,double _Fc,double _gain,int _LPorder);
/*// */
TGammaTone* getGammaTone(double _tdres,double _Fshift,double _tau,double _gain,int _order);
void initGammaTone(TGammaTone* p,double _tdres,double _Fshift,double _tau,double _gain,int _order);
/*// Init the filter with time_resolution(1/F_s), cut-off freq., gain,order */
THighPass* getHighPass(double _tdres,double _Fc,double _gain,int _HPorder);
void initHighPass(THighPass* p,double _tdres,double _Fc,double _gain,int _HPorder);
/* /########################################################################################## */
/*/ ----------------------------------------------------------------------------
 **
   Lowpass Filter
*/

struct __LowPass{
  /*//input one signal to the filter and get the output */
  double (*run)(TLowPass *p, double x);
  /*//input multiple signal to the filter and get the multiple output */
  void (*run2)(TLowPass *p,const double *in, double *out, const int length);

  /*/time-domain resolution,cut-off frequency,gain, filter order */
  double tdres, Fc, gain;
  int Order;
  /*/ parameters used in calculation */
  double c1LP,c2LP,hc[MAX_ORDER],hcl[MAX_ORDER];
};

/*/ ----------------------------------------------------------------------------
 **
  Highpass Filter
*/
struct __HighPass{

  /*//input one signal to the filter and get the output */
  double (*run)(THighPass *p, double x);
  /*//input multiple signal to the filter and get the multiple output */
  void (*run2)(THighPass *p,const double *in, double *out, const int length);
  /*time-domain resolution, cut-off frequency, gain of the filter */
  double tdres,Fc,gain;
  int Order;       /*/order of the hi-pass */
  double c1HP,c2HP,hc[MAX_ORDER],hcl[MAX_ORDER];
};

/*/ ----------------------------------------------------------------------------
 **
   Gammatone filter
 */
struct __GammaTone
{
  /*//input one signal to the filter and get the output */
  double (*run)(TGammaTone *p, double x);
  /*//input multiple signal to the filter and get the multiple output */
  void (*run2)(TGammaTone *p,const double *in, double *out, const int length);

  double phase;
  /* Cutoff Freq(tau), Shift Freq, ... */
  double tdres,tau;
  double F_shift,delta_phase;
  double gain,c1LP,c2LP;
  COMPLEX gtf[MAX_ORDER],gtfl[MAX_ORDER];
  int Order;

  /*// Set the tau of the gammatone filter, this is useful for time-varying filter */
  void (*settau)(TGammaTone *p, double _tau);
};
#endif
