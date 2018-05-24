function [ol,sectinl,sectoutl,stl,npl,dpl,naccl,daccl] = getlog(this, ...
    y,instage,outstage,states,numProd,denProd,numAcc,denAcc,num,den,sv,issvnoteq2one,x)
%GETLOG   Get the log.

%   Author(s): V. Pellissier
%   Copyright 2005-2006 The MathWorks, Inc.

ol  = get(getqloggerstruct(y,0)); 
ol.Range = double(range(y));

sectinl  = get(getqloggerstruct(instage,0)); 
sectinl.Range = double(range(instage));

sectoutl  = get(getqloggerstruct(outstage,0)); 
sectoutl.Range = double(range(outstage));

stl  = get(getqloggerstruct(states,0)); 
stl.Range = double(range(states));

npl = get(getqloggerstruct(num,2));
npl.Range = double(range(numProd));

dpl = get(getqloggerstruct(den,2));
dpl.Range = double(range(denProd));

naccl = get(getqloggerstruct(numAcc,0)); 
naccl.Range = double(range(numAcc));

daccl = get(getqloggerstruct(denAcc,0)); 
daccl.Range = double(range(denAcc));

% Number of Operations
numcoeffs = prod(size(num));
dencoeffs = prod(size(den));
nsections = length(issvnoteq2one)-1;

ol.NOperations = prod(size(y));
if any(issvnoteq2one),
    sectinl.NOperations = length(find(issvnoteq2one))*ol.NOperations;
    sectoutl.NOperations = length(find(issvnoteq2one))*ol.NOperations;
else
    sectinl.NOperations = 0;
    sectoutl.NOperations = 0;
end

stl.NOperations = max((numcoeffs-nsections),(dencoeffs-nsections))*ol.NOperations;
npl.NOperations = numcoeffs*ol.NOperations;
naccl.NOperations = (numcoeffs-nsections)*ol.NOperations;
dpl.NOperations = (dencoeffs-nsections)*ol.NOperations;
daccl.NOperations = (dencoeffs-nsections)*ol.NOperations;

% Complex cases
if ~isreal(y),
    ol.NOperations = 2*ol.NOperations;
end
if ((isreal(den) && (~isreal(x)||~isreal(sv))) || ...
        (isreal(x) && isreal(sv) && ~isreal(den))),
    % Real coeff/Complex input or Complex coeff/Real input
    dpl.NOperations = 2*dpl.NOperations;
    daccl.NOperations = 2*daccl.NOperations;
    if isreal(num),
        npl.NOperations = 2*npl.NOperations;
        naccl.NOperations = 2*naccl.NOperations;
    else
        naccl.NOperations = 2*naccl.NOperations + 2*npl.NOperations;
        npl.NOperations = 4*npl.NOperations;
    end
elseif ~isreal(den) && (~isreal(x)||~isreal(sv)),
    daccl.NOperations = 2*daccl.NOperations + 2*dpl.NOperations;
    dpl.NOperations = 4*dpl.NOperations;
    if isreal(num),
        npl.NOperations = 2*npl.NOperations;
        naccl.NOperations = 2*naccl.NOperations;
    else
        naccl.NOperations = 2*naccl.NOperations + 2*npl.NOperations;
        npl.NOperations = 4*npl.NOperations;
    end
end

% Cap the number of overflows in acc to 100% (necessary because we don't
% count the initialization of the acc when determining the number of
% operations)
naccl.NOverflows = min(naccl.NOverflows,naccl.NOperations);
daccl.NOverflows = min(daccl.NOverflows,daccl.NOperations);

% [EOF]
