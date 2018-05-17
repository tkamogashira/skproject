#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "spikes.h"
#include "mex.h"

extern void _main();
/*********************/
extern int SGmodel(double tdres, const double *sout, double** sptimeptr, const int nstim, const int nrep);

/* The gateway routine */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
      int error;
      double *para,*in,*out,*out2;
      double tdres;
      int nrep,nspikes;
      double  x;
      double** outptr;
      int     length,mrows,ncols;
      /*  Check for proper number of arguments. */
      /* NOTE: You do not need an else statement when using
           mexErrMsgTxt within an if statement. It will never
           get to the else statement if mexErrMsgTxt is executed.
           (mexErrMsgTxt breaks you out of the MEX-file.) 
       */
      if(nrhs!=2) 
        mexErrMsgTxt("[sptime,nspikes] = ihcmodel([tdres,nrep],input);");
      if(nlhs!=2) 
        mexErrMsgTxt("Two output required.");

      /*  Get the input parameter. */
      if((mxGetM(prhs[0])*mxGetN(prhs[0]))<2)
	mexErrMsgTxt("The first input para contains [tdres,nrep]");
      para = mxGetPr(prhs[0]);
      tdres = para[0];
      nrep = (int)para[1];
      
      /*  Create a pointer to the input matrix in. */
      in = mxGetPr(prhs[1]);

      /*  Get the dimensions of the matrix input in. */
      mrows = mxGetM(prhs[1]);
      ncols = mxGetN(prhs[1]);
      /*  Set the output pointer to the output matrix. */
/*      plhs[0] = mxCreateDoubleMatrix(mrows,ncols, mxREAL);*/
      plhs[1] = mxCreateDoubleMatrix(1,1, mxREAL);
      out2 = mxGetPr(plhs[1]);
      
      /*  Create a C pointer to a copy of the output matrix. */
/*      out = mxGetPr(plhs[0]); */
      length = mrows*ncols;

      /*  Call the C subroutine. */
      plhs[0] = mxCreateDoubleMatrix(10000,1,mxREAL);
      out = mxGetPr(plhs[0]);
      outptr  = &out;
      
      nspikes = SGmodel(tdres,in,outptr,length,nrep);
/*      plhs[0] = mxCreateDoubleMatrix(nspikes,1,mxREAL);
      out = mxGetPr(plhs[0]);
      for(length = 0; length<nspikes; length++)
	out[length] = (*outptr)[length];
*/
      out2[0] = (int)(nspikes+0.1);
/*      free(*outptr); */
};

