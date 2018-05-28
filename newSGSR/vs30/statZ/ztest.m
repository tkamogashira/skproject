function [h,sig,ci] = ztest(x,m,sigma,alpha,tail)
%ZTEST  Hypothesis test: Compares the sample average to a constant.
%   [H,SIG] = ZTEST(X,M,SIGMA,ALPHA,TAIL) performs a Z-test to determine
%   whether a sample from a normal distribution (in X) could have mean M 
%   when the standard deviation, SIGMA, is known.
%   ALPHA = 0.05 and TAIL = 0 by default.
%
%   Null hypothesis is: "mean is equal to M".
%   For TAIL =  0, alternative: "mean is not M".
%   For TAIL =  1, alternative: "mean is greater than M."
%   For TAIL = -1, alternative: "mean is less than M."
%
%   ALPHA is desired significance level. 
%   SIG is the probability of observing the given result by chance
%   given that the null hypothesis is true. Small values of SIG cast
%   doubt on the validity of the null hypothesis.
%
%   H=0 => "Do not reject null hypothesis at significance level of alpha."
%   H=1 => "Reject null hypothesis at significance level of alpha."

%   References:
%      [1] E. Kreyszig, "Introductory Mathematical Statistics",
%      John Wiley, 1970, page 206. 

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1998/05/28 20:13:56 $

if nargin < 3, 
    error('Requires at least three input arguments.'); 
end

[m1 n1] = size(x);
if (m1 ~= 1 & n1 ~= 1) 
    error('First argument has to be a vector.');
end
 
if nargin < 5, 
    tail = 0; 
end 

if nargin < 4, 
    alpha = 0.05; 
end 

if (alpha <= 0 | alpha >= 1)
    fprintf('Warning: significance level must be between 0 and 1\n'); 
    h   = NaN;
    sig = NaN;
    return;
end

samplesize  = length(x);
xmean = mean(x);
ser = sigma ./ sqrt(samplesize);
zval = (xmean - m) ./ ser;
sig = normcdf(zval,0,1);

% the significance just found is for the  tail = -1 test

crit = norminv(1 - alpha/2,0,1) .* ser;

if tail == 1
    sig = 1 - sig;
elseif tail == 0
    sig = 2 * min(sig,1 - sig);
    crit = norminv((1 - alpha / 2),0,1) .* ser;
end

ci = [(xmean - crit) (xmean + crit)];


% Determine if the actual significance exceeds the desired significance
h = 0;
if sig <= alpha, 
    h = 1; 
end 

if isnan(sig), 
    h = NaN; 
end
