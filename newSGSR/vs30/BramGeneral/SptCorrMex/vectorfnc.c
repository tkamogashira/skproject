#include "vectorfnc.h"

/******************************************************************************
 *                               Vector Functions                             *
 ******************************************************************************/

/**
 * Create and initialize a new vector. The vector is initialized with data
 * originating from an array of doubles.
 *
 * @param n
 *      The dimension of the new vector and also the number of elements of in
 *      the supplied double array that are used to initialize this new vector.
 * @param data
 *      The array of doubles, must have a minimum number of elements of n.
 * @return A new vector of dimension n is returned and the values of this new
 *      vector are equal to the first n values of the supplied array. If a zero
 *      dimension is supplied an empty vector is created, in this case the 
 *      array of doubles can be ommitted by supplying the NULL pointer.
 */
vector vectorPtrInit(long n, double* data)
{
    vector v = {0, 0, NULL};
    
    if (n > 0){
        v.n = n; v.alloc_n = (((n-1)/ALLOC_BLOCKLENGTH)+1)*ALLOC_BLOCKLENGTH;
        v.data = (double*)mxMalloc(v.alloc_n*sizeof(double)); 
        memcpy(v.data, data, v.n*sizeof(double));
    }
    else if (n < 0){
        mexErrMsgTxt("vectorPtrInit: Dimension of a vector cannot be negative.");
    }
    return v;
}

/**
 * Create and initialize a new vector. All the values of this new vector are
 * initialized to the supplied value.
 *
 * @param n
 *      The dimension of the new vector.
 * @param scalar
 *      A double value.
 * @return A new vector of dimension n is returned and the values of this new
 *      vector are all equal to the supplied scalar double value. If a zero
 *      dimension is supplied an empty vector is created.
 */
vector vectorScalarInit(long n, double scalar)
{
    vector v = {0, 0, NULL}; long i;
        
    if (n > 0){
        v.n = n; v.alloc_n = (((n-1)/ALLOC_BLOCKLENGTH)+1)*ALLOC_BLOCKLENGTH;
        v.data = (double*)mxMalloc(v.alloc_n*sizeof(double));
        for (i = 0; i < v.n; i++) v.data[i] = scalar;
    }
    else if (n < 0){
        mexErrMsgTxt("vectorPtrInit: Dimension of a vector cannot be negative.");
    }
    return v;
}

/**
 * Reset a vector to the empty vector and release the dynamic memory allocated for
 * it.
 * 
 * @param v
 *      A pointer to the vector that needs to be destroyed.
 * @post The dynamic memory allocted to the supplied vector for storing its values
 *      is released. The vector is the empty vector.
 */
void vectorFree(vector *v)
{
    v->n = 0;
    v->alloc_n = 0;
    mxFree(v->data);
    v->data = NULL;
}

/**
 * Display a vector on the MATLAB command window.
 *
 * @param v
 *      A vector that needs to be displayed.
 * @post The dimension and the actual values of this vector are displayed on
 *      the MATLAB command window.
 */
void vectorDisplay(vector v)
{
    long i;

    mexPrintf("Vector contents:\n");
    mexPrintf("\tn       : %d\n", v.n);
    mexPrintf("\talloc_n : %d\n", v.alloc_n);
    mexPrintf("\tdata    : [");
    for (i = 0; i < v.n; i++){
        mexPrintf(" %.3f", v.data[i]);
        mexPrintf(" ]\n");
    }
}

/**
 * Add a scalar to a vector.
 *
 * @param v
 *      A pointer to a value of type vector to which a scalar needs to be
 *      added. This vector must already be initialized.
 * @param scalar
 *      The scalar value that needs to be added to the supplied vector.
 * @post The dimension of the supplied vector is augmented by one and the value
 *      associated with this extra dimension is set to the supplied value.
 */
void vectorAddScalar(vector* v, double scalar)
{
    if (v->alloc_n == 0){
        v->data = (double*)mxMalloc((v->alloc_n = ALLOC_BLOCKLENGTH)*sizeof(double));
    }
    else if (v->n == v->alloc_n){
        v->data = mxRealloc(v->data, (v->alloc_n += ALLOC_BLOCKLENGTH)*sizeof(double));
        if (v->data == NULL){
            mexErrMsgTxt("vectorAddScalar: Cannot allocate enough memory.");
        }
    }
    else if (v->n > v->alloc_n){
        mexErrMsgTxt("vectorAddScalar: More number of elements in vector than allowed by memory allocation.");
    }
    v->data[(v->n)++] = scalar;
}

/**
 * Concatenate two vectors.
 *
 * @param v1
 *      A pointer to the first vector, this vector must be initialized.
 * @param v2
 *      The second vector, this vector must also be initialized.
 * @post The first supplied vector has a dimension that is equal to the sum of
 *      the dimensions of both vectors. The values of this vector are set to the 
 *      concatenation of the values of the first vector with the values of the
 *      second values.
 */
void vectorConcatenate(vector* v1, const vector v2)
{
    long orig_n = v1->n, nbytes;
    
    if (v2.n == 0){
        return; //Adding the empty vector is trivial.
    }
    if ((v1->n += v2.n) > v1->alloc_n){
        v1->alloc_n = ((v1->n-1)/ALLOC_BLOCKLENGTH+1)*ALLOC_BLOCKLENGTH;
        nbytes = v1->alloc_n*sizeof(double);
        if (v1->data == NULL){
            v1->data = mxMalloc(nbytes);
        }
        else{
            v1->data = mxRealloc(v1->data, nbytes);
            if (v1->data == NULL){
                mexErrMsgTxt("vectorConcatenate: Cannot allocate enough memory.");
            }
        }
    }
    memcpy(v1->data+orig_n, v2.data, v2.n*sizeof(double));
}

/**
 * Sort the values of a vector.
 *
 * @param v
 *      A pointer to the vector whose values need to be sorted.
 * @param perm
 *      An array of long integers that has the same number of elements as the
 *      dimension of the supplied vector, or the NULL pointer.
 * @post The values of the supplied vector are sorted in ascending order and
 *      if the perm parameter isn't NULL, then perm stores the permutation
 *      representing the sort of the values of the vector. E.g. if a value
 *      at position oldPos in the original vector is moved to the position
 *      newPos in the sorted vector, then perm[newPos] equals oldPos.
 */
void vectorSort(vector *v, long* perm)
{
    quickSort(v->data, v->n, perm);
}

/**
 * Reorder the values of a vector.
 *
 * @param v
 *      A pointer to a vector.
 * @param perm
 *      An array of long integers containing a permutation of the positions of 
 *      the supplied vector.
 * @post The supplied permutation is applied to the values of the vector.
 */
void vectorPermute(vector *v, long* perm)
{
    double* buffer = mxMalloc(v->alloc_n*sizeof(double));
    long i;
    
    for (i = 0; i < v->n; i++){
        buffer[i] = v->data[perm[i]];
    }
    
    mxFree(v->data);
    v->data = buffer;
}

/**
 * Convert an mxArray to a vector.
 *
 * @param a
 *      An mxArray object that represents a MATLAB numeric row- or columnvector.
 * @return A vector with the same dimension and values as the supplied mxArray.
 *      The values are copied.
 */
vector mxArray2Vector(mxArray* a)
{
    vector v;

    if (!mxIsNumeric(a) || ((mxGetM(a) != 1) && (mxGetN(a) != 1))){
        mexErrMsgTxt("mxArray2Vector: Only numeric row- or columnvectors can be converted to a vector.");
    }
    else{
        v = vectorPtrInit(mxGetN(a)*mxGetM(a), mxGetPr(a));
    }
    
    return v;
}

/**
 * Convert a vector to an mxArray.
 *
 * @param v
 *      The vector to convert to an mxArray.
 * @return An mxArray object which represent a MATLAB numeric rowvector with the
 *      same dimension and values as the given vector. The data of the vector is
 *      copied.
 */
mxArray* vector2mxArray(vector v)
{
    mxArray* a = mxCreateDoubleMatrix(1, v.n, mxREAL);
    memcpy(mxGetPr(a), v.data, v.n*sizeof(double));
    return a;
}

