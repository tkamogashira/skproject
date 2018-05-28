function [mn,v]= tstat(nu);
%TSTAT  Mean and variance for the student's t distribution.
%   [MN,V] = TSTAT(NU) returns the mean and variance of
%   Student's T distribution with NU degrees of freedom.

%   References:
%      [1]  E. Kreyszig, "Introductory Mathematical Statistics",
%      John Wiley, New York, 1970, Section 10.3, pages 144-146.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:46:53 $

if nargin < 1,   
    error('Requires one input argument.');       
end

% Initialize the mean and variance to zero.
mn = zeros(size(nu));
v = zeros(size(nu));

k = find( nu <= 0 | round(nu) ~= nu);
if any(k)
    tmp = NaN;
    mn(k) = tmp(ones(size(k)));
    v(k) = mn(k);
end

% The mean of the t distribution is zero unless there is only one 
% degree of freedom. In that case the mean does not exist.
k = find(nu == 1);
if any(k);
    tmp = NaN;
    mn(k) = tmp(ones(size(k)));
end

% The variance of the t distribution is undefined for one and two
% degrees of freedom.
k = find(nu==1 | nu==2);
if any(k)
    tmp = NaN;
    v(k) = tmp(ones(size(k)));
end

k = find(nu >2 & round(nu) == nu);
if any(k)
    v(k) = nu(k) ./ (nu(k) - 2);
end
