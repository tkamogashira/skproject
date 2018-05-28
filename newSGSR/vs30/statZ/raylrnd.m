function r = raylrnd(b,m,n)
%RAYLRND Random matrices from Rayleigh distribution.
%   R = RAYLRND(B) returns a matrix of random numbers chosen   
%   from the Rayleigh distribution with parameter B.
%
%   The size of R is the size of B.
%   Alternatively, R = RAYLRND(B,M,N) returns an M by N matrix. 

%   Reference:
%      [1]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 p. 134-136.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.4 $  $Date: 1997/11/29 01:46:34 $

if nargin <  1, 
    error('Requires at least one input argument.'); 
end

    
if nargin == 1
    [errorcode rows columns] = rndcheck(1,1,b);
end

if nargin == 2
    [errorcode rows columns] = rndcheck(2,1,b,m);
end

if nargin == 3
    [errorcode rows columns] = rndcheck(3,1,b,m,n);
end

if errorcode > 0
    error('Size information is inconsistent.');
end

%Initialize r to zero.
r = zeros(rows, columns);

r = sqrt(normrnd(0,b,rows,columns).^2 + normrnd(0,b,rows,columns).^2);

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
