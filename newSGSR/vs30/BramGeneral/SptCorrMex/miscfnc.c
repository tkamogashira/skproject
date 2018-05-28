#include "miscfnc.h"

/******************************************************************************
 *                            Miscellaneous Functions                         *
 ******************************************************************************/

/**
 * Search an array of doubles for a supplied value.
 *
 * @param data
 *      A pointer to an array of doubles.
 * @param n
 *      The number of elements in the array of doubles. This must be zero or a
 *      positive integer.
 * @param value
 *      The value to search for in the array of doubles.
 * @return If the supplied value is present in the array then the position of
 *      this value if returned, where 0 designates the first element in the 
 *      array and n-1 the last element in the array. Otherwise a negative number
 *      is returned.
 * @O The timecomplexity has a magnitude lower than or equal to n, where n
 *      is the number of elements in the array.
 */
long seqSearch(double *data, long n, double value)
{
    long i = -1;
    
    //The double values or compared within relative precision of the floating 
    //point representation.
    while ((++i < n) && (fabs(data[i]-value) > fabs(value*DBL_EPSILON))) ;
    
    if (i == n){
        return -1;
    }
    else{
        return i;
    }
}

/**
 * Search an array of doubles for a supplied value.
 *
 * @param data
 *      A pointer to an array of doubles, all values of this array must be
 *      sorted in ascending order.
 * @param n
 *      The number of elements in the array of doubles. This must be zero or a
 *      positive integer.
 * @param value
 *      The value to search for in the array of doubles.
 * @return If the supplied value is present in the array then the position of
 *      this value is returned, where 0 designates the first element in the 
 *      array and n-1 the last element in the array. If the value is not present
 *      in the array then all the elements with a position smaller than the 
 *      returned position are smaller than the given value.
 * @O The timecomplexity has a magnitude lower than or equal to log(n), where
 *      n is the number of elements in the array.
 */
long binSearch(double *data, long length, double value)
{
    long left = 0;
    long right = length - 1;
    
    //@invar Every element of data with position larger than 'right' is greater than 
    //      or equal to the supplied value.
    //@invar Every element of data with a position smaller then 'left' is less then
    //      the supplied value.
    //@invar 'left' must always be greater than or equal to zero, 'right' must always
    //      be less then 'length'.
    //@var The distance between 'left' and 'right', e.g. abs(left - right), must
    //      decrement by one after each iteration.
    while (left <= right){
        long middle = (left + right)/2;
        //Check whether left = right within the precision of the floating point
        //representation.
        if (fabs(data[middle] - value) <= fabs(value*DBL_EPSILON)){
            return middle;
        }
        else if (data[middle] < value){
            left = middle + 1;
        }
        else{
            right = middle - 1;
        }
    }
    
    //Because left = right + 1 and the loop invariants still hold, the only element of
    //the array that can still be equal to the supplied value is the element at position
    //'left'. If this is not the case then we can be sure that all elements of the array
    //at a position lower than the returned position are smaller than the given value.
    return left;
}

/**
 * Sort an array of doubles in ascending order.
 *
 * @param data
 *      The array of doubles to sort.
 * @param n
 *      The number of elements in the array. This must be zero or a positive
 *      integer.
 * @param perm
 *      A pointer to an array of n long integers, or NULL if a permutation
 *      representing the sort of the supplied array is not required.
 * @post The array of doubles is sorted in ascending order and if the perm
 *      parameter isn't NULL, then perm stores the permutation representing the
 *      sort of the array of doubles. E.g. if an element at position oldPos in
 *      the original array of doubles is moved to the position newPos in the
 *      sorted array, then perm[newPos] equals oldPos.
 * @O The time complexity has magnitude equal or smaller than n*log(n) where n
 *      is the number of elements in the array. The quicksort algorithm by C.A.
 *      Hoare is implemented.
 */
void quickSort(double* data, long n, long* perm)
{
    //If an effective pointer to an array of long integers is supplied to store
    //the permutation representing the sort, then this permutation is initialized
    //to the identity permutation.
    if (perm != NULL){
        long i;
        for (i = 0; i < n; i++){
            perm[i] = i;
        }
    }
    recursiveSort(data, 0, n-1, perm);
}

/**
 * Sort a section of an array of doubles in ascending order.
 *
 * @param data
 *      The array of doubles for which the specified section needs to
 *      be sorted.
 * @param l
 *      The position of the left most element in the array that is part
 *      of the section to be sorted.
 * @param r
 *      The position of the right most element in the array that is part
 *      of the section to be sorted.
 * @param perm
 *      An array of long integers with the same length as the supplied array
 *      of doubles and for which the values of the matching section are set
 *      to the position number. Or NULL if a permutation representing the sort
 *      of the supplied array is not required. 
 * @post The section of the array of doubles is sorted in ascending order and
 *      if the perm parameter isn't NULL, then the matching section of perm 
 *      stores the permutation representing the sort of the array of doubles.
 * @O The time complexity has magnitude equal or smaller than n*log(n) where n
 *      is the number of elements in the section of the array, e.g. r-l+1. The
 *      quicksort algorithm by C.A. Hoare is used.
 */ 
void recursiveSort(double* data, long l, long r, long* perm)
{
    //An array that has only one element or is empty does not need to be sorted,
    //because it already is.
    if (l >= r){
        return;
    }
    else{
        //Partition the supplied section, taking the position of the pivot as the
        //middle position of this section.
        long m = partition(data, l, r, (l+r)/2, perm);
        //All elements of the supplied section with position smaller than m have a
        //value smaller than or equal to the value of the pivot, whereas all elements
        //with position larger than m have a value larger than the pivot.
        //Sorting each partition of this section results in a totally sorted section.
        recursiveSort(data, l, m-1, perm);
        recursiveSort(data, m+1, r, perm);
    }
}

/**
 * Swap the double precision floating point value referenced by two pointers.
 * 
 * @param x
 *      The first pointer to a double value.
 * @param y
 *      The second pointer to a double value.
 * @post The values of the two double pointers is swapped.
 */
void swapDouble(double* x, double *y)
{
    double tmp = *x;
    *x = *y;
    *y = tmp;
}

/**
 * Swap the long integer value referenced by two pointers.
 * 
 * @param x
 *      The first pointer to a long integer.
 * @param y
 *      The second pointer to a long integer.
 * @post The values of the two integer pointers is swapped.
 */
void swapLong(long* x, long *y)
{
    long tmp = *x;
    *x = *y;
    *y = tmp;
}

/**
 * Partition a section of an array of doubles. 
 *
 * @param data
 *      The array of doubles for which the specified section needs to
 *      be partitioned.
 * @param l
 *      The position of the left most element in the array that is part
 *      of the section to be partitioned.
 * @param r
 *      The position of the right most element in the array that is part
 *      of the section to be partitioned.
 * @param pivotPos
 *      The position of the pivot element in the section of the array to
 *      be partitioned.
 * @param perm
 *      An array of long integers with the same length as the supplied array
 *      of doubles and for which the values of the matching section are set
 *      to the position number. Or NULL if a permutation representing the 
 *      partition of the supplied array is not required. 
 * @return The new position of the pivot in the section of the array is
 *      returned and all elements in the section of the array that have
 *      a position less than this new position are smaller than or equal
 *      to the value of this pivot. All elements in the section that have
 *      a position larger than the returned position have a value larger
 *      than the pivot. If the perm parameter isn't NULL, then the matching
 *      section of perm stores the permutation representing the partitioning
 *      of the section of the array of doubles.
 */
long partition(double* data, long l, long r, long pivotPos, long* perm)
{
    long checkPos;
    long lastSmallerPos;
    
    //The pivot element is swapped with the first element in the section
    //and change the position of the pivot accordingly.
    swapDouble(data+l, data+pivotPos);
    if (perm != NULL){
        swapLong(perm+l, perm+pivotPos);
    }
    pivotPos = l;
    
    //@invar Every element in the section of the array with a position
    //      less than or equal to lastSmallerPos is smaller than or equal to the
    //      value of the pivot.
    //@invar Every element in the section with a position between lastSmallerPos+1
    //      and checkPos-1 is larger than the value of the pivot.
    for (lastSmallerPos = l, checkPos = l+1; checkPos <= r; checkPos++) {
        //The double values or compared within relative precision of the
        //floating point representation.
        if ((fabs(data[checkPos]-data[pivotPos]) <= fabs(data[pivotPos]*DBL_EPSILON)) | 
                (data[checkPos] < data[pivotPos]))
        {
            lastSmallerPos++;
            swapDouble(data+lastSmallerPos, data+checkPos);
            if (perm != NULL){
                swapLong(perm+lastSmallerPos, perm+checkPos);
            }
        }
    }
     
    //Putting back pivot element in the right position.
    swapDouble(data+pivotPos, data+lastSmallerPos); 
    if (perm != NULL){
        swapLong(perm+pivotPos, perm+lastSmallerPos);
    }
        
    return lastSmallerPos;
}
