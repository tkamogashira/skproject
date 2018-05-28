function [m,v]= fstat(v1,v2);
%FSTAT  Mean and variance for the F distribution.
%   [M,V] = FSTAT(V1,V2) returns the mean (M) and variance (V)
%   of the F distribution with V1 and V2 degrees of freedom.
%   Note that the mean of the F distribution is undefined if V1 
%   is less than 3. The variance is undefined for V2 less than 5.

%   References:
%      [1]  W. H. Beyer, "CRC Standard Probability and Statistics",
%      CRC Press, Boston, 1991, page 23.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1997/11/29 01:45:23 $

if nargin < 2, 
    error('Requires two input arguments.'); 
end

[errorcode v1 v2] = distchck(2,v1,v2);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

%   Initialize the M and V to zero.
m = zeros(size(v1));
v = zeros(size(v2));

k = find(v1 <= 0 | v2 <= 0 | round(v1) ~= v1 | round(v2) ~= v2);
if any(k)
    tmp = NaN;
    m(k) = tmp(ones(size(k)));
    v(k) = m(k);
end

k = find(v2 > 2 & v1 > 0 & round(v1) == v1 & round(v2) == v2);
if any(k)
    m(k) = v2(k) ./ (v2(k) - 2);
end

% The mean is undefined for V2 less than or equal to 2.
k1 = find(v2 <= 2);
if any(k1);
    tmp = NaN;
    m(k1) = tmp(ones(size(k1)));
end

k = find(v2 > 4 & v1 > 0 & round(v1) == v1 & round(v2) == v2);
if any(k)
    v(k) = m(k) .^ 2 * 2 .* (v1(k) + v2(k) - 2) ./ (v1(k) .* (v2(k) - 4));
end

% The variance is undefined for V2 less than or equal to 4.
k2 = find(v2 <= 4);
if any(k2)
    tmp = NaN;
    v(k2) = tmp(ones(size(k2)));
end
