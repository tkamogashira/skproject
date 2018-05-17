#ifndef _CMPA_H
#define _CMPA_H
#include "filters.h"
#include "hc.h"
#include "synapse.h"
#include "complex.h"

#ifndef TWOPI
#define TWOPI 6.2831853
#endif
#define Broad_ALL		0x80
#define Linear_ALL		0x40
#define NonLinear_ALL		0x20

#define FeedBack_NL		(NonLinear_ALL|0x01)
#define FeedForward_NL		(NonLinear_ALL|0x02)
#define Broad_Linear		(Broad_ALL|Linear_ALL|0x01)
#define Sharp_Linear		(Linear_ALL|0x02)
#define Broad_Linear_High	(Broad_ALL|Linear_ALL|0x03)

/*/############################################################################## */
typedef struct __AuditoryNerve TAuditoryNerve;
typedef struct __BasilarMembrane TBasilarMembrane;
double cochlea_f2x(int species,double f);
double cochlea_x2f(int species,double x);

double runAN(TAuditoryNerve* p,double x);
void runAN2(TAuditoryNerve *p, const double *in, double *out, const int length);

void initAuditoryNerve(TAuditoryNerve *p,int model, int species, double tdres, double cf, double spont);
void initBasilarMembrane(TBasilarMembrane* bm,int model, int species, double tdres, double cf);

/*/############################################################################## */

/** The class the define the basic structure of the time-varing filter
    
    the class consists of following components: \n
    1. tuning filter(bmfilter), the tau is controlled by the control path\n
    2. wideband pass filter(wbfilter)\n
    3. outer hair cell model(ohc)\n
    4. nonlinear function after the outer haircell(afterohc)
 */
struct __BasilarMembrane{ /* class of basilar membrane */

  double (*run)(TBasilarMembrane *p, double x);
  void (*run2)(TBasilarMembrane *p, const double *in, double *out, const int length);

  int bmmodel; /* determine if the bm is broad_linear, sharp_linear or other */
  double tdres;
  int bmorder,wborder;

  double tau,TauMax,TauMin;
  double TauWB,TauWBMin;
  double A,B; 
  /* --------Model -------------- */
  TGammaTone bmfilter; /*/NonLinear Filter */
  TGammaTone gfagain; /*/Linear Filter */
  TGammaTone wbfilter; /*/Control Path filter */
  THairCell ohc;
  TNonLinear afterohc;
};

/** Class of the auditory nerve fiber, this is a complete model of the fiber

    The class consists of all the parts of the auditory nerve fiber\n
    1. time-varying tuning filter with control path: TBasilarMembrane(bm, 3rd order)\n
    2. the gammatone filter after the 3rd-order nonlinear filter(gffilter)\n
    3. inner hair cell model(ihc)\n
    4. synapse model, from Westman,1986(syn)\n
    5. spike generator, from Carney,1993(sg)
 */
struct __AuditoryNerve{
/*/ Run Function */
  double (*run)(TAuditoryNerve *p, double x);
  void  (*run2)(TAuditoryNerve *p, const double *in,  double *out,  const int length);
/*/ Model Structor */
  TBasilarMembrane bm;
  THairCell ihc;
  TNonLinear ihcppi; /*/From ihc->ppi */
  Tsynapse syn;
/*/  TSpikeGenerator sg; */
/*/ Model Parameters */
  double tdres,cf,spont;
  int species,model;
  /* This parameter indicates if we are using sout only or spikes */
  int ifspike;
};

#endif





