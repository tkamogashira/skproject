#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "mexutils.h"

/*-----------------------------------SNModel------------------------------------*/
typedef struct{
    long    Ninputs;
    double *Ainputs;
    double  Trefrac;
    double  Tdecay;
    double  Thr;
} MdlParam;

typedef struct{
    long    Nspk;
    double *Vmem;
    double *Spks;
    double *Ampl;
} MdlStat;

MdlStat InitMdlStat(MdlParam P, Vector* SpkIn);
void FreeMdlStat(MdlStat S);
void DispMdlStat(MdlStat S);
Vector SNModel(MdlParam P, Vector* SpkIn);          /*Actual shot-noise coincidence model*/

/*------------------------------------MEX---------------------------------------*/
double*  GetRowVectorField(mxArray *S, char* FieldName, long N);
double   GetScalarField(mxArray *S, char* FieldName);
MdlParam GetMdlParam(mxArray* S);
Vector*  GetSpkIn(mxArray* Args[], long N);

/*-------------------------------MEX Interface----------------------------------*/
void mexFunction(int nlhs,       mxArray *plhs[], 
                 int nrhs, const mxArray *prhs[])
{
    MdlParam P; Vector* SpkIn; Vector SpkOut = {0, 0, NULL};

    /*Check input arguments and retrieve model parameters*/
    if (nrhs == 0) mexErrMsgTxt("Wrong number of input arguments.");
    else if (!mxIsStruct(prhs[0]) || (mxGetNumberOfElements(prhs[0]) != 1))
        mexErrMsgTxt("First argument should be scalar structure with model parameters.");
    else P = GetMdlParam(prhs[0]);
    
    if (P.Ninputs != (nrhs-1)) mexErrMsgTxt("Wrong number of input spiketrains.");
    if (P.Ninputs == 0) /*Nothing to be done*/
    { 
        nlhs = 1; plhs[0] = mxCreateDoubleMatrix(0, 0, mxREAL);
    }
    else 
    {   
        long i;

        /*Get input spiketrains*/
        SpkIn = GetSpkIn(prhs+1, P.Ninputs);
        
        /*Performing actual calculations*/
        SpkOut = SNModel(P, SpkIn);
    
        /*Create output arguments*/
        nlhs = 1; plhs[0] = Vector2mxArray(SpkOut);

        /*Free dynamic memory*/
        for (i = 0; i < P.Ninputs; i++) VectorFree(SpkIn+i); mxFree(SpkIn);
        VectorFree(&SpkOut);
    }    
}

/*-------------------------------------------------------------------------------*/
#define ERRMSG_MAXLENGTH    200

double* GetRowVectorField(mxArray *S, char* FieldName, long N)
{
    mxArray* FieldValue; char ErrMsg[ERRMSG_MAXLENGTH+1];
    
    FieldValue = mxGetField(S, 0, FieldName);
    if (FieldValue == NULL)
    {
        sprintf(ErrMsg, "Invalid parameter structure: connat find field '%s'.", FieldName);
        mexErrMsgTxt(ErrMsg);
    }    
    else if (!mxIsNumeric(FieldValue) || (mxGetM(FieldValue) != 1) || (mxGetN(FieldValue) != N))
    {
        sprintf(ErrMsg, "Parameter '%s' must be a numerical row vector of %d elements.", FieldName, N);
        mexErrMsgTxt(ErrMsg);
    }    
    else return mxGetPr(FieldValue);
}

double GetScalarField(mxArray *S, char* FieldName)
{
    mxArray* FieldValue; char ErrMsg[ERRMSG_MAXLENGTH+1];

    FieldValue = mxGetField(S, 0, FieldName);
    if (FieldValue == NULL) 
    {
        sprintf(ErrMsg, "Invalid parameter structure: connat find field '%s'.", FieldName);
        mexErrMsgTxt(ErrMsg);
    }
    else if (!mxIsNumeric(FieldValue) || (mxGetNumberOfElements(FieldValue) != 1))
    {
        sprintf(ErrMsg, "Parameter '%s' must be a numerical scalar.", FieldName);
        mexErrMsgTxt(ErrMsg);
    }    
    else return mxGetScalar(FieldValue);
}

MdlParam GetMdlParam(mxArray* S)
{
    MdlParam P;
    
    P.Ninputs = (long)GetScalarField(S, "ninputs");
    P.Ainputs = GetRowVectorField(S, "ainputs", P.Ninputs);
    P.Trefrac = GetScalarField(S, "trefrac");
    P.Tdecay  = GetScalarField(S, "tdecay");
    P.Thr     = GetScalarField(S, "thr");
    
    return P;
}    

Vector* GetSpkIn(mxArray* Args[], long N)
{
    Vector* SpkIn; long i, j;
    
    SpkIn = (Vector*)mxMalloc(N*sizeof(Vector));
    for (i = 0; i < N; i++)
    {
        if (mxIsEmpty(Args[i])) SpkIn[i] = VectorPtrInit(0, NULL);
        else if (mxIsNumeric(Args[i]) && (mxGetM(Args[i]) == 1)) SpkIn[i] = VectorPtrInit(mxGetN(Args[i]), mxGetPr(Args[i])); 
        else
        {
            for (j = 0; j < i; j++) VectorFree(SpkIn+j); mxFree(SpkIn);
            mexErrMsgTxt("Spiketrains must be given as numerical rowvectors.");
        }
    }
    return SpkIn;
}

#undef ERRMSG_MAXLENGTH

/*-------------------------------------------------------------------------------*/
MdlStat InitMdlStat(MdlParam P, Vector* SpkIn)
{
    MdlStat S;
    Vector SpkTmp = {0, 0, NULL};
    long i, n;
    
    /*Concatenating all input spiketrains*/
    for (i = 0; i < P.Ninputs; i++) VectorConcatenate(&SpkTmp, SpkIn[i]);
    S.Nspk = SpkTmp.n; S.Spks = SpkTmp.data;
    S.Vmem = (double*)mxMalloc(S.Nspk*sizeof(double));
    for (i = 0; i < S.Nspk; i++) S.Vmem[i] = 0.0;
    S.Ampl = (double*)mxMalloc(S.Nspk*sizeof(double));
    for (i = n = 0; i < P.Ninputs; n += SpkIn[i].n, i++)
    { 
        long j;
        for (j = 0; j < SpkIn[i].n; j++) S.Ampl[n+j] = P.Ainputs[i];
    }
    
    /*Sorting concatenated spikes and their associated amplitudes*/
    QuickSort(S.Spks, 0, S.Nspk-1, S.Ampl);
    
    return S;
}

void FreeMdlStat(MdlStat S)
{
    mxFree(S.Vmem); 
    mxFree(S.Spks); 
    mxFree(S.Ampl);
}

void DispMdlStat(MdlStat S)
{
    long i;    

    mexPrintf("Current status of the model:\n");
    mexPrintf("\tTotal number of spikes : %d\n", S.Nspk);
    mexPrintf("\tMembrane potential     : ["); for (i = 0; i < S.Nspk; i++) mexPrintf(" %.2f", S.Vmem[i]); mexPrintf(" ]\n");
    mexPrintf("\tSpiketimes             : ["); for (i = 0; i < S.Nspk; i++) mexPrintf(" %.2f", S.Spks[i]); mexPrintf(" ]\n");
    mexPrintf("\tAmplitude              : ["); for (i = 0; i < S.Nspk; i++) mexPrintf(" %.2f", S.Ampl[i]); mexPrintf(" ]\n");
}

Vector SNModel(MdlParam P, Vector* SpkIn)
{
    MdlStat S; Vector SpkOut = {0, 0, NULL};
    long i;
    
    S = InitMdlStat(P, SpkIn);
    
    i = 0;
    while (i < S.Nspk)
    {
        if ((S.Vmem[i] += S.Ampl[i]) >= P.Thr)
        {
           double RefSpk = S.Spks[i]; long j;
        
           VectorAddScalar(&SpkOut, RefSpk);
           while ((++i < S.Nspk) && ((S.Spks[i]-RefSpk) <= P.Trefrac)) ;
           j = i; while ((j < S.Nspk) && (S.Vmem[j] != 0.0)) S.Vmem[j++] = 0.0;
        }
        else
        {
            long j = i;
            
            while ((++j < S.Nspk) && ((S.Vmem[j] = S.Ampl[i]*exp((S.Spks[i]-S.Spks[j])/P.Tdecay)) >= DBL_EPSILON)) ;
            i++;
        }
    }
    
    FreeMdlStat(S);
     
    return SpkOut;
}

/*-------------------------------------------------------------------------------*/