function r = ncx2rnd(v,delta,m,n)
%NCX2RND Random matrices from the noncentral chi-square distribution.
%   R = NCX2RND(V,DELTA) returns a matrix of random numbers chosen   
%   from the non-central chisquare distribution with parameters V and DELTA.
%
%   The size of R is the common size of V and DELTA if both are matrices.
%   If either parameter is a scalar, the size of R is the size of the other
%   parameter. Alternatively, R = NCX2RND(V,DELTA,M,N) returns an M by N  
%   matrix.

%   Reference:
%      [1]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 p. 50-51.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.4 $  $Date: 1997/11/29 01:46:09 $

if nargin < 2, 
    error('Requires at least two input arguments.');
end

if nargin == 2
    [errorcode rows columns] = rndcheck(2,2,v,delta);
end

if nargin == 3
    [errorcode rows columns] = rndcheck(3,2,v,delta,m);
end

if nargin == 4
    [errorcode rows columns] = rndcheck(4,2,v,delta,m,n);
end

if errorcode > 0
    error('Size information is inconsistent.');
end

% Initialization.
elements = rows*columns;
if prod(size(delta)==1)
   delta = delta(ones(elements,1),1);
end
if prod(size(v)==1)
   v = v(ones(elements,1),1);
end

tmp = zeros(elements,1);

% Sum the squares of the normal random numbers.
for k = 1:elements,
    r(k) = sum(normrnd(sqrt(delta(k)/v(k)),1,v(k),1).^2);
end

% Return NaN for values of V that are not positive integers.
if any(any(v <= 0)) | any(any(v ~= round(v)));
    if prod(size(v) == 1)
        tmp = NaN;
        r = tmp(ones(rows,columns));
    else
        k = find(v <= 0);
        tmp = NaN;
        r(k) = tmp(ones(size(k)));
    end
end
r = reshape(r,rows,columns);
