function [ol,stl,npl,dpl,naccl,daccl] = getlog(this, ...
    y,states,num,den,numAcc,denAcc,x)
%GETLOG   Get the log.

%   Author(s): V. Pellissier
%   Copyright 2005-2006 The MathWorks, Inc.

ol  = get(getqloggerstruct(y,0)); 
ol.Range = double(range(y));

stl  = get(getqloggerstruct(states,0)); 
stl.Range = double(range(states));

npl = get(getqloggerstruct(num,2));
npl.Range = double(range(quantizer(...
    [this.fimath.ProductWordLength this.fimath.ProductFractionLength])));

if length(den)>1,
    dpl = get(getqloggerstruct(den,2));
else
    resetlog(den);
    dpl = get(getqloggerstruct(den,0));
end
dpl.Range = double(range(quantizer(...
    [this.fimath.ProductWordLength this.fimath2.ProductFractionLength])));

naccl = get(getqloggerstruct(numAcc,0)); 
naccl.Range = double(range(numAcc));

daccl = get(getqloggerstruct(denAcc,0)); 
daccl.Range = double(range(denAcc));

% Number of Operations
numcoeffs = prod(size(num));
dencoeffs = prod(size(den));

ol.NOperations = prod(size(y));
npl.NOperations = numcoeffs*ol.NOperations;
naccl.NOperations = max((numcoeffs-1),1)*ol.NOperations;
dpl.NOperations = (dencoeffs-1)*ol.NOperations;
daccl.NOperations = max((dencoeffs-1),1)*ol.NOperations;

% Complex cases
if ~isreal(y),
    ol.NOperations = 2*ol.NOperations;
end
stl.NOperations = max((numcoeffs-1),(dencoeffs-1))*ol.NOperations;

if ((isreal(den) && ~isreal(x)) || ...
        (isreal(x) && ~isreal(den))),
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
elseif ~isreal(den) && ~isreal(x),
    daccl.NOperations = 2*daccl.NOperations + 2*dpl.NOperations;
    dpl.NOperations = 4*dpl.NOperations;
    if isreal(num),
        npl.NOperations = 2*npl.NOperations;
        naccl.NOperations = 2*naccl.NOperations;
    else
        naccl.NOperations = 2*naccl.NOperations + 2*npl.NOperations;
        npl.NOperations = 4*npl.NOperations;
    end
else
    if ~isreal(num),
        npl.NOperations = 2*npl.NOperations;
        naccl.NOperations = 2*naccl.NOperations;
    end
end


% Cap the number of overflows in acc to 100% (necessary because we don't
% count the initialization of the acc when determining the number of
% operations)
naccl.NOverflows = min(naccl.NOverflows,naccl.NOperations);
daccl.NOverflows = min(daccl.NOverflows,daccl.NOperations);

% [EOF]

