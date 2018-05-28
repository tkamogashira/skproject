function r = unifrnd(a,b,m,n)
%UNIFRND Random matrices from continuous uniform distribution.
%   R = UNIFRND(A,B) returns a matrix of random numbers chosen   
%   from the continous uniform distribution on the interval from A to B.
%   The size of R is the common size of A and B if both are matrices.
%   If either parameter is a scalar, the size of R is the size of the other
%   parameter. Alternatively, R = UNIFRND(A,B,M,N) returns an M by N matrix. 

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:47:02 $

if nargin < 2, 
   error('Requires at least two input arguments.'); 
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

% Initialize R to zero.
r = zeros(rows,columns);

r = a + (b-a) .* rand(rows,columns);

% A is the lower limit, so it must be less than B.
k = find(a >= b);
if any(k)
        tmp = NaN;
   r(k) = tmp(ones(size(k)));
end
