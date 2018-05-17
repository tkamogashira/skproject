#include <math.h>
#include <stdlib.h>
#include "filters.h"
#include "hc.h"

/*
 *
 * ############## Implemenation of OHC_NL ######################
 *
 */
double runBoltzman(TNonLinear *p,double x);
void runBoltzman2(TNonLinear *p,const double *in,double *out,const int length);
void init_boltzman(TNonLinear* p,double _corner,double _slope, double _strength,
   	                  double _x0,double _s0,double _x1,double _s1,double _asym)
{
  /* asym is the ratio of positive Max to negative Max*/

  p->p_corner = _corner;
  p->p_slope = _slope;
  p->p_strength = _strength;
  p->x0 = _x0;
  p->s0 = _s0;
  p->x1 = _x1;
  p->s1 = _s1;
  if(_asym<0) p->shift = 1.0/(1.0+exp(_x0/_s0)*(1+exp(_x1/_s1)));
  else {
    p->shift = 1.0/(1.0+_asym);
    p->x0 = _s0*log((1.0/p->shift-1)/(1+exp(_x1/_s1)));
    p->Bcp = p->p_slope/p->p_strength;
    p->Acp = exp((-p->p_corner-20*log10(20e-6))*p->p_strength);
    p->Ccp = 20*p->p_strength/log(10);
   };
  p->run= runBoltzman;
  p->run2 = runBoltzman2;
return;
};

double runBoltzman(TNonLinear *p,double x)
{
  /*// get the output of the first nonlinear function */
  double xx,out;
  xx = fabs(x);
  if(x>0)
    xx = p->Bcp*log(1+p->Acp*pow(xx,p->Ccp));
  else if(x<0)
    xx = -p->Bcp*log(1+p->Acp*pow(xx,p->Ccp));
  else xx = 0;

  /*// get the output of the second nonlinear function(Boltzman Function) */
  out = 1.0/(1.0+exp(-(xx-p->x0)/p->s0)*(1.0+exp(-(xx-p->x1)/p->s1)))-p->shift;
return(out/(1-p->shift));
};

void runBoltzman2(TNonLinear *p,const double *in,double *out,const int length)
{
  /*// get the output of the first nonlinear function */
  double x,xx,out1;
  int register i;
  for(i = 0; i<length; i++)
  {
 	x = in[i];
  	xx = fabs(x);
      	if(x>0)
	    xx = p->Bcp*log(1+p->Acp*pow(xx,p->Ccp));
      	else if(x<0)
	    	xx = -p->Bcp*log(1+p->Acp*pow(xx,p->Ccp));
      	else xx = 0;
      	/*// get the output of the second nonlinear function(Boltzman Function) */
      	out1 = 1.0/(1.0+exp(-(xx-p->x0)/p->s0)*(1.0+exp(-(xx-p->x1)/p->s1)))-p->shift;
	out[i] = out1/(1-p->shift);
  };
return;
};
/*
 *
 * ################## Implementation of THairCell ###################
 *
 */
double runHairCell(THairCell *p,double x);
void runHairCell2(THairCell *p, const double *in,double *out, const int length);

double runHairCell(THairCell *p,double x)
{ double y;
  y = p->hcnl.run(&(p->hcnl),x);
return(p->hclp.run(&(p->hclp),y));
};

void runHairCell2(THairCell *p, const double *in,double *out, const int length)
{
  p->hcnl.run2(&(p->hcnl),in,out,length);
  p->hclp.run2(&(p->hclp),out,out,length);
};

/* 
 * 
 * ############## Implementation InterFace about AfterOHC_NL ###############
 *
 */
double runAfterOhcNL(TNonLinear* p, double x);
void runAfterOhcNL2(TNonLinear* p, const double *in, double *out,const int length);
void initAfterOhcNL(TNonLinear* p,double taumin,double taumax,double dc,double minR);
TNonLinear* getAfterOhcNL(double taumin,double taumax,double dc,double minR)
{
  TNonLinear* p = (TNonLinear*)malloc(sizeof(TNonLinear));
  initAfterOhcNL(p, taumin, taumax, dc, minR);
  return p;
};

void initAfterOhcNL(TNonLinear* p, double taumin,double taumax,double dc,double minR)
{
  double R;
  
  p->TauMax = taumax;
  p->TauMin = taumin;
  
  R = taumin/taumax;
  if(R<minR) p->minR = 0.5*R;
  else p->minR   = minR;
  p->A = p->minR/(1-p->minR); /* makes x = 0; output = 1; */
  p->dc = dc;
  R = R-p->minR;
  /*/ This is for new nonlinearity */
  p->s0 = -dc/log(R/(1-p->minR));

  p->run = runAfterOhcNL;
  p->run2 = runAfterOhcNL2;
	  
return;
};

double runAfterOhcNL(TNonLinear* p, double x)
{
  /** output of the nonlinearity
      out = TauMax*(minR+(1.0-minR)*exp(-x1/s0));\\
      if the input is zero, the output is TauMax,\\
      if the input is dc, the output is TauMin,\\
      if the input is too large, the output is pushed to TauMax*minR
      if the input is negative, the output is the 2*TauMax-out (keep 
      the control signal continuous)
   */
    double out;
    double x1 = fabs(x);
    out = p->TauMax*(p->minR+(1.0-p->minR)*exp(-x1/p->s0));
return(out);
};

void runAfterOhcNL2(TNonLinear* p, const double *in, double *out,const int length)
{
    int register i;
    double x1;

    for (i=0;i<length;i++){
	x1 = fabs(in[i]);
    	out[i] = p->TauMax*(p->minR+(1.0-p->minR)*exp(-x1/p->s0));
    };
return;
};

/* 
 * 
 * ############## Implementation InterFace about IHCPPI ###############
 *
 */

/*/IHCPPI Nonlinear */
double runIHCPPI(TNonLinear* p, double x)
{
  double PPI;
  double temp;
  temp = p->p2*x;
  if(temp>400)
	  PPI = p->p1*temp;
  else
	  PPI = p->p1 * log(1. + exp(temp)); /*/ soft-rectifier */
return(PPI); 
};

void runIHCPPI2(TNonLinear* p,const double *in,double *out,const int length)
{
  int register i;
  double PPI;
  double temp;
  for(i=0;i<length;i++)
  { temp = p->p2*in[i];
    if(temp<400)
    {    PPI = p->p1 * log(1. + exp(temp)); /*/ soft-rectifier */
    }
    else
    {	    PPI = p->p1*temp;
    }
    out[i] = PPI;
  };
return;
};

/* 
 * 
 * ############## Implementation InterFace about IHC NL ###############
 *
 */

double runIHCNL(TNonLinear * p,double x)
{
    double temp,dtemp,tempA;

    if(x>=0)
    {
      tempA = p->A0;
    }
    else
    {
      dtemp = pow(-x,p->C);
      tempA = -p->A0*(dtemp+p->D)/(3*dtemp+p->D);
    };
    temp = tempA*log(fabs(x)*p->B+1.0);

    return(temp);
};

void runIHCNL2(TNonLinear* p,const double *in,double *out,const int length)
{
  int register i;
  double temp,dtemp,tempA;
  for (i = 0; i<length; i++)
  {
    /*/begin Vsp -> Vihc */
    temp = in[i];
    if(temp>=0)
    {
      tempA = p->A0;
    }
    else
    {
      dtemp = pow(-temp,p->C);
      tempA = -p->A0*(dtemp+p->D)/(3*dtemp+p->D);
    };
    out[i] = tempA*log(fabs(temp)*p->B+1.0);
  };
return;
};

