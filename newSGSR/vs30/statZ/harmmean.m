function m = harmmean(x)
%HARMMEAN Harmonic mean.
%   M = HARMMEAN(X) returns the harmonic mean of the data.
%   The harmonic mean is the inverse of the mean of the inverses 
%   of the elements.
%   For matrix X, HARMMEAN(X) returns a row vector containing
%   the harmonic mean of each column of X.

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:36 $

[nrow,ncol] = size(x);

% Turn row vectors into column vectors.
if nrow == 1,
    nrow = ncol;
    ncol = 1;
    x = x';
end

% Take the average of the reciprocals of the columns of X.
m = sum(ones(nrow,ncol)./ x) / nrow;

% Take the reciprocal of the above.
m = ones(1,ncol) ./ m;
