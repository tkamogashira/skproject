function r = chi2rnd2(v,m,n);
%CHI2RND Random matrices from chi-square distribution.
%   R = CHI2RND(V) returns a matrix of random numbers chosen   
%   from the chi-square distribution with V degrees of freedom.
%   The size of R is the size of V.
%   Alternatively, R = CHI2RND(V,M,N) returns an M by N matrix. 

%   CHI2RND calls GAMRND since the chi-square distribution
%   is a special case of the gamma distribution. (See Devroye, page 403)

%   References:
%      [1]  L. Devroye, "Non-Uniform Random Variate Generation", 
%      Springer-Verlag, 1986

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:06 $

if nargin < 1,
    error('Requires at least one input argument.'); 
end

if nargin == 1
    [errorcode rows columns] = rndcheck(1,1,v);
end

if nargin == 2
    [errorcode rows columns] = rndcheck(2,1,v,m);
end

if nargin == 3
    [errorcode rows columns] = rndcheck(3,1,v,m,n);
end

if errorcode > 0
    error('Size information is inconsistent.');
end

%Initialize r to zero.
r = zeros(rows, columns);

% Call for gamma random numbers.
r = gamrnd(v ./ 2,2,rows,columns);

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
