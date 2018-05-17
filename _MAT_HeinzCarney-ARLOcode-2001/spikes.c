#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

#include "spikes.h"

int SGmodel(double tdres, const double *sout, double** sptimeptr, const int nstim, const int nrep)
{
  long i,j,isp;
  int outspike;
  long nspikes = 0;
  double *sptime;
  TSpikeGenerator p;
  long maxspikes;

  maxspikes = 5000;
  /*sptime = (double*)realloc(NULL,sizeof(double)*maxspikes);*/
  sptime = *sptimeptr;
  if(sptime==NULL) {exit(1);}
  /* sout[] contains prob of spike vs. time - run through it nrep times to look for spikes */
  isp = 0;
  sptime[0] = 0.0; /* start out with a spike at t=0 on 1st rep */
  initspikegenerator(&p,tdres);
  initSG2(&p,sout[0]); //initialize the spike generator

  for(i = 0; i < nrep; i++)
  {
      for( j = 0; j < nstim; j++)
	{
	  if((*(p.run))(&p,sout[j])==1)
	    {
	      sptime[isp] = p.rtime;  /* leave sptime in sec */
	      isp++;
/*	      if(isp>=maxspikes) { 
	        maxspikes += 5000;
	        sptime = (double*)realloc(sptime,sizeof(double)*maxspikes);  
	        if(sptime==NULL) {exit(1);} 
	      };
*/	    }
	}
      initSG2(&p,-1);
      nspikes = isp;
    };
  *sptimeptr = sptime;
  return nspikes;
};	

void initspikegenerator(TSpikeGenerator *p, double tdres)
{
  time_t seed;
  seed = time(NULL);
  srand(seed);
  
  p->c0 = 0.5;
  p->s0 = 0.001;
  p->c1 = 0.5;
  p->s1 = 0.0125;
  p->dead = 0.00075;
  p->tdres = tdres;
  p->rtime = 0.0;
  p->rsptime = 0.0;
  p->run = runSpikes;
};

void initSG2(TSpikeGenerator *p, double spont)
{
/** if the spont < 0 , wrap the time, and rsptim */
  if(spont>0)
	  p->rsptime = p->rtime - rand()/(double)(RAND_MAX)*1/spont;
  else 
       {  p->rsptime = p->rsptime-p->rtime; p->rtime = 0.0; };
};

int runSpikes(TSpikeGenerator *p, const double x)
{
/**
    This function generate the spikes according synapse output(x=sout), also including the\\
    refractoriness
 */
  double rint,prob,randprob;
  double dtmp;
  int out = 0;
  dtmp = 0;
  p->rtime += p->tdres; /* running time */
  /* interval from last spike, including 'wrap around' between trials */
  rint = p->rtime - p->rsptime;
  if(rint > p->dead )
  {
	prob = x*p->tdres*
		(1.0-( p->c0*exp(-(rint - p->dead)/p->s0) + p->c1*exp(-(rint - p->dead)/p->s1)));
	randprob = rand()/(double)(RAND_MAX);
	if( prob > randprob)
	{
		p->rsptime = p->rtime;
		out = 1;
	};
  };
  printf("\n Out %d",out);
return(out);
};

