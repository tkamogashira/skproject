function [m,v]= unifstat(a,b);
%UNIFSTAT Mean and variance of the continuous uniform distribution.
%   [M,V] = UNIFSTAT(A,B) returns the mean and variance of
%   the uniform distribution on the interval [A,B].

%   Reference:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.1.34.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1997/11/29 01:47:02 $

if nargin < 2,
 error('Requires two input arguments.');
end

[errorcode a b] = distchck(2,a,b);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

m = (a + b) / 2;
v = (b - a) .^ 2 / 12;


% Return NaN if the lower limit is greater than the upper limit.
k1 = find(a >= b);
if any(k1)
    tmp   = NaN;
    m(k1) = tmp(ones(size(k1))); 
    v(k1) = tmp(ones(size(k1)));
end

