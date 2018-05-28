function [p, h] = signrank(x,y,alpha)
%SIGNRANK Wilcoxon signed rank test of equality of medians.
%   P = SIGNRANK(X,Y,ALPHA) returns the significance probability
%   that the medians of two matched samples, X and Y are equal.
%   X and Y must be vectors of equal length. ALPHA is the desired
%   level of significance. and must be a scalar between
%   zero and one.
%
%   [P, H] = SIGNRANK(X,Y,ALPHA) also returns the result of the 
%   hypothesis test, H. H is zero if the difference in medians of
%   X and Y is not significantly different from zero. H is one if
%   the two medians are significantly different. 
%
%   P is the probability of observing a result equally or more 
%   extreme than the one using the data (X and Y) if the null  
%   hypothesis is true. If P is near zero, this casts doubt on
%   this hypothesis.

%   B.A. Jones 11-18-96, ZP You 9-4-98
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
% $Revision: 1.5 $

if nargin < 3
   alpha = 0.05;
end

[rowx, colx] = size(x);
[rowy, coly] = size(y);

if min(rowx, colx) ~= 1 | min(rowy,coly) ~= 1,
   error('SIGNRANK requires vector rather than matrix data.');
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
   error('SIGNRANK requires the data vectors to have the same number of elements.');
end

diffxy = x - y;
nodiff = find(diffxy == 0);
diffxy(nodiff) = [];
n = length(diffxy);
[sd, rowidx] = sort(abs(diffxy));
neg = find(diffxy<0);

invr(rowidx) = 1:n; % invr is the inverse of rowidx.
w = sum(invr(neg));
w = min(w, n*(n+1)/2-w);

if n > 15,
   z = (w-n*(n+1)/4)/sqrt(n*(n+1)*(2*n+1)/24);
   p = 2*normcdf(z,0,1);
else
   allposs = (ff2n(n))';
   idx = (1:n)';
   idx = idx(:,ones(2.^n,1));
   pranks = sum(allposs.*idx);
   tail = 2*length(find(pranks < w))+length(find(pranks == w)); % two side.
   p = tail./(2.^n);
end

if nargout == 2,
   h = (p<alpha);
end
