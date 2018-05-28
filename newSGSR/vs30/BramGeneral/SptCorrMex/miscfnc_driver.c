#include "miscfnc.h"
#include "mex.h"

/******************************************************************************
 *                               MEX Interface                                *
 ******************************************************************************/
void mexFunction(int nlhs,       mxArray *plhs[], 
                 int nrhs, const mxArray *prhs[])
{
    //Checking arguments.
    if ((nrhs != 0) | (nlhs != 0)) 
        mexErrMsgTxt("Wrong number of input or output arguments.");
    
    //Debugging seqSearch function.
    {
        const double data[] = {3.0, 2.0, 1.0, 4.0};
        const long n = 4;
    
        if (!(seqSearch(data, n, 0.0) < 0))
            mexErrMsgTxt("Error in seqSearch method.");
        if (seqSearch(data, n, 1.0) != 2)
            mexErrMsgTxt("Error in seqSearch method.");
    }
    
    //Debugging binSearch function.
    {
        const double data[] = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0};
        const long n = 7;
    
        if (binSearch(data, n, 3.5) != 3)
            mexErrMsgTxt("Error in binSearch method.");
        if (binSearch(data, n, 3.0) != 2)
            mexErrMsgTxt("Error in binSearch method.");
        if (binSearch(data, n, 0.0) != 0)
            mexErrMsgTxt("Error in binSearch method.");
    }
    
    //Debugging partition function.
    {
        const double data[] = {3.0, 5.0, 6.0, 2.0, 1.0, 4.0, 7.0};
        const long n = 7;
        double pivot = 4.0;
        long pivotPos; long i;
        
        pivotPos = seqSearch(data, n, pivot);
        pivotPos = partition(data, 0, n-1, pivotPos, NULL);
        if (data[pivotPos] != pivot) mexErrMsgTxt("Error in partition method.");
        for (i = 0; i < pivotPos; i++)
            if (data[i] > data[pivotPos]) mexErrMsgTxt("Error in partition method.");
        for (i = pivotPos+1; i < n; i++)
            if (data[i] <= data[pivotPos]) mexErrMsgTxt("Error in partition method.");
                    
    }
    {
        const double data[] = {3.0, 4.0, 5.0, 6.0};
        const long n = 4;
        double pivot = 4.0;
        long pivotPos; long i;
        
        pivotPos = seqSearch(data, n, pivot);
        pivotPos = partition(data, 0, n-1, pivotPos, NULL);
        if (data[pivotPos] != pivot) mexErrMsgTxt("Error in partition method.");
        for (i = 0; i < pivotPos; i++)
            if (data[i] > data[pivotPos]) mexErrMsgTxt("Error in partition method.");
        for (i = pivotPos+1; i < n; i++)
            if (data[i] <= data[pivotPos]) mexErrMsgTxt("Error in partition method.");
    }
    
    //Debugging quickSort function.
    {
        const double data[] = {3.0, 5.0, 6.0, 2.0, 1.0, 4.0, 7.0};
        const long n = 7;
        long i;
        
        quickSort(data, n, NULL);
        for (i = 0; i < n; i++)
            if (data[i] != i+1.0) mexErrMsgTxt("Error in quickSort method.");
    }
    {
        const double data[] = {3.0, 5.0, 8.0, 6.0, 2.0, 1.0, 4.0, 7.0};
        const long n = 8;
        long i;
        
        quickSort(data, n, NULL);
        for (i = 0; i < n; i++)
            if (data[i] != i+1.0) mexErrMsgTxt("Error in quickSort method.");
    }
    {
        const double data[] = {-8.0, -7.0, -6.0, -5.0, -4.0, -3.0, -2.0, -1.0};
        const long n = 8;
        long i;
        
        quickSort(data, n, NULL);
        for (i = 0; i < n; i++)
            if (data[i] != i-8.0) mexErrMsgTxt("Error in quickSort method.");
    }
    {
        const double data[] = {3.0, 5.0, 7.0, 6.0, 2.0, 1.0, 4.0, 7.0};
        const long n = 8;
        long i;
        
        quickSort(data, n, NULL);
        for (i = 0; i < n-1; i++)
            if (data[i] != i+1.0) mexErrMsgTxt("Error in quickSort method.");
        if (data[n-2] != data[n-1]) mexErrMsgTxt("Error in quickSort method.");
        if (data[n-1] != 7.0) mexErrMsgTxt("Error in quickSort method.");
    }
    {
        const double data[] = {3.0, 5.0, 6.0, 2.0, 1.0, 4.0, 7.0};
        const long n = 7;
        const long expectedIdx[] = {4, 3, 0, 5, 1, 2, 6};
        long idx[7];
        long i;
        
        quickSort(data, n, idx);
        for (i = 0; i < n; i++)
            if (data[i] != i+1.0) mexErrMsgTxt("Error in quickSort method.");
        for (i = 0; i < n; i++)
            if (idx[i] != expectedIdx[i]) mexErrMsgTxt("Error in quickSort method.");
    }
}
