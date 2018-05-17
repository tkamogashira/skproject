#ifndef _synapse_h
#define _synapse_h
typedef struct __tsynapse Tsynapse;
struct __tsynapse{
  double (*run)(Tsynapse *p,double x);
  void (*run2)(Tsynapse *p, const double *in, double *out, const int length);
  double cf,tdres;
  double spont;  
  double PTS, Ass, Ar_over_Ast, Pimax, tauR, tauST;
  double Prest,PPIlast,PL,PG,CIrest,CIlast,CLrest,CLlast,CG,VI,VL;

  double Vsat;
};
int runSynapse(Tsynapse *pthis, const double *in, double *out, const int length);
void runsyn_dynamic(Tsynapse *pthis, const double *in, double *out, const int length);
double run1syn_dynamic(Tsynapse *pthis, double x);
int initSynapse(Tsynapse *pthis);
#endif


