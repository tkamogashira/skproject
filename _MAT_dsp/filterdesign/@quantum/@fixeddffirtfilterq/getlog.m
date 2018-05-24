function [prodlog,outlog,acclog,statelog] = getlog(this,b,y,acc,z,x,inlog)
%GETLOG   

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

prodlog = get(getqloggerstruct(b,2));
prodlog.Range = double(range(quantizer(...
    [this.fimath.ProductWordLength this.fimath.ProductFractionLength])));

outlog  = get(getqloggerstruct(y,0)); 
outlog.Range = double(range(y));

% toolbox/filterdesign/src/filtstructs/include/dffirt.h
% acc = b(j) * x(i,k) + z(j,k)
if isreal(b) && ~isreal(x)
    acclog  = get(getqloggerstruct(x,3));
else
    acclog  = get(getqloggerstruct(b,3)); 
end
acclog.Range = double(range(acc));

statelog  = get(getqloggerstruct(z,0));
statelog.Range = double(range(z));

% Number of Operations
ncoeffs = prod(size(b));
outlog.NOperations = prod(size(y));
prodlog.NOperations = ncoeffs*outlog.NOperations;
acclog.NOperations = (ncoeffs-1)*outlog.NOperations;
statelog.NOperations = (ncoeffs-1)*outlog.NOperations;

% Complex cases
if ~isreal(y),
    outlog.NOperations = 2*outlog.NOperations;
end
if (isreal(b) && ~isreal(x)) || (isreal(x) && ~isreal(b)),
    prodlog.NOperations = 2*prodlog.NOperations;
    acclog.NOperations = 2*acclog.NOperations;
    statelog.NOperations = 2*statelog.NOperations;
elseif ~isreal(b) && ~isreal(x),
    prodlog.NOperations = 4*prodlog.NOperations;
    acclog.NOperations = 2*acclog.NOperations + 2*prodlog.NOperations;
    statelog.NOperations = 2*statelog.NOperations;
end

% Cap the number of overflows in acc to 100% (necessary because we don't
% count the initialization of the acc when determining the number of
% operations)
acclog.NOverflows = min(acclog.NOverflows,acclog.NOperations);

% [EOF]
