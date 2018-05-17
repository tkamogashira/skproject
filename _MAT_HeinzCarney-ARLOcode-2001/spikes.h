#ifndef _SPIKES_H
#define _SPIKES_H

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef struct __tspikegenerator TSpikeGenerator;
struct __tspikegenerator {
  int (*run)(TSpikeGenerator *p, const double x);
  double c0,s0,c1,s1;
  double dead;
  double rtime, rsptime;
  double tdres;
};
int runSpikes(TSpikeGenerator *p, const double x);
void initspikegenerator(TSpikeGenerator *p, double tdres);
void initSG2(TSpikeGenerator *p, double spont);
int SGmodel(double tdres, const double *sout, double** sptimeptr, const int nstim, const int nrep);

#endif
