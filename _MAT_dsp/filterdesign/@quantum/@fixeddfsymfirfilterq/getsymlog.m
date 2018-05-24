function [prodlog,outlog,acclog,tapsumlog] = getsymlog(this,b,y,acc,tapsum,x,inlog)
%GETSYMLOG   

%   Author(s): V. Pellissier
%   Copyright 2005-2006 The MathWorks, Inc.

[prodlog,outlog,acclog] = super_getlog(this,b,y,acc);

% Work around real coeff/complex input FI bug
aux = get(getqloggerstruct(tapsum,2)); 
prodlog.Max = max(prodlog.Max,aux.Max);
prodlog.Min = min(prodlog.Min,aux.Min);
prodlog.NOverflows = prodlog.NOverflows + aux.NOverflows;

tapsumlog  = get(getqloggerstruct(tapsum,0)); 
tapsumlog.Range = double(range(tapsum));


% Number of Operations
ncoeffs = prod(size(b));
outlog.NOperations = prod(size(y));
if rem(ncoeffs,2)==1,
    % Odd
    ncoeffs = (ncoeffs+1)/2;
    prodlog.NOperations = ncoeffs*outlog.NOperations;
    tapsumlog.NOperations = (ncoeffs-1)*outlog.NOperations;
else
    % Even
    ncoeffs = ncoeffs/2;
    prodlog.NOperations = ncoeffs*outlog.NOperations;
    tapsumlog.NOperations = prodlog.NOperations;
end
acclog.NOperations = (ncoeffs-1)*outlog.NOperations;

% Complex cases
if ~isreal(y),
    outlog.NOperations = 2*outlog.NOperations;
end
if (isreal(b) && ~isreal(x)) || (isreal(x) && ~isreal(b)),
    prodlog.NOperations = 2*prodlog.NOperations;
    acclog.NOperations = 2*acclog.NOperations;
elseif ~isreal(b) && ~isreal(x),
    acclog.NOperations = 2*acclog.NOperations + 2*prodlog.NOperations;
    prodlog.NOperations = 4*prodlog.NOperations;
end
if ~isreal(x),
    tapsumlog.NOperations = 2*tapsumlog.NOperations;
end

% Cap the number of overflows in acc to 100% (necessary because we don't
% count the initialization of the acc when determining the number of
% operations)
acclog.NOverflows = min(acclog.NOverflows,acclog.NOperations);

% [EOF]
