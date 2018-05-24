function [prodlog,outlog,acclog] = getlog(this,b,y,acc,x,inlog)
%GETLOG   

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

[prodlog,outlog,acclog] = super_getlog(this,b,y,acc);

% Number of Operations
L = size(b,2);
ncoeffs = prod(size(b));
outlog.NOperations = prod(size(y));
prodlog.NOperations = ncoeffs*outlog.NOperations/L;
acclog.NOperations = max((ncoeffs-L)/L,1)*outlog.NOperations;

% Complex cases
if ~isreal(y),
    outlog.NOperations = 2*outlog.NOperations;
end
if (isreal(b) && ~isreal(x)) || (isreal(x) && ~isreal(b)),
    prodlog.NOperations = 2*prodlog.NOperations;
    acclog.NOperations = 2*acclog.NOperations;
elseif ~isreal(b) && ~isreal(x),
    prodlog.NOperations = 4*prodlog.NOperations;
    acclog.NOperations = 2*acclog.NOperations + 2*prodlog.NOperations;
end

% Cap the number of overflows in acc to 100% (necessary because we don't
% count the initialization of the acc when determining the number of
% operations)
acclog.NOverflows = min(acclog.NOverflows,acclog.NOperations);

% [EOF]
