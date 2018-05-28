#include <stdlib.h>
#include <string.h>
#include "miscfnc.h"
#include "mex.h"

/**
 * The number of 8-byte elements of dynamic memory that are allocated at a time,
 * once the dimension of a vector exceeds the amount of dynamic memory allocated
 * for storing its actual values. Memory is allocated in 8-byte units, becuase
 * this is the amount of bytes needed to store a double-precision floating point
 * value.
 */
#define ALLOC_BLOCKLENGTH   500

/******************************************************************************
 *                            Vector Type Definition                          *
 ******************************************************************************/

/**
 * A vector is a composite type and is made up of two long integer values and
 * a pointer to an array of doubles. The first long integer is n and stores the
 * dimension of the vector, the other integer is alloc_n and contains the number
 * of double values for which space is allocated in dynamic memory. At all times,
 * n must be less than or equal to alloc_n. In addition a vector type stores a
 * pointer to an array of doubles in dynamic memory that actually contains the 
 * values in the vector.
 */
typedef struct{
    long n;
    long alloc_n;
    double* data;
} vector;

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
vector vectorPtrInit(long n, double* data);

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
vector vectorScalarInit(long n, double scalar);

/**
 * Reset a vector to the empty vector and release the dynamic memory allocated for
 * it.
 * 
 * @param v
 *      A pointer to the vector that needs to be destroyed.
 * @post The dynamic memory allocted to the supplied vector for storing its values
 *      is released. The vector is the empty vector.
 */
void vectorFree(vector *v);

/**
 * Display a vector on the MATLAB command window.
 *
 * @param v
 *      A vector that needs to be displayed.
 * @post The dimension and the actual values of this vector are displayed on
 *      the MATLAB command window.
 */
void vectorDisplay(vector v);

/**
 * Add a scalar to a vector.
 *
 * @param v
 *      A pointer to a value of type vector to which a scalar needs to be
 *      added.
 * @param scalar
 *      The scalar value that needs to be added to the supplied vector.
 * @post The dimension of the supplied vector is augmented by one and the value
 *      associated with this extra dimension is set to the supplied value.
 */
void vectorAddScalar(vector* v, double scalar);

/**
 * Concatenate two vectors.
 *
 * @param v1
 *      A pointer to the first vector.
 * @param v2
 *      The second vector.
 * @post The first supplied vector has a dimension that is equal to the sum of
 *      the dimensions of both vectors. The values of this vector are set to the 
 *      concatenation of the values of the first vector with the values of the
 *      second values.
 */
void vectorConcatenate(vector* v1, const vector v2);

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
void vectorSort(vector *v, long* perm);

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
void vectorPermute(vector *v, long* perm);

/**
 * Convert a vector to an mxArray.
 *
 * @param v
 *      The vector to convert to an mxArray.
 * @return An mxArray object which represent a MATLAB numeric rowvector with the
 *      same dimension and values as the given vector.
 */
mxArray* vector2mxArray(vector v);

/**
 * Convert an mxArray to a vector.
 *
 * @param a
 *      An mxArray object that represents a MATLAB numeric row- or columnvector.
 * @return A vector with the same dimension and values as the supplied mxArray.
 */
vector mxArray2Vector(mxArray* a);
