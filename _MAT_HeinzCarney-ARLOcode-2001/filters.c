#include <stdlib.h>
#include "filters.h"
#include "complex.h"
/**
    The low-pass filter is in the form of cascade of first order lowpass filter\\
    Each of them is implemented as y(i) = c1*y(i-1)+c2*(x(i)+x(i-1))

    This function initializes the filter:\\
    1. initialize/reset the filter\\
    2. calculation c1 c2 thru bilinear transformation\\
    3. set the gain and order of the filter\\

    @author Xuedong Zhang
 */
/**
 * Internal function used by TLowPass
 */
double runLowPass(TLowPass *p, double x);
void runLowPass2(TLowPass *p,const double *in, double *out, const int length);
void initLowPass(TLowPass* res,double _tdres,double _Fc,double _gain,int _LPorder);
TLowPass* getLowPass(double _tdres,double _Fc,double _gain,int _LPorder)
{
  TLowPass *res = (TLowPass*) malloc(sizeof(TLowPass));	
  initLowPass(res, _tdres, _Fc, _gain, _LPorder);
return(res);
};

void initLowPass(TLowPass* res,double _tdres,double _Fc,double _gain,int _LPorder)
{
  double c;
  int i;
  res->tdres = _tdres;
  c = 2.0/_tdres;
  res->Fc = _Fc;
  res->Order = _LPorder;
  res->c1LP = ( c - TWOPI*_Fc ) / ( c + TWOPI*_Fc );
  res->c2LP = TWOPI*_Fc / (TWOPI*_Fc + c);
  for(i=0; i<=res->Order; i++) res->hc[i] = res->hcl[i] = 0.0;
  res->gain = _gain;

  res->run = runLowPass;
  res->run2 = runLowPass2;
return;
};
/**
  This function runs the low-pass filter
   @author Xuedong Zhang
 */
double runLowPass(TLowPass *p, double x)
{
  register int i;
  register int pOrder = p->Order;
  p->hc[0] = x*p->gain;

  for(i=0; i< pOrder; i++)
    p->hc[i+1] = p->c1LP * p->hcl[i+1] + p->c2LP*(p->hc[i]+p->hcl[i]);

  for(i=0; i<=pOrder;i++) p->hcl[i] = p->hc[i];

  return(p->hc[pOrder]);
};
/**
  This function runs the low-pass filter
   @author Xuedong Zhang
 */
void runLowPass2(TLowPass *p,const double *in, double *out, const int length)
{
  register int loopSig,loopLP;
  int pOrder = p->Order;
  double *hc,*hcl,c1LP,c2LP;
  double gain;
  gain = p->gain;
  c1LP = p->c1LP;
  c2LP = p->c2LP;
  hc = p->hc;
  hcl = p->hcl;
  for(loopSig=0; loopSig<length; loopSig++)
  {
    hc[0] = in[loopSig]*gain;

    for(loopLP=0; loopLP<pOrder; loopLP++)
      hc[loopLP+1] = c1LP * hcl[loopLP+1] + c2LP*(hc[loopLP]+hcl[loopLP]);

    for(loopLP=0; loopLP<=pOrder;loopLP++) hcl[loopLP] = hc[loopLP];
    out[loopSig] = hc[pOrder];
  };
  return;
};

/**

    The high-pass filter is in the form of a cascade of first order highpass filter\\
    Each of them is implemented as y(i) = c1*y(i-1)+c2*(x(i)-x(i-1))

    This function does several things:\\
    1. initialize/reset the filter\\
    2. calculation c1 c2 thru bilinear transformation\\
    3. set the gain and order of the filter\\

    @author Xuedong Zhang
*/

/**
 * Internal function used by THighPass
 */
double runHighPass(THighPass *p, double x);
void runHighPass2(THighPass *p,const double *in, double *out, const int length);
void initHighPass(THighPass* p,double _tdres,double _Fc,double _gain,int _HPorder);

THighPass* getHighPass(double _tdres,double _Fc,double _gain,int _HPorder)
{
  THighPass* res = (THighPass*) malloc(sizeof(THighPass));
  initHighPass(res,_tdres,_Fc,_gain,_HPorder);
return(res);
};

void initHighPass(THighPass* p,double _tdres,double _Fc,double _gain,int _HPorder)
{
  double c;
  int i;
  THighPass *res = p;
  res->tdres = _tdres;
  c = 2.0/_tdres;
  res->Fc = _Fc;
  res->Order = _HPorder;
  res->c1HP = ( c - TWOPI*_Fc ) / ( c + TWOPI*_Fc );
  res->c2HP =  c / (TWOPI*_Fc + c);
  for(i=0; i<=res->Order; i++) res->hc[i] = res->hcl[i] = 0.0;
  res->gain = _gain;

  res->run = runHighPass;
  res->run2 = runHighPass2;
return;
};
/**

   This function get the filtering output of the high-pass filter
   @author Xuedong Zhang
 */
double runHighPass(THighPass *p, double x)
{
  register int i;
  int pOrder = p->Order;
  p->hc[0] = x*p->gain;

  for(i=0; i<pOrder;i++)
    p->hc[i+1] = p->c1HP*p->hcl[i+1] + p->c2HP*(p->hc[i]-p->hcl[i]);

  for(i=0; i<=pOrder;i++) p->hcl[i] = p->hc[i];

  return(p->hc[pOrder]);
};
/**

   This function get the filtering output of the high-pass filter
   @author Xuedong Zhang
 */
void runHighPass2(THighPass *p,const double *in, double *out, const int length)
{
  register int loopSig,loopHP;
  int pOrder = p->Order;
  double *hc = p->hc;
  double *hcl = p->hcl;
  double c1HP = p->c1HP;
  double c2HP = p->c2HP;
  double gain = p->gain;
  
  for(loopSig=0; loopSig<length; loopSig++)
  {
    hc[0] = in[loopSig]*gain;

    for(loopHP=0; loopHP<pOrder;loopHP++)
      hc[loopHP+1] = c1HP*hcl[loopHP+1] + c2HP*(hc[loopHP]-hcl[loopHP]);

    for(loopHP=0; loopHP<=pOrder;loopHP++) hcl[loopHP] = hc[loopHP];

    out[loopSig] = hc[pOrder];
  };
return;
};

/**
    The gammatone filter is in the form of cascade of first order lowpass filter
    shifted by the center frequency (from Carney,1993)\\
    Each of the low pass filter is implemented as y(i) = c1*y(i-1)+c2*(x(i)-x(i-1))

    This function does several things:\\
    1. initialize/reset the filter\\
    2. calculation c1 c2 thru bilinear transformation from tau\\
    3. set the gain and order of the filter\\

    @author Xuedong Zhang
*/
void setGammaToneTau(TGammaTone *p, double tau);
double runGammaTone(TGammaTone *p, double x);
void runGammaTone2(TGammaTone *p, const double *in, double *out, const int length);
void initTGammaTone(TGammaTone* res,double _tdres,double _Fshift,double _tau,double _gain,int _order);
TGammaTone* getGammaTone(double _tdres,double _Fshift,double _tau,double _gain,int _order)
{
  TGammaTone *res = (TGammaTone*) malloc(sizeof(TGammaTone));
  initGammaTone(res,_tdres,_Fshift,_tau,_gain,_order);
return(res);
};

void initGammaTone(TGammaTone* res,double _tdres,double _Fshift,double _tau,double _gain,int _order)
{
  double c;
  int i;
  res->tdres = _tdres;
  res->F_shift = _Fshift;
  res->delta_phase = -TWOPI*_Fshift*_tdres;
  res->phase = 0;
  res->tau = _tau;

  c = 2.0/_tdres; /* for bilinear transformation */
  res->c1LP = (_tau*c-1)/(_tau*c+1);
  res->c2LP = 1/(_tau*c+1);
  res->gain = _gain;
  res->Order = _order;
  for( i=0; i<=res->Order; i++) 
	  res->gtf[i].x = res->gtfl[i].x = res->gtf[i].y = res->gtfl[i].y = 0.0;

  res->run = runGammaTone;
  res->run2 = runGammaTone2;
  res->settau = setGammaToneTau;
return;
};
/**

   Reset the tau of the gammatone filter\\
   it recalculate the c1 c2 used by the filtering function
 */
void setGammaToneTau(TGammaTone *p, double tau)
{
  double dtmp;
  p->tau = tau;
  dtmp = tau*2.0/p->tdres;
  p->c1LP = (dtmp-1)/(dtmp+1);
  p->c2LP = 1.0/(dtmp+1);
};
/**

   Pass the signal through the gammatone filter\\
   1. shift the signal by centeral frequency of the gamma tone filter\\
   2. low pass the shifted signal \\
   3. shift back the signal \\
   4. take the real part of the signal as output
   @author Xuedong Zhang
 */
double runGammaTone(TGammaTone *p, double x)
{
  int i,j;
  double out;
  COMPLEX c1,c2,c_phase;
  x *= p->gain;
  p->phase += p->delta_phase;

  CEXP(c_phase,p->phase); /*/ FREQUENCY SHIFT */
  CTREAL(p->gtf[0],c_phase,x);
  for( j = 1; j <= p->Order; j++)      /*/ IIR Bilinear transformation LPF */
  {
    CADD(c1,p->gtf[j-1],p->gtfl[j-1]);
    CTREAL(c2,c1,p->c2LP);
    CTREAL(c1,p->gtfl[j],p->c1LP);
    CADD(p->gtf[j],c1,c2);
  };
  CONJ(c_phase); /*/ FREQ SHIFT BACK UP */
  CMULT(c1,c_phase,p->gtf[p->Order]);
  out = CREAL(c1);
  for(i=0; i<=p->Order;i++) p->gtfl[i] = p->gtf[i];
  return(out);
};

void runGammaTone2(TGammaTone *p, const double *in, double *out, const int length)
{
  int register loopSig,loopGT;
  double x;
  COMPLEX c1,c2,c_phase;

  for(loopSig = 0; loopSig<length; loopSig++)
  {
    x = p->gain*in[loopSig];
    p->phase += p->delta_phase;

    CEXP(c_phase,p->phase); /*/ FREQUENCY SHIFT */
    CTREAL(p->gtf[0],c_phase,x);
    for( loopGT = 1; loopGT <= p->Order; loopGT++)      /*/ IIR Bilinear transformation LPF */
    {
    CADD(c1,p->gtf[loopGT-1],p->gtfl[loopGT-1]);
    CTREAL(c2,c1,p->c2LP);
    CTREAL(c1,p->gtfl[loopGT],p->c1LP);
    CADD(p->gtf[loopGT],c1,c2);
    };
    CONJ(c_phase); /* FREQ SHIFT BACK UP */
    CMULT(c1,c_phase,p->gtf[p->Order]);
    for(loopGT=0; loopGT<=p->Order;loopGT++) p->gtfl[loopGT] = p->gtf[loopGT];

    out[loopSig] = CREAL(c1);
  }; 
return;
};

