function r = poissrnd(lambda,m,n)
%POISSRND Random matrices from Poisson distribution.
%   R = POISSRND(LAMBDA) returns a matrix of random numbers chosen   
%   from the Poisson distribution with parameter LAMBDA.
%
%   The size of R is the size of LAMBDA. Alternatively, 
%   R = POISSRND(LAMBDA,M,N) returns an M by N matrix. 
%
%   POISSRND uses a waiting time method.

%   References:
%      [1]  L. Devroye, "Non-Uniform Random Variate Generation", 
%      Springer-Verlag, 1986 page 504.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1997/11/29 01:46:24 $

if nargin <  1, 
    error('Requires at least one input argument.'); 
end

if nargin == 1
    [errorcode rows columns] = rndcheck(1,1,lambda);
end

if nargin == 2
    [errorcode rows columns] = rndcheck(2,1,lambda,m);
end

if nargin == 3
    [errorcode rows columns] = rndcheck(3,1,lambda,m,n);
end

if errorcode > 0
    error('Size information is inconsistent.');
end

%Initialize r to zero.
r = zeros(rows, columns);


p = zeros(rows,columns);
done = ones(rows,columns);

while any(any(done)) ~= 0
    p = p - log(rand(rows,columns));
    kc = [1:rows*columns]';
    k = find(p < lambda);
    if any(k)
        r(k) = r(k) + 1;
    end
    kc(k) = [];
    done(kc) = zeros(size(kc));
end
    

% Return NaN if LAMBDA is not positive.

tmp = NaN;
if any(any(lambda <= 0));
    if prod(size(lambda) == 1)
        r = tmp(ones(rows,columns));
    else
        k = find(lambda <= 0);
        r(k) = tmp(ones(size(k)));
    end
end
