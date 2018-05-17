#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "mex.h"

extern void _main();
/*********************/
extern int matan2_nonlinear_human(double tdres,double cf, double spont,int model,
		                   const double *in, double *out, int length);
extern int matan2_new(double tdres, double cf, double spont, int model, int species,
				   const double *in, double *out, int length);

/* The gateway routine */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
      int error;
      double *para,*in,*out;
      double tdres,cf,spont;
      int model;
      int species;
      int ifspike;
      double  x;
      int     length,mrows,ncols;
      /*  Check for proper number of arguments. */
      /* NOTE: You do not need an else statement when using
           mexErrMsgTxt within an if statement. It will never
           get to the else statement if mexErrMsgTxt is executed.
           (mexErrMsgTxt breaks you out of the MEX-file.) 
       */
      if(nrhs!=2) 
        mexErrMsgTxt("sout = an_arlo([tdres,cf,spont,model, species,ifspike],input);");
      if(nlhs!=1) 
        mexErrMsgTxt("One output required.");

      /*  Get the input parameter. */
      if((mxGetM(prhs[0])*mxGetN(prhs[0]))<6)
	mexErrMsgTxt("The first input para contains [tdres,cf,spont,model,species,ifspike]");
      para = mxGetPr(prhs[0]);
      tdres = para[0];
      cf = para[1];
      spont = para[2];      
      model = (int)(para[3]);
      species = (int)(para[4]);
      ifspike = (int)(para[5]);
      
      /*  Create a pointer to the input matrix in. */
      in = mxGetPr(prhs[1]);

      /*  Get the dimensions of the matrix input in. */
      mrows = mxGetM(prhs[1]);
      ncols = mxGetN(prhs[1]);
      /*  Set the output pointer to the output matrix. */
      plhs[0] = mxCreateDoubleMatrix(mrows,ncols, mxREAL);

      /*  Create a C pointer to a copy of the output matrix. */
      out = mxGetPr(plhs[0]);
      length = mrows*ncols;

      /*  Call the C subroutine. */
      error = an_arlo(tdres,cf,spont,model,species,ifspike,in,out,length);
      if(error) mexErrMsgTxt("Error in calling the function.");
}

