function r = lognrnd(mu,sigma,m,n);
%LOGNRND Random matrices from the lognormal distribution.
%   R = LOGNRND(MU,SIGMA) returns a matrix of random numbers chosen   
%   from the lognormal distribution with parameters MU and SIGMA.
%
%   The size of R is the common size of MU and SIGMA if both are matrices.
%   If either parameter is a scalar, the size of R is the size of the other
%   parameter. Alternatively, R = LOGNRND(MU,SIGMA,M,N) returns an M by N  
%   matrix.

%   Reference:
%      [1]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 p. 102-105.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:47 $

if nargin < 2, 
    error('Requires at least two input arguments.');
end

if nargin == 2
    [errorcode rows columns] = rndcheck(2,2,mu,sigma);
end

if nargin == 3
    [errorcode rows columns] = rndcheck(3,2,mu,sigma,m);
end

if nargin == 4
    [errorcode rows columns] = rndcheck(4,2,mu,sigma,m,n);
end

if errorcode > 0
    error('Size information is inconsistent.');
end

%Initialize r to zero.
r = zeros(rows, columns);

r = exp(randn(rows,columns) .* sigma + mu);

% Return NaN if SIGMA is not positive.
if any(any(sigma <= 0));
    if prod(size(sigma) == 1)
        tmp = NaN;
        r = tmp(ones(rows,columns));
    else
        k = find(sigma <= 0);
        tmp = NaN;
        r(k) = tmp(ones(size(k)));
    end
end
