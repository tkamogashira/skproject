function [prodlog, outlog, acclog, multlog, fdprodlog] = getlog(this,C,Clast,p,plast,y,multlog,fdprodlog,d,x)
%GETLOG   Get the log.

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

prodlog1 = get(getqloggerstruct(C,2));
prodlog2 = get(getqloggerstruct(Clast,2));
prodlog.Min = min(prodlog1.Min,prodlog2.Min);
prodlog.Max = max(prodlog1.Max,prodlog2.Max);
prodlog.NOverflows = prodlog1.NOverflows+prodlog2.NOverflows;
prodlog.NUnderflows = prodlog1.NUnderflows+prodlog2.NUnderflows;

prodlog.Range = double(range(quantizer(...
    [this.fimath.ProductWordLength this.fimath.ProductFractionLength])));

outlog  = get(getqloggerstruct(y,0)); 
outlog.Range = double(range(y));

acclog1  = get(getqloggerstruct(p,0));
acclog2  = get(getqloggerstruct(plast,0));
acclog.Min = min(acclog1.Min,acclog2.Min);
acclog.Max = max(acclog1.Max,acclog2.Max);
acclog.NOverflows = acclog1.NOverflows+acclog2.NOverflows;
acclog.NUnderflows = acclog1.NUnderflows+acclog2.NUnderflows;
acclog.Range = double(range(p));

% Number of Operations
[npoly nphases] = size([C;Clast]);
ncoeffs = npoly*nphases;
outlog.NOperations = prod(size(y));
prodlog.NOperations = ncoeffs*outlog.NOperations;
acclog.NOperations = (ncoeffs-nphases)*outlog.NOperations;
multlog.NOperations = max(nphases-1,1)*outlog.NOperations;
fdprodlog.NOperations = multlog.NOperations;

% Complex cases
if ~isreal(y),
    outlog.NOperations = 2*outlog.NOperations;
end
if (isreal(C) && ~isreal(x)) || (isreal(x) && ~isreal(C)),
    prodlog.NOperations = 2*prodlog.NOperations;
    acclog.NOperations = 2*acclog.NOperations;
    if isreal(d)
        multlog.NOperations = 2*multlog.NOperations;
        fdprodlog.NOperations = 2*fdprodlog.NOperations;
    else
        multlog.NOperations = 4*multlog.NOperations;
        fdprodlog.NOperations = 4*fdprodlog.NOperations;
    end
elseif ~isreal(C) && ~isreal(x),
    prodlog.NOperations = 4*prodlog.NOperations;
    acclog.NOperations = 2*acclog.NOperations + 2*prodlog.NOperations;
    if isreal(d)
        multlog.NOperations = 2*multlog.NOperations;
        fdprodlog.NOperations = 2*fdprodlog.NOperations;
    else
        multlog.NOperations = 4*multlog.NOperations;
        fdprodlog.NOperations = 4*fdprodlog.NOperations;
    end
elseif ~isreal(d),
    multlog.NOperations = 2*multlog.NOperations;
    fdprodlog.NOperations = 2*fdprodlog.NOperations;
end

% Cap the number of overflows in acc to 100% (necessary because we don't
% count the initialization of the acc when determining the number of
% operations)
acclog.NOverflows = min(acclog.NOverflows,acclog.NOperations);

% [EOF]
