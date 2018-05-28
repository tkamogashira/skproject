function m = geomean(x)
%GEOMEAN Geometric mean.
%   M = GEOMEAN(X) returns the geometric mean of the input.
%   When X is a vector with n elements, GEOMEAN(X) returns of the 
%   the n-th root of the product of the elements.
%   For a matrix input, GEOMMEAN(X) returns a row vector containing
%   the geometric mean of each column of X.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:45:31 $

[r,n] = size(x);

% If the input is a row, make sure that N is the number of elements in X.
if r == 1, 
    r = n;
   x = x';
   n = 1; 
end

if any(any(x < 0))
    error('The data must all be non-negative numbers.')
end

m = zeros(1,n);
k = find(sum(x == 0) ==0);
m(k) = exp(sum(log(x(:,k))) ./ r);
