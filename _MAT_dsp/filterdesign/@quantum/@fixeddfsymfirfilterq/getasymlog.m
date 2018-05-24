function [prodlog,outlog,acclog,tapsumlog] = getasymlog(this,b,y,acc,tapsum,x,inlog)
%GETASYMLOG   

%   Author(s): V. Pellissier
%   Copyright 2005-2006 The MathWorks, Inc.

[prodlog,outlog,acclog] = super_getlog(this,b,y,acc);

tapsumlog  = get(getqloggerstruct(tapsum,0)); 
tapsumlog.Range = double(range(tapsum));

% Number of Operations
ncoeffs = prod(size(b));
if rem(ncoeffs,2)==1,
    % Odd
    ncoeffs = max(1,(ncoeffs-1)/2);
else
    % Even
    ncoeffs = ncoeffs/2;
end
outlog.NOperations = prod(size(y));
prodlog.NOperations = ncoeffs*outlog.NOperations;
tapsumlog.NOperations = prodlog.NOperations;
acclog.NOperations = (ncoeffs-1)*outlog.NOperations;

% Complex cases
if (isreal(b) && ~isreal(x)) || (isreal(x) && ~isreal(b)),
    prodlog.NOperations = 2*prodlog.NOperations;
    acclog.NOperations = 2*acclog.NOperations;
    outlog.NOperations = 2*outlog.NOperations;
elseif ~isreal(b) && ~isreal(x),
    acclog.NOperations = 2*acclog.NOperations + 2*prodlog.NOperations;
    outlog.NOperations = 2*outlog.NOperations;
    prodlog.NOperations = 4*prodlog.NOperations;
end
if ~isreal(x),
    tapsumlog.NOperations = 2*tapsumlog.NOperations;
end


% [EOF]
