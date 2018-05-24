function [ol,sectinl,sectoutl,stl,npl,dpl,naccl,daccl] = getlog(this, ...
    y,instage,outstage,states,num,den,numAcc,denAcc,sv,issvnoteq2one,x)
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
npl.Range = double(range(quantizer(...
    [this.fimath.ProductWordLength this.fimath.ProductFractionLength])));

dpl = get(getqloggerstruct(den,2));
dpl.Range = double(range(quantizer(...
    [this.fimath.ProductWordLength this.fimath2.ProductFractionLength])));

% The filter that these logs refer to is in file
%
%    toolbox/filterdesign/src/filtstructs/include/df2tsos.h
%
% The line of C-code that justifies each call to getqloggerstruct is in a
% comment above the line where getqloggerstruct is used.
%
% 0 = Assignment, 1 = Sum, 2 = Product, 3 = Product register's Sum
%
if isreal(num) && ~isreal(instage)
    % b is real and instage is complex.
    % numAcc = b[coeff_offset]*instage+z[state_offset];
    naccl = get(getqloggerstruct(instage,3)); 
else
    % b is real and instage is real, or
    % b is complex.
    % numAcc = b[coeff_offset]*instage+z[state_offset];
    naccl = get(getqloggerstruct(num,3)); 
end
naccl.Range = double(range(numAcc));

% denAcc = numAcc;
daccl = get(getqloggerstruct(denAcc,0)); 
% denAcc -= a[coeff_offset+1]*outstage;
temp = get(getqloggerstruct(denAcc,1)); 
daccl.Min = min(temp.Min,daccl.Min);
daccl.Max = max(temp.Max,daccl.Max);
daccl.Range = double(range(denAcc));

% Number of Operations
numcoeffs = prod(size(num));
dencoeffs = prod(size(den));
nsections = length(issvnoteq2one)-1;

ol.NOperations = prod(size(y));
npl.NOperations = numcoeffs*ol.NOperations;
naccl.NOperations = (numcoeffs-nsections)*ol.NOperations;
dpl.NOperations = (dencoeffs-nsections)*ol.NOperations;
daccl.NOperations = (dencoeffs-nsections)*ol.NOperations;

% Complex cases
if ~isreal(y),
    ol.NOperations = 2*ol.NOperations;
end
sectinl.NOperations = length(issvnoteq2one)*ol.NOperations;
sectoutl.NOperations = length(issvnoteq2one)*ol.NOperations;
stl.NOperations = max((numcoeffs-nsections),(dencoeffs-nsections))*ol.NOperations;

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

