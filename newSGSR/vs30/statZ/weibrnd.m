function r = weibrnd(a,b,m,n)
%WEIBRND Random matrices from the Weibull distribution.
%   R = WEIBRND(A,B) returns a matrix of random numbers chosen   
%   from the Weibull distribution with parameters A and B.
%
%   The size of R is the common size of A and B if both are matrices.
%   If either parameter is a scalar, the size of R is the size of the other
%   parameter. R = WEIBRND(A,B,M,N) returns an M by N matrix. 
%
%   When A == B, WEIBRND calls EXPRND. 
%   When A ~= B, WEIBRND uses an inversion method. 

%   References:
%      [1]  L. Devroye, "Non-Uniform Random Variate Generation", 
%      Springer-Verlag, 1986

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:47:08 $

if    nargin < 2, 
    error('Requires two input arguments.'); 
end

if nargin == 2
    [errorcode rows columns] = rndcheck(2,2,a,b);
end

if nargin == 3
    [errorcode rows columns] = rndcheck(3,2,a,b,m);
end

if nargin == 4
    [errorcode rows columns] = rndcheck(4,2,a,b,m,n);
end

if errorcode > 0
    error('Size information is inconsistent.');
end

r = zeros(rows,columns);
if prod(size(a)) == 1
    a = a(ones(rows,1),ones(columns,1));
end
if prod(size(b)) == 1
    b = b(ones(rows,1),ones(columns,1));
end

% If A is 1 then you can get a Weibull random number with parameter B 
% by generating an Exponential random number and raising it to the power B.
% See Devroye, page 414.
k = find(a == 1);
if any(k)
    u = rand(size(k));
    e = - log(u);
    r(k) = e .^ (1 ./ b(k));
end

k1 = find(a ~= 1);
if any(k1)
    u = rand(size(k1));
    r(k1) = weibinv(u,a(k1),b(k1));
end

% Return NaN if b is not positive.
if any(any(b <= 0));
    if prod(size(b) == 1)
        tmp = NaN;
        r = tmp(ones(rows,columns));
    else
        k = find(b <= 0);
        tmp = NaN;
        r(k) = tmp(ones(size(k)));
    end
end

% Return NaN if a is not positive.
if any(any(a <= 0));
    if prod(size(a) == 1)
        tmp = NaN;
        r = tmp(ones(rows,columns));
    else
        k = find(a <= 0);
        tmp = NaN;
        r(k) = tmp(ones(size(k)));
    end
end
