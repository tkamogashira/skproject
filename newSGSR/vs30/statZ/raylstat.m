function [m,v]= raylstat(b)
%RAYLSTAT Mean and variance for the Rayleigh distribution.
%   [M,V] = RAYLSTAT(B) returns the mean and variance of
%   the Rayleigh distribution with parameter B.

%   Reference:
%      [1]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 p. 134-136.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:46:35 $

if nargin < 1, 
    error('Requires at least one input argument.'); 
end

m = b * sqrt(pi/2);
v = (2 - pi/2) * b .^ 2;

% Return NaN if B is negative or zero.
k = find(b <= 0);
if any(k)
    tmp  = NaN;
    m(k) = tmp(ones(size(k))); 
    v(k) = tmp(ones(size(k))); 
end
