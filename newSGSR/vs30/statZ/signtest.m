function [p, h] = signtest(x,y,alpha)
%SIGNTEST Sign test.
%   P = SIGNTEST(X,Y,ALPHA) returns the significance probability
%   that the medians of two matched samples, X and Y are equal.
%   X and Y must be vectors of equal length. Y may also be a scalar.
%   In this case, SIGNTEST computes the probability that the median
%   of X is different from the constant, Y. ALPHA is the desired
%   level of significance and must be a scalar between
%   zero and one.
%
%   [P, H] = SIGNTEST(X,Y,ALPHA) also returns the result of the 
%   hypothesis test, H. H is zero if the difference in medians of
%   X and Y is not significantly different from zero. H is one if
%   the two medians are significantly different. 
%
%   P is the probability of observing a result equally or more 
%   extreme than the one using the data (X and Y) if the null  
%   hypothesis is true. If P is near zero, this casts doubt on
%   this hypothesis.

%   B.A. Jones 11-18-96
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
% $Revision: 1.6 $

if nargin < 3
   alpha = 0.05;
elseif (alpha <= 0 | alpha >= 1)
    fprintf('Warning: significance level must be between 0 and 1\n'); 
    h = NaN;
    sig = NaN;
    ci = [NaN NaN];
    return;
end

[rowx, colx] = size(x);
[rowy, coly] = size(y);
if prod(size(y)) == 1,
   rowy = max(size(x));
   y = y(ones(rowy,1));
end

if min(rowx, colx) ~= 1 | min(rowy,coly) ~= 1,
   error('SIGNTEST requires vector rather than matrix data.');
end 
if rowx == 1
   rowx = colx;
   x = x';
end
if rowy == 1,
   rowy = coly;
   y = y';
end
   
if rowx ~= rowy,
   error('SIGNTEST requires the data vectors to have the same number of elements.');
end

n = rowx;
diffxy = x - y;
nodiff = find(diffxy == 0);
diffxy(nodiff) = [];
n = n - length(nodiff);

if n == 0 % this means the two vectors are identical
    p = 1;
    if nargout == 2,
	h = (p<alpha);
    end   
    return
end

npos = length(find(diffxy>0));
nneg = n-npos;
sgn = min(nneg,npos);

if n < 100
   p = 2*binocdf(sgn,n,0.5);
else 
   z = (abs(npos-nneg)-1)/sqrt(n);
   p = 2*normcdf(-z,0,1);
end

if nargout == 2,
   h = (p<alpha);
end   
