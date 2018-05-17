#ifndef _HC_H
#define _HC_H
#include <math.h>
#include <stdlib.h>
#include "filters.h"

typedef struct __NonLinear TNonLinear;
typedef struct __HairCell THairCell;
THairCell* getHairCell(double tdres, double cutoff, int order);
TNonLinear* getAfterOhcNL(double taumin,double taumax,double dc,double minR);

/*/AfterOHC NonLinear */
double runAfterOhcNL(TNonLinear* p, double x);
void runAfterOhcNL2(TNonLinear* p, const double *in, double *out,const int length);
/*/OHC NonLinear function */
void init_boltzman(TNonLinear* p,double _corner,double _slope, double _strength,
   	                  double _x0,double _s0,double _x1,double _s1,double _asym);
double runBoltzman(TNonLinear *p,double x);
void runBoltzman2(TNonLinear *p,const double *in,double *out,const int length);
/*/IHC NonLinear function */
double runIHCNL(TNonLinear * p,double x);
void runIHCNL2(TNonLinear* p,const double *in,double *out,const int length);
/*/IHCPPI Nonlinear */
double runIHCPPI(TNonLinear* p, double x);
void runIHCPPI2(TNonLinear* p,const double *in,double *out,const int length);
/*/HairCell run */
double runHairCell(THairCell* p,double x);
void runHairCell2(THairCell* p,const double *in,double *out,const int length);

/*
 *
 * ################# Structure Implementation #######################
 *
 */
struct __NonLinear{
  double (*run)(TNonLinear* p,double x);
  void (*run2)(TNonLinear *p,const double *in,double *out,const int length);
  /*/For OHC Boltzman */
  double p_corner,p_slope,p_strength,x0,s0,x1,s1,shift;
  double Acp,Bcp,Ccp;
  /*/For AfterOHCNL */
  double dc,minR,A,TauMax,TauMin; /*/s0 also used by AfterOHCNL */
  /*/For IHC nonlinear function */
  double A0,B,C,D;
  /*/For IHCPPI nonlinear */
  double psl,pst,p1,p2;
};

struct __HairCell{
  double (*run)(THairCell *p,double x);
  void (*run2)(THairCell* p,const double *in, double *out,const int length);
  TLowPass hclp;
  TNonLinear hcnl;
  /*/Boltzman Like NonLinear */
  void (*setOHC_NL)(THairCell*,double,double,double,double,double,double,double,double);
  void (*setIHC_NL)();
};

#endif

