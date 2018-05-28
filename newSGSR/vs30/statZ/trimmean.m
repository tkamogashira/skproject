function m = trimmean(x,percent)
%TRIMMEAN The trimmed mean of X is a robust estimate of the sample location.
%   M = TRIMMEAN(X,PERCENT) calculates the mean of X excluding the highest
%   and lowest percent/2 of the data. For matrices, TRIMMEAN(X) is a vector
%   containing the trimmed mean for each column. The scalar, PERCENT, 
%   must take values between 0 and 100.
%
%   For matrix, X, M = TRIMMEAN(X,PERCENT) is a row vector containing the
%   trimmed mean for each column of X.   

%   B.A. Jones 3-04-93
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:46:52 $

if nargin < 2
    error('Requires two input arguments.');
end

if percent >= 100 | percent < 0
    error('Percent must take values between 0 and 100.');
end

zlow = prctile(x,(percent / 2));
zhi  = prctile(x,100 - percent / 2);

[n p] = size(x);

zlow = zlow(ones(n,1),:);
zhi  = zhi(ones(n,1),:);
indicator = (x >= zlow & x <= zhi);
m = sum(x .* indicator) ./ sum(indicator); 
