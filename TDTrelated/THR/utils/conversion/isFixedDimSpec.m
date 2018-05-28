function fs = isFixedDimSpec(Dim, flag);
% isFixedDimSpec - true if specification of dimension represents a fixed size
%   isFixedDimSpec(Dim) returns 1 for fixed-sized Dim spec, zero otherwise.
%   A Dim spec is a pair of numbers [Min Max] specifying the min and max # elements of
%   something. A single number M is interpreted as the number pair [0 M], in words
%   "at most M elements". This type of dimension specification is used in
%   Parameter construction and in dimensionTest.
%
%   Fized size means that minimum and maximum allowed # elements are equal, 
%   that is Dim equals [N N] or 0.
%
%   isFixedDimSpec(Dim, 'nonempty') rejects the zero-Dim cases Dim==0 and Dim==[0 0].
%
%   See also Parameter, Parameter/setvalue, dimensionTest.

error(nargchk(1,3,nargin));

if nargin<2, flag = ''; end; 

fs = 0;

if isequal([1 2], size(Dim)),
    fs = isequal(0, diff(Dim));
else, 
    fs = isequal(0, Dim);
end

if isequal('nonempty', flag),
    fs = fs & ~all(Dim==0);
end

