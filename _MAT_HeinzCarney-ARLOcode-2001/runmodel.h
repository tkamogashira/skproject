/*
 * Run Time Utility
 * 
 */
#ifndef _runmodel_h
#define _runmodel_h

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

typedef struct _Tstim T_stim;

struct _Tstim{
  /*/General information about the model */
  double tdres, cf, spont;
  int species, model;
  /*/About filter banks */
  int banks; /*/for filterbank */
  double delx;  /*/for filter bank */
  double cfhi,cflo,cfinc;
  /*/About stimulus */
  int stim; /*/stimulus type */
  char wavefile[100]; /*/get wave from the file */
  double reptim; /*/repetition time */
  int trials; /*/for spike generator */

  int nstim,nrep; /*/runtime usage */
  double *buf;
};

/* get parameters from the command line */
int parsecommandline(T_stim *ptm,int argc,char *argv[]);
#endif









