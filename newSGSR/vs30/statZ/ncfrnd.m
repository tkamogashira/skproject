function r = ncfrnd(nu1,nu2,delta,m,n)
%NCFRND Random matrices from the noncentral F distribution.
%   R = NCFRND(NU1,NU2,DELTA) returns a matrix of random numbers chosen   
%   from the noncentral F distribution with parameters NU1, NU2 and DELTA.
%
%   The size of R is the common size of NU1, NU2 and DELTA if all are matrices.
%   If either parameter is a scalar, the size of R is the size of the other
%   parameter. Alternatively, R = NCFRND(NU1,NU2,DELTA,M,N) returns an M by N  
%   matrix.

%   Reference:
%      [1]  Evans, Merran, Hastings, Nicholas and Peacock, Brian,
%      "Statistical Distributions, Second Edition", Wiley
%      1993 p. 73-74.

%   B.A. Jones 2-7-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.4 $  $Date: 1997/11/29 01:46:02 $

if nargin < 3, 
    error('Requires at least three input arguments.');
end

if nargin == 3
    [errorcode rows columns] = rndcheck(3,3,nu1,nu2,delta);
end

if nargin == 4
    [errorcode rows columns] = rndcheck(4,3,nu1,nu2,delta,m);
end

if nargin == 5
    [errorcode rows columns] = rndcheck(5,3,nu1,nu2,delta,m,n);
end

if errorcode > 0
    error('Size information is inconsistent.');
end

%Initialize r to zero.
r = zeros(rows, columns);

r = (ncx2rnd(nu1,delta,rows,columns)./nu1)./ (chi2rnd(nu2,rows,columns) ./ nu2);

% Return NaN for values of NU1 and NU2 that are not positive integers.
if any(any(nu1 <= 0)) | any(any(nu1 ~= round(nu1))) | any(any(nu2 <= 0)) | any(any(nu2 ~= round(nu2)));
    if prod(size(nu1) == 1)
        tmp = NaN;
        r = tmp(ones(rows,columns));
    else
        k = find(nu1 <= 0);
        tmp = NaN;
        r(k) = tmp(ones(size(k)));
    end
end
