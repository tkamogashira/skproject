#include <math.h>
#include "mex.h"

#define ALGORITHM_TABLE_OPTIM
#define MIN(a, b)   ((a<b)?a:b)

int isNumericRowVector(mxArray*);
int getSizeOfVector(mxArray*);
double calculateSptDist(double*, int, double*, int, double);

void mexFunction(int nlhs,       mxArray *plhs[], 
                 int nrhs, const mxArray *prhs[])
{
    double *shiftCosts, *distances;
    int nCosts, i;

    /*Checking input arguments: D = SPTDIST(SPT1, SPT2, COST) */
    if (nrhs != 3) mexErrMsgTxt("Wrong number of input arguments.");
    if (!isNumericRowVector(prhs[0])) mexErrMsgTxt("First argument should be numeric rowvector.");
    if (!isNumericRowVector(prhs[1])) mexErrMsgTxt("Second argument should be numeric rowvector.");
    if (!isNumericRowVector(prhs[2])) mexErrMsgTxt("Third argument should be numeric rowvector.");
   
    /*Checking and creating output argument*/
    if (nlhs > 1) mexErrMsgTxt("To many output arguments.");
    nlhs = 1; plhs[0] = mxCreateDoubleMatrix(mxGetM(prhs[2]), mxGetN(prhs[2]), mxREAL);
    
    /*Calculating the spike time metric using spreadsheet*/
    nCosts = getSizeOfVector(prhs[2]);
    shiftCosts = mxGetPr(prhs[2]); distances = mxGetPr(plhs[0]);
    for (i = 0; i < nCosts; i++)
        distances[i] = calculateSptDist(mxGetPr(prhs[0]), getSizeOfVector(prhs[0]), 
            mxGetPr(prhs[1]), getSizeOfVector(prhs[1]), shiftCosts[i]);
}

int isNumericRowVector(mxArray* Vector)
{
    return mxIsNumeric(Vector) && !mxIsComplex(Vector) && (mxIsEmpty(Vector) 
        || (mxGetM(Vector) == 1) || (mxGetN(Vector) == 1));
}

int getSizeOfVector(mxArray* Vector) { return mxGetM(Vector)*mxGetN(Vector); }

#ifdef ALGORITHM_TABLE_OPTIM
double calculateSptDist(double* Spt1, int n1, double* Spt2, int n2, double cost) 
{
    double** G;
    double d1, d2, d3, dist;
    int i, j;

    /*Trivial cases*/
    if (n1 == 0) return (double)n2;
    if (n2 == 0) return (double)n1;

    /*Initialization*/
    G = (double**)mxCalloc(2, sizeof(double*));
    for (i = 0; i < 2; i++) G[i] = (double*)mxCalloc(n2+1, sizeof(double));
    for (i = 0; i <= n2; i++) G[0][i] = (double)i;
    
    /*Calculate values of spreadsheet, but only keep two rows in memory*/
    for (i = 1; i <= n1; i++) {
        G[1][0] = (double)i;
        for (j = 1; j <= n2; j++) {
            d1 = G[0][j-1] + cost*fabs(Spt1[i-1]-Spt2[j-1]);
            d2 = G[0][j] + 1.0;
            d3 = G[1][j-1] + 1.0;
            G[1][j] = MIN(d1 , MIN(d2, d3));
        }
        G[0] = (double *)((int)(G[0])-(int)(G[1])); //Swapping pointer without
        G[1] = (double *)((int)(G[0])+(int)(G[1])); //using an intermediate variable
        G[0] = (double *)((int)(G[1])-(int)(G[0]));
    }
    dist = G[0][n2];
    
    /*Free dynamic memory*/
    for(i = 0; i < 2; i++) mxFree(G[i]); mxFree(G);
    
    return dist;
}
#endif

#ifdef ALGORITHM_TABLE_FULL
double calculateSptDist(double* Spt1, int n1, double* Spt2, int n2, double cost) 
{
    double** G;
    double d1, d2, d3, dist;
    int i, j;

    /*Trivial cases*/
    if (n1 == 0) return (double)n2;
    if (n2 == 0) return (double)n1;

    /*Initialization*/
    G = (double**)mxCalloc(n1+1, sizeof(double*));
    G[0] = (double*)mxCalloc(n2+1, sizeof(double)); for(i = 0; i <= n2; i++) G[0][i] = (double)i;
    for(i = 1; i <= n1; i++) (G[i] = (double*)mxCalloc(n2+1, sizeof(double)))[0] = (double)i;
    
    /*Calculate values of spreadsheet*/
    for(i = 1; i <= n1; i++)
        for(j = 1; j <= n2; j++) {
            d1 = G[i-1][j-1] + cost*fabs(Spt1[i-1]-Spt2[j-1]);
            d2 = G[i-1][j] + 1.0;
            d3 = G[i][j-1] + 1.0;        
            G[i][j] = MIN(d1 , MIN(d2, d3));
        }
    dist = G[n1][n2];
    
    /*Free dynamic memory*/
    for(i = 0; i <= n1; i++) mxFree(G[i]); mxFree(G);
    
    return dist;
}
#endif

#ifdef ALGORITHM_RECURSION
double calculateSptDist(double* Spt1, int n1, double* Spt2, int n2, double cost) 
{
    double d1, d2, d3;
    
    if (n1 == 0) return (double)n2;
    if (n2 == 0) return (double)n1;
        
    d1 = SptDistRec(Spt1, n1-1, Spt2, n2-1, cost) + cost*fabs(Spt1[n1-1]-Spt2[n2-1]);
    d2 = SptDistRec(Spt1, n1-1, Spt2, n2, cost) + 1.0;
    d3 = SptDistRec(Spt1, n1, Spt2, n2-1, cost) + 1.0;
    
    return MIN(d1, MIN(d2, d3));
}
#endif