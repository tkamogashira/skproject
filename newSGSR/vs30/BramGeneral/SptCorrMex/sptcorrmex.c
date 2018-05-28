#include "vectorfnc.h"

/******************************************************************************
 *  H = SPTCORRMEX(SPT1, SPT2, MAXLAG, BINWIDTH), where SPT1 and SPT2 are     *
 *  vectors containing spiketimes, returns the histogram of the spike-time    *
 *  differences between the spike pairs from SPT1 and SPT2. The histogram is  *
 *  restricted to intervals DT between -maxlag and maxlag. BINWIDTH is the    *
 *  bin width of the histogram. All arguments must be specified in the same   *
 *  time unit, e.g. ms. The middle bin is centered around zero lag.           *
 *                                                                            *  
 *  The convention of time order matches that of XCORR: if t1 and t2 are      *
 *  spike times from SPT1 and SPT2, respectively, then t1>t2 will count as    *
 *  a positive interval.                                                      *
 *                                                                            *
 *  [H, BC] = SPTCORRMEX(...) also returns the position of the bin centers    *
 *  in H.                                                                     *
 ******************************************************************************/

vector* getSpkIn(mxArray* args[], long n);

/******************************************************************************
 *                               MEX Interface                                *
 ******************************************************************************/
void mexFunction(int nlhs,       mxArray *plhs[], 
                 int nrhs, const mxArray *prhs[])
{
    vector *spkIn;
    double maxLag;
    double binWidth;
    vector binCenters = {0, 0, NULL};
    vector nIntervals;
    long n;
    long i;
    long j;
    long indexOfLastSmaller;
    double effMaxLag;
    
    //Check input arguments and retrieve spike times and parameters.
    if (nrhs != 4){
        mexErrMsgTxt("Wrong number of input arguments.");
    }
    if (!mxIsNumeric(prhs[2]) || (mxGetNumberOfElements(prhs[2]) != 1) || 
        ((maxLag = mxGetScalar(prhs[2])) < 0))
    {
        mexErrMsgTxt("Maxlag must be positive scalar.");
    }
    if (!mxIsNumeric(prhs[3]) || (mxGetNumberOfElements(prhs[3]) != 1) || 
        ((binWidth = mxGetScalar(prhs[3])) <= 0))
    {
        mexErrMsgTxt("Binwidth must be positive scalar.");
    }
    spkIn = getSpkIn(prhs, 2);
    
    //Creating bincenters.
    n = floor(maxLag/binWidth);
    for (i = 0; i <= 2*n; i++){ // 2*n because we go from -maxLag to maxLag
        vectorAddScalar(&binCenters, (-n+i)*binWidth);
    }
    nIntervals = vectorScalarInit(2*n+1, 0.0);
    
    //When one of the input spiketrains is empty, we don't have to search for coincidences
    if ((spkIn[0].n != 0) && (spkIn[1].n != 0)){
        //Sorting both input spiketrains.
        for (i = 0; i < 2; i++){
            vectorSort(spkIn+i, NULL);
        }
    
        //Counting coincidences: bins are centered around zero delay. A spiketime
        //interval that falls on an edge between two bins is counted as a coincidence
        //for the right adjacent bin.
        effMaxLag = maxLag+binWidth/2;
        indexOfLastSmaller = 0L;
        for (i = 0; i < spkIn[0].n; i++){ //Go through all the spikes in spkIn[0]
            double spk = spkIn[0].data[i];
            double interval;
            
            //indexOfLastSmaller is the index of the last element in spkIn[1] that's < spk
            //We preserve the previous value and search further from there
            indexOfLastSmaller += binSearch(spkIn[1].data+indexOfLastSmaller,
                    spkIn[1].n-indexOfLastSmaller, spk) - 1;

            //Run through spkIn[1] once up and once down, starting at indexOfLastSmaller,
            //and check whether the spikes coincide
            j = indexOfLastSmaller;
            while ((++j < spkIn[1].n) && ((interval = spkIn[1].data[j]-spk) <= effMaxLag)){
                nIntervals.data[(long)(n-(interval/binWidth)+0.5)]++;
            }
            j = indexOfLastSmaller;
            while ((j >= 0) && ((interval = spk-spkIn[1].data[j--]) < effMaxLag)){
                nIntervals.data[(long)(n+(interval/binWidth)+0.5)]++;
            }
        }
    }
    
    //Create output arguments.
    nlhs = 2;
    plhs[0] = vector2mxArray(nIntervals);
    plhs[1] = vector2mxArray(binCenters);
    
    //Free dynamic memory.
    for (i = 0; i < 2; i++){
        vectorFree(spkIn+i);
    }
    mxFree(spkIn);
    vectorFree(&binCenters);
    vectorFree(&nIntervals);
}

/******************************************************************************
 *                               Local Functions                              *
 ******************************************************************************/
vector* getSpkIn(mxArray* args[], long n)
{
    vector* spkIn;
    long i;
    
    spkIn = (vector*)mxMalloc(n*sizeof(vector));
    for (i = 0; i < n; i++){
        if (mxIsEmpty(args[i])){
            spkIn[i] = vectorPtrInit(0, NULL);
        }
        else if (mxIsNumeric(args[i]) && (mxGetM(args[i]) == 1) || 
           (mxGetN(args[i]) == 1))
        {
            spkIn[i] = mxArray2Vector(args[i]);
        }
        else{
            long j;
            for (j = 0; j < i; j++){
                vectorFree(spkIn+j);
            }
            mxFree(spkIn);
            mexErrMsgTxt("Spiketrains must be given as numerical vectors.");
        }
    }
    return spkIn;
}

