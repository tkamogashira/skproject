// To do : 1. change the option that about # of model
//         2. add the option that can generate the synapse output / spike rate
//         3. check the parameter for CAT/HUMAN, and maybe more
//         4. Species can be specified as others as the same in the paper

 /* Model numbers as used in ARLO Heinz et al., Fig. 4 */
//  model == 1 bmmodel = FeedForward_NL;
//  model == 2 bmmodel = FeedBack_NL;
//  model == 3 bmmodel = Sharp_Linear;
//  model == 4 bmmodel = Broad_Linear;
//  model == 5 bmmodel = Broad_Linear_High;

#include "cmpa.h"
#include "hc.h"
#include "synapse.h"
#include "complex.h"
#include "filters.h"
#include <stdlib.h>
double Get_tau(int species, double cf, int order, double* taumax, double* taumin, double* taurange);
double erbGM(double);
double cochlea_f2x(int species,double f);
double cochlea_x2f(int species,double x);

void runAN2(TAuditoryNerve *p,const double *in,double *out,const int length);
double runBasilarMembrane(TBasilarMembrane *bm, double x);
void run2BasilarMembrane(TBasilarMembrane *bm, const double *in, double *out, const int length);
/*
 * different species have different parameters !!!!
 * 1. Get_Tau(...)
 * 2. Synapse setup in this function
 * 3. IHC low pass filter cutoff freq
 * 
 * */
void initAuditoryNerve(TAuditoryNerve *p,int model, int species, double tdres, double cf, double spont)
{ /* default */
  Tsynapse *syn;

  double Kcf,temp;
  double p1,p2,pst,psl;

  p->run = runAN;
  p->run2 = runAN2;

  syn = &(p->syn);

  p->model = model;
  p->species = species;
  p->cf = cf;
  p->spont = spont;
  p->tdres = tdres;

  p->run = runAN;
  p->run2 = runAN2;
  /*
   * Init the basilar membrane
   * */
  initBasilarMembrane(&(p->bm),model,species,tdres,cf);

  /* Now add support for different species */

  /* This line outputs the appropriate sout rate based on whether or not spikes are being generated (with refractoriness) */
  if(p->ifspike==1) syn->Ass = 350;
  else syn->Ass = 130; /* borrow this for Mike G. Heinz */
  switch(species)
  { 
	  case 1 : /* Cat - low CFs only (Carney '93) */
	  case 9 : /* Cat - all CFs "Universal"  (Zhang et al 2001) */
		  /*
		   * Init the synapse
		   * */
		  syn->tdres = tdres;
		  syn->cf = cf;
		  syn->spont = spont;
		  syn->Pimax = 0.6;
		  syn->PTS = 1+9*spont/(9+spont);
		  syn->Ar_over_Ast = 6.0;
		  syn->tauR = 0.002;
		  syn->tauST = 0.060;
		  initSynapse(syn);  /*This function calcuate all other parameters as described in the appendix*/

		  /*
		   * Init the ihcppi rectify function and parameters
		   * !!!!Use the result from initSynapse(syn)
		   *
		   * */
 	  	  Kcf = 2.0+3.0*log10(cf/1000);
		  if(Kcf<1.5) Kcf = 1.5;
		  syn->Vsat = syn->Pimax*Kcf*20.0*(1+spont)/(5+spont);
		  /* Important !!! The original code seems use the following equation!!!
		     This is not shown in the paper but Prest is very small compare to the other part < 0.01*Vsat
		     and the results is the same
		   */
		  /* syn->Vsat = syn->Pimax*Kcf*20.0*(1+spont)/(5+spont)+syn->Prest; */
		  
		  break;
	  case 0 :
	  default: /* Human */
		  /*
		   * Init the synapse
		   * */
		  syn->tdres = tdres;
		  syn->cf = cf;
		  syn->spont = spont;
		  syn->Pimax = 0.6;
		  syn->PTS = 1+9*spont/(9+spont);   /* Peak to Steady State Ratio, characteristic of PSTH */
		  syn->Ar_over_Ast = 6.0;
		  syn->tauR = 0.002;
		  syn->tauST = 0.060;
		  initSynapse(syn);  /*This function calcuate all other parameters as described in the appendix*/

		  /*
		   * Init the ihcppi rectify function and parameters
		   * !!!!Use the result from initSynapse(syn)
		   *
		   * */
            	  Kcf = 2.0+1.3*log10(cf/1000); /*/ From M. G. Heinz */
		  if(Kcf<1.5) Kcf = 1.5;
		  syn->Vsat = syn->Pimax*Kcf*60.0*(1+spont)/(6+spont);
		  /* Important !!! The original code seems use the following equation!!!
		     This is not shown in the paper but Prest is very small compare to the other part < 0.01*Vsat
		     and the results is the same, so we use the upper equation
		   */
		  /* syn->Vsat = syn->Pimax*Kcf*60.0*(1+spont)/(6+spont)+syn->Prest; */
		  
		  break;
  };
  temp = log(2)*syn->Vsat/syn->Prest;
  if(temp<400) pst = log(exp(temp)-1);
  else pst = temp;
  psl = syn->Prest*pst/log(2);
  p2 = pst;
  p1 = psl/pst;

#ifdef DEBUG
  printf("\ninitSyanpse : p1=%f; p2=%f",p1,p2);
#endif
  
  p->ihcppi.psl = psl;
  p->ihcppi.pst = pst;
  p->ihcppi.p1 = p1;
  p->ihcppi.p2 = p2;
  p->ihcppi.run = runIHCPPI;	/*These are functions used to get ihcppi output */
  p->ihcppi.run2 = runIHCPPI2;  /*Defined in hc.c, hc.h */

  /* 
   * Init Inner Hair Cell Model
   */
  /* For Human Only !!!!!!! Hair Cell low pass filter (tdres,cutoff,gain,order) */
  switch(species)
  {
	case 0:
	default: /* Human */
	  initLowPass(&(p->ihc.hclp),tdres,4500.0,1.0,7);
	  break;
	case 1:  /* Cat, this version use the Laurel's revcor data to determine taumin, taumax - only good for low freqs*/
	case 9:  /* Also for universal CAT; as in JASA 2001 Zhang et al. - good for all CFs */
	  initLowPass(&(p->ihc.hclp),tdres,3800.0,1.0,7);
	  break;
  };
  p->ihc.run = runHairCell;
  p->ihc.run2 = runHairCell2;
  p->ihc.hcnl.A0 = 0.1;  /* Inner Hair Cell Nonlinear Function */
  p->ihc.hcnl.B = 2000.;
  p->ihc.hcnl.C = 1.74;
  p->ihc.hcnl.D = 6.87e-9;
  p->ihc.hcnl.run = runIHCNL;
  p->ihc.hcnl.run2 = runIHCNL2;
return;
}

double runAN(TAuditoryNerve *p,double x)
{ 
  double bmout,ihcout,ppiout,sout;
  bmout = p->bm.run(&(p->bm),x);
  ihcout = p->ihc.run(&(p->ihc),bmout);
  ppiout = p->ihcppi.run(&(p->ihcppi),ihcout);
  sout = p->syn.run(&(p->syn),ppiout);
return(sout);  
}

void runAN2(TAuditoryNerve *p,const double *in,double *out,const int length)
{
  p->bm.run2(&(p->bm),in,out,length);
  p->ihc.run2(&(p->ihc),out,out,length);
  p->ihcppi.run2(&(p->ihcppi),out,out,length);
  p->syn.run2(&(p->syn),out,out,length);
return;
}

/* User Get_Tau, initGammaTone, initBoltzman*/
void initBasilarMembrane(TBasilarMembrane* bm,int model, int species, double tdres, double cf)
{ /*
   *
   * ##### Get Basilar Membrane ########
   * 1. Get a structure of BasilarMembrane
   * 2. Specify wide band filter in the BasilarMembrane Model 
   *    //WB filter not used for all model versions, but it's computed here anyway
   * 3. Specify the OHC model in the control path
   *    3.2 Specify the NL function used in the OHC
   * 4. Specify the AfterOHC NL in the control path
   * */
 
  int bmmodel;
  double taumax,taumin,taurange; /* general */
  double x, centerfreq,tauwb,tauwbmin,dtmp,wb_gain; /* for wb */
  double absdb,ohcasym; /* for ohc */
  double dc,R,minR; /* for afterohc */
  TNonLinear *p;

   /* Model numbers as used in ARLO Heinz et al., Fig. 4 */
  if(model == 1) bmmodel = FeedForward_NL;
  else if(model == 2) bmmodel = FeedBack_NL;
  else if(model == 3) bmmodel = Sharp_Linear;
  else if(model == 4) bmmodel = Broad_Linear;
  else if(model == 5) bmmodel = Broad_Linear_High;
  bm->bmmodel = bmmodel;
  bm->tdres = tdres;

  /*
   *  Determine taumax,taumin,order here
   */
  bm->run = runBasilarMembrane;
  bm->run2 = run2BasilarMembrane;

  bm->bmorder = 3;
  Get_tau(species,cf,bm->bmorder,&taumax,&taumin,&taurange);

  bm->TauMax = taumax;
  bm->TauMin = taumin;
  if(bm->bmmodel&Broad_ALL) 
    bm->tau = taumin;
  else
    bm->tau = taumax;
  
  initGammaTone(&(bm->bmfilter),tdres,cf,bm->tau,1.0,bm->bmorder);
  initGammaTone(&(bm->gfagain),tdres,cf,taumin,1.0,1);
  /*
   * Get Wbfilter parameters
   */
  x = cochlea_f2x(species,cf);
  centerfreq = cochlea_x2f(species,x+1.2); /* shift the center freq Qing use 1.1 shift */
  bm->wborder = 3;
  tauwb = taumin+0.2*(taumax-taumin);
  tauwbmin = tauwb/taumax*taumin;
  dtmp = tauwb*TWOPI*(centerfreq-cf);
  wb_gain = pow((1+dtmp*dtmp), bm->wborder/2.0);

  bm->TauWB = tauwb;
  bm->TauWBMin = tauwbmin;
  initGammaTone(&(bm->wbfilter), tdres, centerfreq, tauwb, wb_gain, bm->wborder);
  bm->A=(tauwb/taumax-tauwbmin/taumin)/(taumax-taumin);
  bm->B=(taumin*taumin*tauwb-taumax*taumax*tauwbmin)/(taumax*taumin*(taumax-taumin));

  /*
   * Init OHC model
   */
  absdb = 20; /* The value that the BM starts compression */
  initLowPass(&(bm->ohc.hclp), tdres, 800.0, 1.0, 3); /* This is now use in both Human & Cat MODEL */
  /*/ parameter into boltzman is corner,slope,strength,x0,s0,x1,s1,asym
  // The corner determines the level that BM have compressive nonlinearity */
  ohcasym = 7.0;
  /*/set OHC Nonlinearity as boltzman function combination */
  init_boltzman(&(bm->ohc.hcnl),absdb-12,0.22,0.08,5,12,5,5,ohcasym);
  bm->ohc.run = runHairCell;
  bm->ohc.run2 = runHairCell2;
  
  /*
   * Init AfterOHC model
   */
  p = &(bm->afterohc);
  dc = (ohcasym-1)/(ohcasym+1.0)/2.0;
  dc-=0.05;
  minR = 0.05;
  p->TauMax = taumax;
  p->TauMin = taumin;
  R = taumin/taumax;
  if(R<minR) p->minR = 0.5*R;
  else p->minR   = minR;
  p->A = p->minR/(1-p->minR); /* makes x = 0; output = 1; */
  p->dc = dc;
  R = R-p->minR;
  /* This is for new nonlinearity */
  p->s0 = -dc/log(R/(1-p->minR));
  p->run = runAfterOhcNL;
  p->run2 = runAfterOhcNL2;
return;
}

/** pass the signal through the tuning filter.
    using different model
    Sharp_Linear | Broad_Linear | Broad_Linear_High | FeedBack_NL | FeedForward_NL
*/
double runBasilarMembrane(TBasilarMembrane *bm, double x){
  double out;
  const int length = 1;
  run2BasilarMembrane(bm, &x, &out, length);
return(out);
}

void run2BasilarMembrane(TBasilarMembrane *bm, const double *in, double *out, const int length)
{
  register int i;
  double wb_gain,dtmp,taunow;
  double wbout,ohcout;
  double x, x1,out1;

  for(i=0; i<length; i++)
  {
	  x = in[i];
	  x1 = bm->bmfilter.run(&(bm->bmfilter),x); /*/ pass the signal through the tuning filter */
	  switch(bm->bmmodel){
             default:
             case Sharp_Linear: /* / if linear model, needn't get the control signal */
	     case Broad_Linear:
		out1 = x1; break;
	     case Broad_Linear_High: /* /adjust the gain of the tuning filter */
              	out1 = x1*pow((bm->TauMin/bm->TauMax),bm->bmfilter.Order);
	              break;
	     case FeedBack_NL: /* /get the output of the tuning filter as the control signal */
		wbout = x1;
		
		ohcout = bm->ohc.run(&(bm->ohc),wbout); /*/ pass the control signal through OHC model */
		/*/ pass the control signal through nonliearity after OHC */
		bm->tau = bm->afterohc.run(&(bm->afterohc),ohcout);     
		/*/ set the tau of the tuning filter */
                bm->bmfilter.settau(&(bm->bmfilter),bm->tau);     
		/*  Gain Control of the tuning filter */
              	out1 = pow((bm->tau/bm->TauMax),bm->bmfilter.Order)*x1;  
	              break;
	     case FeedForward_NL:
		/*/get the output of the wide-band pass as the control signal */
		wbout = bm->wbfilter.run(&(bm->wbfilter),x);
		/*/ scale the tau for wide band filter in control path */
		taunow = bm->A*bm->tau*bm->tau-bm->B*bm->tau;

		bm->wbfilter.settau(&(bm->wbfilter),taunow);  /*/set the tau of the wide-band filter*/
		/*/ normalize the gain of the wideband pass filter as 0dB at CF */
		dtmp = taunow*TWOPI*(bm->wbfilter.F_shift-bm->bmfilter.F_shift);
		wb_gain = pow((1+dtmp*dtmp), bm->wbfilter.Order/2.0);
		bm->wbfilter.gain=wb_gain;
		
		ohcout = bm->ohc.run(&(bm->ohc),wbout); /*/ pass the control signal through OHC model*/
	       	/*/ pass the control signal through nonliearity after OHC */
		bm->tau = bm->afterohc.run(&(bm->afterohc),ohcout);
	   	/*/ set the tau of the tuning filter */
	        bm->bmfilter.settau(&(bm->bmfilter),bm->tau);
	      	/*/ Gain Control of the tuning filter */
              	out1 = pow((bm->tau/bm->TauMax),bm->bmfilter.Order)*x1;
              	break;
	  };
	  out[i] = out1;
  };
  bm->gfagain.run2(&(bm->gfagain),out,out,length);

  return;
}


/* ********************************************************************************************
 * * Get TauMax, TauMin for the tuning filter. The TauMax is determined by the bandwidth/Q10
    of the tuning filter at low level. The TauMin is determined by the gain change between high
    and low level
    Also the calculation is different for different species
 */
double Get_tau(int species, double cf,int order, double* _taumax,double* _taumin,double* _taurange)
{
  double taumin,taumax,taurange;
  double ss0,cc0,ss1,cc1;
  double Q10,bw,gain,ratio;
  double xcf, x1000;
  gain = 20+42*log10(cf/1e3);                /*/ estimate compression gain of the filter */
  if(gain>70) gain = 70;
  if(gain<15) gain = 15;
  ratio = pow(10,(-gain/(20.0*order)));      /*/ ratio of TauMin/TauMax according to the gain, order */

  /*/ Calculate the TauMax according to different species */
  switch(species)
    {
    case 1:
      /* Cat parameters: Tau0 vs. CF (from Carney & Yin 88) - only good for low CFs*/
      /* Note: Tau0 is gammatone time constant for 'high' levels (80 dB rms) */
      /* parameters for cat Tau0 vs. CF */
      xcf = cochlea_f2x(species,cf);     /* position of cf unit; from Liberman's map */
      x1000 = cochlea_f2x(species,1000); /* position for 1 Khz */
      ss0 = 6.; cc0 = 1.1; ss1 = 2.2; cc1 = 1.1;
      taumin = ( cc0 * exp( -xcf / ss0) + cc1 * exp( -xcf /ss1) ) * 1e-3;  /* in sec */
      taurange = taumin * xcf/x1000; 
      taumax = taumin+taurange;
      break;
    case 0:
      /* Human Parameters: From Mike Heinz: */
      /* Bandwidths now are based on Glasberg and Moore's (1990) ERB=f(CF,level) equations  */
      taumax =  1./(TWOPI*1.019*erbGM(cf));
      break;
    case 9:
      /* Universal species from data fitting : From Xuedong Zhang,Ian (JASA 2001) */
      /* the Q10 determine the taumax(bandwidths at low level) Based on Cat*/
      Q10 = pow(10,0.4708*log10(cf/1e3)+0.4664);
      bw = cf/Q10;
      taumax = 2.0/(TWOPI*bw);
    }; /*/end of switch */
  taumin =  taumax*ratio;
  taurange = taumax-taumin;
  *_taumin = taumin;
  *_taumax = taumax;
  *_taurange = taurange;
  return 0;
}

/*/ --------------------------------------------------------------------------------
 ** Calculate the location on Basilar Membrane from best frequency
*/
double cochlea_f2x(int species,double f)
{
  double x;
  switch(species)
    {
    case 0: /*/human */
      x=(1.0/0.06)*log10((f/165.4)+0.88);
      break;
    default:
    case 1: /*/cat */
      x = 11.9 * log10(0.80 + f / 456.0);
      break;
    };
   return(x);
}
/* --------------------------------------------------------------------------------
 ** Calculate the best frequency from the location on basilar membrane 
 */
double cochlea_x2f(int species,double x)
{
  double f;
  switch(species)
    {
    case 0: /*/human
      //      if((x>35)||(x<0)) error("BM distance out of human range, [in cochlea_x2f(...)]"); */
      f=165.4*(pow(10,(0.06*x))-0.88);
      break;
    default:
    case 1: /*/cat */
      f = 456.0*(pow(10,x/11.9)-0.80);
      break;
    };
  return(f);
}
/*/ --------------------------------------------------------------------------------
 ** Calculate the erb at 65dB */
double erb51_65(double CF)
{
  double erb1000,erbCf,erb;
  erb1000=24.7*(4.37*1000/1000+1);
  erbCf=24.7*(4.37*CF/1000+1);
  erb=(0.5*erbCf)/(1-(0.38/4000)*erb1000*(65+10*log10(erbCf)-51))+.5*erbCf;
  return(erb);
}
/*/ --------------------------------------------------------------------------------
 ** Calculate the erb using GM's method */
double erbGM(double CF)
{
  double erbCf;
  erbCf=(1/1.2)*24.7*(4.37*CF/1000+1);
  return(erbCf);
}

/*/ ---------------------------------------------------------------------------
 ** Calculate the delay(basilar membrane, synapse for cat*/
double delay_cat(double cf)
{
  /* DELAY THE WAVEFORM (delay buf1, tauf, ihc for display purposes)  */
  /* Note: Latency vs. CF for click responses is available for Cat only (not human) */ 
  /* Use original fit for Tl (latency vs. CF in msec) from Carney & Yin '88 
     and then correct by .75 cycles to go from PEAK delay to ONSET delay */
  double A0 = 8.13; /* from Carney and Yin '88 */
  double A1 = 6.49;
  double x = cochlea_f2x(1,cf); /*/cat mapping */
  double delay = A0 * exp( -x/A1 ) * 1e-3 - 1.0/cf;
return(delay);
}

