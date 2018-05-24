function [ol,nstl,dstl,npl,dpl,naccl,daccl] = getlog(this, ...
    y,zinum,outstage,num,den,numAcc,denAcc,sv,issvnoteq2one,x)
%GETLOG   Get the log.

%   Author(s): V. Pellissier
%   Copyright 2005-2006 The MathWorks, Inc.

ol  = get(getqloggerstruct(y,0)); 
ol.Range = double(range(y));

nstl  = get(getqloggerstruct(zinum,0)); 
nstl.Range = double(range(zinum));

dstl  = get(getqloggerstruct(outstage,0)); 
dstl.Range = double(range(outstage));

npl = get(getqloggerstruct(num,2));
npl.Range = double(range(quantizer(...
    [this.fimath.ProductWordLength this.fimath.ProductFractionLength])));

dpl = get(getqloggerstruct(den,2));
dpl.Range = double(range(quantizer(...
    [this.fimath.ProductWordLength this.fimath2.ProductFractionLength])));

naccl = get(getqloggerstruct(numAcc,0)); 
naccl.Range = double(range(numAcc));

daccl = get(getqloggerstruct(denAcc,0)); 
daccl.Range = double(range(denAcc));

% Number of Operations
numcoeffs = prod(size(num));
dencoeffs = prod(size(den));
nsections = length(issvnoteq2one)-1;

ol.NOperations = prod(size(y));
nstl.NOperations = (numcoeffs-nsections)*ol.NOperations;
dstl.NOperations = (dencoeffs-nsections)*ol.NOperations;
npl.NOperations = numcoeffs*ol.NOperations;
naccl.NOperations = (numcoeffs-nsections)*ol.NOperations;
dpl.NOperations = (dencoeffs-nsections)*ol.NOperations;
daccl.NOperations = (dencoeffs-nsections)*ol.NOperations;

% Complex cases
if ~isreal(y),
    ol.NOperations = 2*ol.NOperations;
end
if (isreal(num) && (~isreal(x)||~isreal(sv))) || (isreal(x) && isreal(sv) && ~isreal(num)),
    % Real coeff/Complex input or Complex coeff/Real input
    npl.NOperations = 2*npl.NOperations;
    naccl.NOperations = 2*naccl.NOperations;
    if isreal(den),
        dpl.NOperations = 2*dpl.NOperations;
        daccl.NOperations = 2*daccl.NOperations;
    else
        daccl.NOperations = 2*daccl.NOperations + 2*dpl.NOperations;
        dpl.NOperations = 4*dpl.NOperations;
    end
elseif ~isreal(num) && (~isreal(x)||~isreal(sv)),
    naccl.NOperations = 2*naccl.NOperations + 2*npl.NOperations;
    npl.NOperations = 4*npl.NOperations;
    if isreal(den),
        dpl.NOperations = 2*dpl.NOperations;
        daccl.NOperations = 2*daccl.NOperations;
    else
        daccl.NOperations = 2*daccl.NOperations + 2*dpl.NOperations;
        dpl.NOperations = 4*dpl.NOperations;
    end
end

% Cap the number of overflows in acc to 100% (necessary because we don't
% count the initialization of the acc when determining the number of
% operations)
naccl.NOverflows = min(naccl.NOverflows,naccl.NOperations);
daccl.NOverflows = min(daccl.NOverflows,daccl.NOperations);

% [EOF]
