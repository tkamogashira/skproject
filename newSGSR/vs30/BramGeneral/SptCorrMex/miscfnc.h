#include <stdlib.h>
#include <float.h>
#include <math.h>

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
long seqSearch(double *data, long n, double value);

/**
 * Search an array of doubles for a supplied value.
 *
 * @param data
 *      A pointer to an array of doubles, all values of this array must be
 *      sorted in ascending order.
 * @param length
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
long binSearch(double *data, long length, double value);

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
void quickSort(double* data, long n, long* perm);

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
void recursiveSort(double* data, long l, long r, long* perm);

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
long partition(double* data, long l, long r, long pivotPos, long* perm);

/**
 * Swap the double precision floating point value referenced by two pointers.
 * 
 * @param x
 *      The first pointer to a double value.
 * @param y
 *      The second pointer to a double value.
 * @post The values of the two double pointers is swapped.
 */
void swapDouble(double* x, double *y);

/**
 * Swap the long integer value referenced by two pointers.
 * 
 * @param x
 *      The first pointer to a long integer.
 * @param y
 *      The second pointer to a long integer.
 * @post The values of the two integer pointers is swapped.
 */
void swapLong(long* x, long *y);
