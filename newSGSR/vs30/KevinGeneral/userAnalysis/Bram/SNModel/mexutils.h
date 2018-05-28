#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "mex.h"

#define ALLOC_BLOCKLENGTH   500

/*------------------------------General functions-----------------------------------*/
long SeqSearch(double *Data, long n, double Scalar);
long BinSearch(double *Data, long n, double Scalar);  
void Swap(double* x, double* y);
long Partition(double* Data, long i, long j, double* P);
void QuickSort(double* Data, long i, long j, double* P);

/*------------------Vector datatype and operation functions-------------------------*/
typedef struct{
    long    n, alloc_n;
    double* data;
} Vector;

Vector VectorPtrInit(long N, double* Data);          /*Initialise vector*/
Vector VectorScalarInit(long N, double Scalar);
void VectorAddScalar(Vector* V, double Scalar);      /*Add scalar to a vector*/
void VectorConcatenate(Vector* V1, const Vector V2); /*Concatenate two vectors*/
void VectorSort(Vector *V, double* P);               /*Sort elements of a vector*/
void VectorDisplay(Vector V);                        /*Display vector*/
void VectorFree(Vector *V);                          /*Reset vector*/
mxArray* Vector2mxArray(Vector V);                   /*Conversion to and from mxArray*/
Vector mxArray2Vector(mxArray* A);

/*----------------------------------------------------------------------------------*/
long SeqSearch(double *Data, long n, double Scalar)
/*Search array of doubles for the presence of an element. If scalar is not present 
then minus one is returned.*/
{
    long i = -1;
    
    /*Compare doubles within relative precision of floating point representation*/
    while ((++i < n) && (fabs(Data[i]-Scalar) > fabs(Scalar*DBL_EPSILON))) ;
    
    if (i == n) return -1; else return i;
}

long BinSearch(double *Data, long n, double Scalar)
/*Input argument Data must contain sorted array of doubles so binary search
can be used. If scalar is not present in array then the left most entry is
returned, minus one if no left most entry is present.*/
{
    long m, i = 0, j = n-1;
    double dist;
    
    /*Empty input argument*/
    if (n == 0) return -1;

    while (i <= j)
        /*Compare doubles within relative precision of floating point representation*/
        if (fabs(dist = Data[m = (i+j)/2]-Scalar) <= fabs(Scalar*DBL_EPSILON)) return m;
        else if (dist > 0) j = m-1; else i = m+1;
        
    if (Data[m = (i+j)/2] < Scalar) return m; else return -1;
}

void Swap(double* x, double *y)
{
    double tmp = *x;
    *x = *y; *y = tmp;
}

long Partition(double* Data, long i, long j, double* P)
{
    long k, m = (i+j)/2; /*Pivot element*/
    
    Swap(Data+i, Data+m); if (P != NULL) Swap(P+i, P+m); /*Swap pivot element with first element*/
    for (k = i+1, m = i; k <= j; k++)
        if (Data[k] < Data[i])
        {
            Swap(Data+(++m), Data+k);
            if (P != NULL) Swap(P+m, P+k);
        }
    Swap(Data+i, Data+m); if (P != NULL) Swap(P+i, P+m); /*Put pivot element back*/
        
    return m;
}

void QuickSort(double* Data, long i, long j, double* P)
/*Using quicksort algorithm by C.A. Hoare*/
{
    if (i >= j) return;
    else 
    {
        long m = Partition(Data, i, j, P);
        QuickSort(Data, i, m-1, P); QuickSort(Data, m+1, j, P);
    }
}

/*----------------------------------------------------------------------------------*/
Vector VectorPtrInit(long N, double *Data)
/*Initialisation of a vector variable by supplying a pointer to a double array
from which N elements are copied and stored into the newly created vector
variable. For the creation of an empty vector variable use N = 0 and supply
the NULL pointer.*/
{
    Vector V = {0, 0, NULL};
    
    if (N > 0)
    {
        V.n = N; V.alloc_n = ((N-1)/ALLOC_BLOCKLENGTH+1)*ALLOC_BLOCKLENGTH;
        V.data = (double*)mxMalloc(V.alloc_n*sizeof(double)); 
        memcpy(V.data, Data, V.n*sizeof(double));
    }
    else if ((N == 0) && (Data != NULL)) 
        mexErrMsgTxt("VectorPtrInit: Empty vector initialisation with non NULL pointer.");
    else if (N < 0) 
        mexErrMsgTxt("VectorPtrInit: Number of elements in vector cannot be negative.");
    
    return V;
}

Vector VectorScalarInit(long N, double Scalar)
/*Initialisation of a vector variable by supplying the number of elements
and a scalar to which all elements are set. For the creation of an empty
vector variable use N = 0.*/
{
    Vector V = {0, 0, NULL}; long i;
        
    if (N > 0)
    {
        V.n = N; V.alloc_n = ((N-1)/ALLOC_BLOCKLENGTH+1)*ALLOC_BLOCKLENGTH;
        V.data = (double*)mxMalloc(V.alloc_n*sizeof(double));
        for (i = 0; i < V.n; i++) V.data[i] = Scalar;
    }
    else if (N < 0) 
        mexErrMsgTxt("VectorScalarInit: Number of elements in vector cannot be negative.");
    
    return V;
}

void VectorAddScalar(Vector* V, double Scalar)
/*Appends a scalar to the end of a vector and augments the length of the vector
by one. The supplied vector must already be initialised!*/
{
    if (V->alloc_n == 0)
        V->data = (double*)mxMalloc((V->alloc_n = ALLOC_BLOCKLENGTH)*sizeof(double));
    else if (V->n == V->alloc_n)
    {
        V->data = mxRealloc(V->data, (V->alloc_n += ALLOC_BLOCKLENGTH)*sizeof(double));
        if (V->data == NULL) mexErrMsgTxt("VectorAddScalar: Cannot allocate enough memory.");
    }    
    else if (V->n > V->alloc_n)    
        mexErrMsgTxt("VectorAddScalar: More number of elements in vector than allowed by memory allocation.");
    V->data[(V->n)++] = Scalar;
}

void VectorConcatenate(Vector* V1, const Vector V2)
/*Concatenate two vectors. The supplied vectors must already be initialised!*/
{
    long orig_n = V1->n, nbytes;
    
    if (V2.n == 0) return; /*Adding the empty vector*/
    if ((V1->n += V2.n) > V1->alloc_n)
    {
        V1->alloc_n = ((V1->n-1)/ALLOC_BLOCKLENGTH+1)*ALLOC_BLOCKLENGTH;
        nbytes = V1->alloc_n*sizeof(double);
        if (V1->data == NULL) V1->data = mxMalloc(nbytes);
        else
        {
            V1->data = mxRealloc(V1->data, nbytes);
            if (V1->data == NULL) mexErrMsgTxt("VectorConcatenate: Cannot allocate enough memory.");
        }    
    }
    memcpy(V1->data+orig_n, V2.data, V2.n*sizeof(double));
}

void VectorSort(Vector *V, double* P)
/*Sort the elements in a vector and allow for a second array of doubles
to be sorted in the same order. This double array must have the same number
of elements as the vector or can be set to the NULL pointer.*/
{
    QuickSort(V->data, 0, V->n-1, P);
}

void VectorDisplay(Vector V)
/*Display the contents of a vector on the MATLAB command window.*/
{
    long i;

    mexPrintf("Vector contents:\n");
    mexPrintf("\tn       : %d\n", V.n);
    mexPrintf("\talloc_n : %d\n", V.alloc_n);
    mexPrintf("\tdata    : ["); for (i = 0; i < V.n; i++) mexPrintf(" %.3f", V.data[i]); mexPrintf(" ]\n");
}

void VectorFree(Vector* V)
/*Reset the vector to an empty vector and free all dynamic memory associated
with the vector variable.*/
{
    V->n = 0; V->alloc_n = 0;
    mxFree(V->data); V->data = NULL;
}

Vector mxArray2Vector(mxArray* A)
/*Convert a MATLAB compatible numeric rowvector to a vector variable. The data
is copied into the newly created rowvector.*/
{
    Vector V;

    if (!mxIsNumeric(A) || (mxGetM(A) != 1))
        mexErrMsgTxt("mxArray2Vector: Only numeric rowvectors can be converted to a vector.");
    else V = VectorPtrInit(mxGetN(A), mxGetPr(A)); 
    
    return V;
}

mxArray* Vector2mxArray(Vector V)
/*Convert a vector variable to a MATLAB compatible numeric rowvector. The data
of the vector is copied.*/
{
    mxArray* Var = mxCreateDoubleMatrix(1, V.n, mxREAL);
    memcpy(mxGetPr(Var), V.data, V.n*sizeof(double));
    return Var;
}

/*----------------------------------------------------------------------------------*/

#undef ALLOC_BLOCKLENGTH
