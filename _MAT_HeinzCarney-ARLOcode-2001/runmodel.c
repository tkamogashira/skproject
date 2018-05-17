#include "runmodel.h"
#include "cmpa.h"
#include "complex.h"
#include "filters.h"

int an_arlo(double tdres, double cf, double spont, int model, int species, int ifspike,
				   const double *in, double *out, int length)
{
	TAuditoryNerve anf;
	anf.ifspike = ifspike;
	initAuditoryNerve(&anf, model, species,tdres,cf,spont);
	runAN2(&anf, in, out, length);
return(0);	
};

/*/ ---------------------------------------------------------------- */

int parsecommandline(T_stim *ptm,int argc, char* argv[])
{
  int i;
  int needhelp = 0;
  char *para;
  i = 1;
  if(argc ==1 ) needhelp = 1;
  while(i<argc)
  { para = argv[i];
    if((*para)=='-')
      { para++;
	if(strcmp(para,"tdres")==0)
	    ptm->tdres = (double)(atof(argv[++i]));
	else if(strcmp(para,"cf")==0)
	    ptm->cf = (double)(atof(argv[++i]));
	else if(strcmp(para,"spont")==0)
	    ptm->spont = (double)(atof(argv[++i]));
	else if(strcmp(para,"species")==0)
	    ptm->species = atoi(argv[++i]);
	else if(strcmp(para,"model")==0)
	    ptm->model = atoi(argv[++i]);
	else if(strcmp(para,"fibers")==0)
	    ptm->banks = atoi(argv[++i]);
	else if(strcmp(para,"delx")==0)
	  ptm->delx = (double)(atof(argv[++i]));
	else if(strcmp(para,"cfhi")==0)
	  ptm->cfhi = (double)(atof(argv[++i]));
	else if(strcmp(para,"cflo")==0)
	  ptm->cflo = (double)(atof(argv[++i]));
	else if(strcmp(para,"reptim")==0)
	    ptm->reptim = (double)(atof(argv[++i]));
	else if(strcmp(para,"trials")==0)
	  ptm->nrep = atoi(argv[++i]);
	else if(strcmp(para,"wavefile")==0)
	  {
	    ptm->stim = 11;
	    strcpy(ptm->wavefile,argv[++i]); 
	  }
	else if(strcmp(para,"help")==0)
	  needhelp = 1;
	else
	  { printf("\nUnkown parameters --> %s",para); needhelp = 1; break; };
      }
    else { printf("\nUnkown parameters --> %s",para); needhelp = 1; break; };
    i++;
  };
  if(needhelp==1)
    {
      printf("\n This program accept following parameters:\n");

      printf("\n -species #(0) --> input the species(0=human,1=cat(LF only,JASA '93),9=cat (all CFs, JASA 2001))");
      printf("\n -model #(1)   --> anmodel(1:Nonlinear_w/comp&supp,");
      printf("\n                           2:Nonlinear_w/comp, w/o supp,");
      printf("\n                           3:linear sharp,");
      printf("\n                           4:linear broad, low threshold)");
      printf("\n                           5:linear broad, high threshold");
      printf("\n -cf #(1000)   --> character frequency of the an tested(center cf for filter banks)");
      printf("\n -spont #(50)  --> spontaneous rate of the fier");
      printf("\n -tdres #(2e-6)--> time domain resolution(second)");

      printf("\n\nFor filter banks >>>>>>>>");
      printf("\n -fibers #(1) --># of filters, use this option with cf,cflo,cfhi,delx");
      printf("\n -cfhi #(-1)   --> highest cf to go(specify cfhi,cflo will recalculate cf&delx");
      printf("\n -cflo #(-1)   --> lowest cf to go");
      printf("\n -delx #(0.05mm) --> distance between filters along basilar membrane");
      printf("\n                     !!!!!!!!!");
 
      printf("\n\nAbout stimulus>>>>>>>>");
      printf("\n -wavefile filename(click) --> specify the stimulus wavefile name(click)");
      printf("\n -reptim #(0.02) --> the time you want to run the model(20msec)");
      printf("\n -trials #(0)    --> spike generation trials");
      printf("\n");
      exit(1);
    };
return(0);
};


