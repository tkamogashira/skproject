function r = frnd(v1,v2,m,n);
%FRND   Random matrices from the F distribution.
%   R = FRND(V1,V2) returns a matrix of random numbers chosen   
%   from the F distribution with parameters V1 and V2.
%   The size of R is the common size of V1 and V2 if both are matrices.
%   If either parameter is a scalar, the size of R is the size of the other
%   parameter. Alternatively, R = FRND(V1,V2,M,N) returns an M by N matrix. 

%   FRND calls BETARND.
%   See Devroye, Theorem 4.1 on page 430, case D.

%   References:
%      [1]  L. Devroye, "Non-Uniform Random Variate Generation", 
%      Springer-Verlag, 1986

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:22 $

if nargin < 2, 
    error('Requires at least two input arguments.'); 
end

if nargin == 2
    [errorcode rows columns] = rndcheck(2,2,v1,v2);
end

if nargin == 3
    [errorcode rows columns] = rndcheck(3,2,v1,v2,m);
end

if nargin == 4
    [errorcode rows columns] = rndcheck(4,2,v1,v2,m,n);
end

if errorcode > 0
    error('Size information is inconsistent.');
end

num = chi2rnd(v1,rows,columns) ./ v1;
den = chi2rnd(v2,rows,columns) ./ v2;
r = num ./ den;

% Return NaN if V1 is a not positive integer.
if any(any(v1 <= 0)) | any(any(v1 ~= round(v1)));
    if prod(size(v1) == 1)
        tmp = NaN;
        r = tmp(ones(rows,columns));
    else
        k = find(v1 <= 0);
        tmp = NaN;
        r(k) = tmp(ones(size(k)));
    end
end

% Return NaN if V2 is a not positive integer.
if any(any(v2 <= 0)) | any(any(v2 ~= round(v2)));
    if prod(size(v2) == 1)
        tmp = NaN;
        r = tmp(ones(rows,columns));
    else
        k = find(v2 <= 0);
        tmp = NaN;
        r(k) = tmp(ones(size(k)));
    end
end
