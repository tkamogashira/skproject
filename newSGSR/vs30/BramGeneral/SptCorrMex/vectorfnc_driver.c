#include "vectorfnc.h"

/******************************************************************************
 *                               MEX Interface                                *
 ******************************************************************************/
void mexFunction(int nlhs,       mxArray *plhs[], 
                 int nrhs, const mxArray *prhs[])
{
    //Checking arguments.
    if ((nrhs != 0) | (nlhs != 0)) 
        mexErrMsgTxt("Wrong number of input or output arguments.");
    
    //Debugging vectorPtrInit function.
    {
        const double data[] = {3.0, 2.0, 1.0, 4.0};
        const long n = 4;
        vector v;
    
        v = vectorPtrInit(n, data);
        if (v.n != 4) mexErrMsgTxt("Error in vectorPtrInit method.");
        if (v.n > v.alloc_n) mexErrMsgTxt("Error in vectorPtrInit method.");
        
        vectorFree(&v);
    }
    {
        vector v;
    
        v = vectorPtrInit(0, NULL);
        if (v.n != 0) mexErrMsgTxt("Error in vectorPtrInit method.");
        if (v.alloc_n != 0) mexErrMsgTxt("Error in vectorPtrInit method.");
        if (v.data != NULL) mexErrMsgTxt("Error in vectorPtrInit method.");
        
        vectorFree(&v);
    }
    
    //Debugging vectorScalarInit function.
    {
        const double scalar = 3.5;
        const long n = 8;
        vector v; long i;
    
        v = vectorScalarInit(n, scalar);
        if (v.n != n) mexErrMsgTxt("Error in vectorScalarInit method.");
        if (v.alloc_n < v.n) mexErrMsgTxt("Error in vectorScalarInit method.");
        for (i = 0; i < n; i++) 
            if (v.data[i] != scalar) mexErrMsgTxt("Error in vectorScalarInit method.");
        
        vectorFree(&v);
    }
    {
        vector v;
    
        v = vectorScalarInit(0, 0);
        if (v.n != 0) mexErrMsgTxt("Error in vectorScalarInit method.");
        if (v.alloc_n != 0) mexErrMsgTxt("Error in vectorScalarInit method.");
        if (v.data != NULL) mexErrMsgTxt("Error in vectorScalarInit method.");
        
        vectorFree(&v);
    }
    
    //Debugging vectorFree function.
    {
        const double scalar = 3.5;
        const long n = 8;
        vector v;
    
        v = vectorScalarInit(n, scalar);
        vectorFree(&v);
        if (v.n != 0) mexErrMsgTxt("Error in vectorFree method.");
        if (v.alloc_n != 0) mexErrMsgTxt("Error in vectorFree method.");
        if (v.data != NULL) mexErrMsgTxt("Error in vectorFree method.");
    }
    {
        vector v = vectorScalarInit(0, 0);
        vectorFree(&v);
        if (v.n != 0) mexErrMsgTxt("Error in vectorFree method.");
        if (v.alloc_n != 0) mexErrMsgTxt("Error in vectorFree method.");
        if (v.data != NULL) mexErrMsgTxt("Error in vectorFree method.");
    }
    
    //Debugging vectorDisplay function.
    {
        const double scalar = 3.5;
        const long n = 8;
        vector v;
    
        v = vectorScalarInit(n, scalar);
        vectorDisplay(v);
        vectorFree(&v);
    }
    {
        vector v = vectorScalarInit(0, 0);
        vectorDisplay(v);
        vectorFree(&v);
    }    
    
    //Debugging vectorAddScalar function.
    {
        const double scalar = 3.5;
        const double extraScalar = 4.5;
        const long n = 8; long i;
        vector v = vectorScalarInit(n, scalar);
    
        vectorAddScalar(&v, extraScalar);
        if (v.n != n+1) mexErrMsgTxt("Error in vectorAddScalar method.");
        if (v.alloc_n < v.n) mexErrMsgTxt("Error in vectorAddScalar method.");
        for (i = 0; i < n; i++) 
            if (v.data[i] != scalar) mexErrMsgTxt("Error in vectorAddScalar method.");
        if (v.data[n] != extraScalar) mexErrMsgTxt("Error in vectorAddScalar method.");    
        
        vectorFree(&v);
    }
    {
        const double scalar = 3.5;
        vector v = vectorScalarInit(0, 0);
        
        vectorAddScalar(&v, scalar);
        if (v.n != 1) mexErrMsgTxt("Error in vectorAddScalar method.");
        if (v.alloc_n < v.n) mexErrMsgTxt("Error in vectorAddScalar method.");
        if (v.data[0] != scalar) mexErrMsgTxt("Error in vectorAddScalar method.");    
        
        vectorFree(&v);
    }
    
    //Debugging vectorConcatenate function.
    {
        const double data[] = {3.0, 2.0, 1.0, 4.0};
        const long n1 = 4;
        vector v1 = vectorPtrInit(n1, data);
        const double scalar = 3.5;
        const long n2 = 8;
        vector v2 = vectorScalarInit(n2, scalar);
        long i;
    
        vectorConcatenate(&v1, v2);
        if (v1.n != n1+n2) mexErrMsgTxt("Error in vectorConcatenate method.");
        if (v1.n > v1.alloc_n) mexErrMsgTxt("Error in vectorConcatenate method.");
        for (i = 0; i < n1; i++)
            if (v1.data[i] != data[i]) mexErrMsgTxt("Error in vectorConcatenate method.");
        for (i = n1; i < n1+n2; i++)
            if (v1.data[i] != scalar) mexErrMsgTxt("Error in vectorConcatenate method.");
        
        vectorFree(&v1);
        vectorFree(&v2);
    }
    {
        const double data[] = {3.0, 2.0, 1.0, 4.0};
        const long n1 = 4;
        vector v1 = vectorPtrInit(n1, data);
        const long n2 = 0;
        vector v2 = vectorPtrInit(n2, NULL);
        long i;
        
        vectorConcatenate(&v1, v2);
        if (v1.n != n1+n2) mexErrMsgTxt("Error in vectorConcatenate method.");
        if (v1.n > v1.alloc_n) mexErrMsgTxt("Error in vectorConcatenate method.");
        for (i = 0; i < n1; i++)
            if (v1.data[i] != data[i]) mexErrMsgTxt("Error in vectorConcatenate method.");
        
        vectorFree(&v1);
        vectorFree(&v2);
    }
    {
        const long n1 = 0;
        vector v1 = vectorPtrInit(n1, NULL);
        const double data[] = {3.0, 2.0, 1.0, 4.0};
        const long n2 = 4;
        vector v2 = vectorPtrInit(n2, data);
        long i;
        
        vectorConcatenate(&v1, v2);
        if (v1.n != n1+n2) mexErrMsgTxt("Error in vectorConcatenate method.");
        if (v1.n > v1.alloc_n) mexErrMsgTxt("Error in vectorConcatenate method.");
        for (i = 0; i < n2; i++)
            if (v1.data[i] != data[i]) mexErrMsgTxt("Error in vectorConcatenate method.");
        
        vectorFree(&v1);
        vectorFree(&v2);
    }
    
    //Debugging vectorSort function.
    {
        const double data[] = {3.0, 2.0, 1.0, 4.0};
        const long n = 4;
        vector v = vectorPtrInit(n, data);
        long i;
        
        vectorSort(&v, NULL);
        if (v.n != n) mexErrMsgTxt("Error in vectorSort method.");
        if (v.n > v.alloc_n) mexErrMsgTxt("Error in vectorSort method.");
        for (i = 0; i < n; i++)
            if (v.data[i] != i+1.0) mexErrMsgTxt("Error in vectorSort method.");
        
        vectorFree(&v);
    }
    {
        const double data[] = {3.0, 2.0, 1.0, 4.0};
        const long n = 4;
        vector v = vectorPtrInit(n, data);
        long idx[4]; 
        const long expectedIdx[] = {2, 1, 0, 3};
        long i;
        
        vectorSort(&v, idx);
        for (i = 0; i < n; i++)
            if (idx[i] != expectedIdx[i]) mexErrMsgTxt("Error in vectorSort method.");
        
        vectorFree(&v);
    }    
    
    //Debugging vectorPermute function.
    {
        const double data[] = {3.0, 2.0, 1.0, 4.0};
        const long n = 4;
        vector v = vectorPtrInit(n, data);
        const long idx[] = {2, 1, 0, 3};
        long i;
        
        vectorPermute(&v, idx);
        for (i = 0; i < n; i++)
            if (v.data[i] != i+1.0) mexErrMsgTxt("Error in vectorPermute method.");
        
        vectorFree(&v);
    }
    
    //Debugging vector2mxArray function.    
    //Debugging mxArray2Vector function.    
}
