#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "synapse.h"
#include "filters.h"

/*/interface to all the code */
int runSynapse(Tsynapse *pthis, const double *in, double *out, int length)
{
  int error = 0;
  initSynapse(pthis);
  ihc_nl(pthis,in,out,length);	
  runsyn_dynamic(pthis,in,out,length);
return(error);
}
/*/function [V,PPI] = ihcmodel(p,Fs)
//% Just the IHC part of ANmod2 - use this after gammatone filter.
//!!!!! This function should be called after initSynapse(); */
int ihc_nl(Tsynapse *pthis, const double *in, double *out, const int length)
{
  int error = 0;
  static double A0 = 0.1;
  static double B = 2000.;
  static double C = 1.74;
  static double D = 6.87e-9;
  register int i;
  double temp,tempA,dtemp;
  double p1,p2,Vihc,PPI,pst,psl;
  double spont,Kcf,Pimax;

  TLowPass ihclowpass;
  
  double cf = pthis->cf;
  for (i = 0; i<length; i++)
  {
    /*/begin Vsp -> Vihc */
    temp = in[i];
    if(temp>=0)
    {
      tempA = A0;
    }
    else
    {
      dtemp = pow(-temp,C);
      tempA = -A0*(dtemp+D)/(3*dtemp+D);
    };
    out[i] = tempA*log(fabs(temp)*B+1.0);
  };

  /*/ Low Pass Filter Goes here !!!!!!!!!!!!!!!!!!!!! */
  initLowPass(&ihclowpass,pthis->tdres,4500.0,1.0,7);
  ihclowpass.run2(&ihclowpass,out,out,length);

  /*/ begin the Vinc -> PPI */
  Kcf = 2.0+1.3*log10(cf/1000); /*/ From M. G. Heinz */
  if(Kcf<1.5) Kcf = 1.5;
  /*/ Important !!! This is not shown in the paper
  // For Prest is so small compare to the other part */
  pthis->Vsat = pthis->Pimax*Kcf*60.0*(1+pthis->spont)/(6+pthis->spont)+pthis->Prest;

  temp = log(2)*pthis->Vsat/pthis->Prest;
  if(temp<400) pst = log(exp(temp)-1);
  else pst = temp;
  psl = pthis->Prest*pst/log(2);
  p2 = pst;
  p1 = psl/pst;
  for(i=0;i<length;i++)
  { 
    Vihc = out[i];
    PPI = p1 * log(1. + exp(p2 * Vihc)); /*/ soft-rectifier */
    out[i] = PPI;
  };

return(error);
};

int initSynapse(Tsynapse *pthis)
{
  int error = 0;
  double PTS,Ass,Aon,Ar_over_Ast,Ar,Ast;
  double Pimax,spont;
  double Prest;
  double CG,gamma1,gamma2,tauR,tauST,kappa1,kappa2,VI0,VI1,VI;
  double alpha,beta,theta1,theta2,theta3;
  double PL,PG,VL,Cirest,CLrest;

  double CLlast,CIlast,PPIlast;
  double tdres,CInow,CLnow;
  register int i;

  pthis->run = run1syn_dynamic;
  pthis->run2 = runsyn_dynamic;
  tdres = pthis->tdres;
  /*/begin the Synapse dynamic */
  PTS = pthis->PTS;
  Ass = pthis->Ass; /* For Human, from M. G. Heinz */
  Aon = PTS * Ass;
  Ar_over_Ast = pthis->Ar_over_Ast;
  Ar = (Aon - Ass) * (Ar_over_Ast)/(1. + Ar_over_Ast);  /*/%???? Ar on both sides */
  Ast = Aon - Ass - Ar;
  Pimax = pthis->Pimax;
  spont= pthis->spont; /*/50 in default */
  Prest = Pimax * spont/Aon;
  CG = spont * (Aon - spont)/(Aon * Prest*(1. - spont/Ass));
  gamma1 = CG/spont;
  gamma2 = CG/Ass;
  tauR= pthis->tauR;
  tauST= pthis->tauST;
  kappa1 = -( 1. /tauR);
  kappa2 = -( 1. /tauST);

  VI0 = (1.-Pimax/Prest)/(gamma1*(Ar*(kappa1-kappa2)/CG/Pimax+kappa2/Prest/gamma1-kappa2/Pimax/gamma2));
  VI1 = (1.-Pimax/Prest)/(gamma1*(Ast*(kappa2-kappa1)/CG/Pimax+kappa1/Prest/gamma1-kappa1/Pimax/gamma2));
  VI = (VI0 + VI1)/2.;

  alpha = gamma2/(kappa1 * kappa2);
  beta = -(kappa1 + kappa2) * alpha;
  theta1 = alpha * Pimax/VI;
  theta2 = VI/Pimax;
  theta3 = gamma2 - 1./Pimax;
  PL = (((beta - theta2 * theta3)/theta1) - 1.)*Pimax;
  PG = 1./(theta3 - 1./PL);
  VL = theta1 * PL * PG;
  Cirest = spont/Prest;
  CLrest = Cirest * (Prest + PL)/PL;
  pthis->Prest = Prest;
  pthis->CIrest = Cirest;
  pthis->CLrest = CLrest;
  pthis->VI = VI;
  pthis->VL = VL;
  pthis->PL = PL;
  pthis->PG = PG;
  pthis->CG = CG;
  
  pthis->PPIlast = Prest;
  pthis->CLlast = CLrest;
  pthis->CIlast = Cirest;  
return(error);
};

void runsyn_dynamic(Tsynapse *pthis, const double *in, double *out, int length)
{
/* !!!!!!!!!!
 * The double *in and double *out could be the same pointer, 
 * SO be careful about this
 */	
  int error;
  int register i;
  double PPIlast,PL,PG,CIlast,CLlast,CG,VI,VL;
  double tdres;
  double CInow,CLnow;

  error = 0;
  tdres = pthis->tdres;
  PL = pthis->PL;
  PG = pthis->PG;
  CG = pthis->CG;
  VI = pthis->VI;
  VL = pthis->VL;
  CIlast = pthis->CIlast;
  CLlast = pthis->CLlast;
  PPIlast = pthis->PPIlast;

  for(i = 0; i<length;i++){
    CInow = CIlast + (tdres/VI)*((-PPIlast*CIlast)+PL*(CLlast - CIlast));
    CLnow = CLlast + (tdres/VL)*(-PL*(CLlast-CIlast)+PG*(CG - CLlast));
    PPIlast = in[i];
    CIlast = CInow;
    CLlast = CLnow;
    out[i] = CInow*PPIlast;
  };

  pthis->CIlast = CIlast;
  pthis->CLlast = CLlast;
  pthis->PPIlast = pthis->PPIlast;
return;
};

double run1syn_dynamic(Tsynapse *pthis, double x)
{
	double out;
	runsyn_dynamic(pthis,&x,&out,1);
return out;
};

