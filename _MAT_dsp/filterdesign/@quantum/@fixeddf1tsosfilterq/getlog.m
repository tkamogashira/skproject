function [ol,sectinl,sectoutl,nstl,dstl,multl,npl,dpl,naccl,daccl] = getlog(this, ...
    y,instage,outstage,nstates,dstates,multiplicand,multiplicand2_logs,num,den,numAcc,denAcc,sv,issvnoteq2one,x)
%GETLOG   Get the log.

%   Author(s): V. Pellissier
%   Copyright 2005-2006 The MathWorks, Inc.

ol  = get(getqloggerstruct(y,0)); 
ol.Range = double(range(y));

sectinl  = get(getqloggerstruct(instage,0)); 
sectinl.Range = double(range(instage));

sectoutl  = get(getqloggerstruct(outstage,0)); 
sectoutl.Range = double(range(outstage));

nstl  = get(getqloggerstruct(nstates,0)); 
nstl.Range = double(range(nstates));

dstl  = get(getqloggerstruct(dstates,0)); 
dstl.Range = double(range(dstates));

multl  = get(getqloggerstruct(multiplicand,0)); 
multl.Range = double(range(multiplicand));

npl = get(getqloggerstruct(num,2));
npl.Range = double(range(quantizer(...
    [this.fimath.ProductWordLength this.fimath.ProductFractionLength])));

dpl = get(getqloggerstruct(den,2));
dpl.Range = double(range(quantizer(...
    [this.fimath.ProductWordLength this.fimath2.ProductFractionLength])));

% The filter that these logs refer to is in file
%
%    toolbox/filterdesign/src/filtstructs/include/df1tsos.h
%
% The line of C-code that justifies each call to getqloggerstruct is in a
% comment above the line where getqloggerstruct is used.
%
% 0 = Assignment, 1 = Sum, 2 = Product, 3 = Product register's Sum
%
if isreal(num) && ~isreal(multiplicand)
    % b is real and multiplicand is complex.
    % numAcc2 = b[coeff_offset+1]*multiplicand+zNum[state_offset+1];
    naccl = struct(getqloggerstruct(multiplicand,3));
else
    % b is real and multiplicand is real, or
    % b is complex.
    % numAcc2 = b[coeff_offset+1]*multiplicand+zNum[state_offset+1];
    naccl = get(getqloggerstruct(num,3));
end
naccl.Range = double(range(numAcc));

if isreal(den) && ~isreal(multiplicand)
    % a is real and multiplicand2 is complex
    % denAcc = a[coeff_offset+1]*multiplicand2+zDen[state_offset+1];
    daccl = multiplicand2_logs.ProductSum;
else
    % a is real and multiplicand2 is real, or
    % a is complex
    % denAcc = a[coeff_offset+1]*multiplicand2+zDen[state_offset+1];
    daccl = get(getqloggerstruct(den,3)); 
end

if all(issvnoteq2one),
    % All scale values are different than 1
    aux = get(getqloggerstruct(instage,1));
elseif any(issvnoteq2one),
    % At least one scale value is not equal to 1
    % denAcc = instage-zDen[state_offset]; // Casted to accum format even if 'CastBeforeSum' is off
    aux  = get(getqloggerstruct(instage,1));
    % denAcc = numAcc;
    aux1 = get(getqloggerstruct(denAcc,0));
    % denAcc -= zDen[state_offset]; // Don't cast to instage format if scale value is an exact one
    aux2 = get(getqloggerstruct(denAcc,1));
    aux.Min = min([aux.Min aux1.Min aux2.Min]);
    aux.Max = max([aux.Max aux1.Max aux2.Max]);
    if ~issvnoteq2one(1),
        % denAcc = x[i+k*nx]-zDen[state_offset];
        aux3 = get(getqloggerstruct(x,1));
        aux.Min = min(aux.Min,aux2.Min);
        aux.Max = max(aux.Max,aux2.Max);
        aux.NOverflows = aux.NOverflows + aux2.NOverflows; 
    end
else
    % All scale values equal to 1
    % denAcc = x[i+k*nx]-zDen[state_offset];
    aux  = get(getqloggerstruct(x,1));
    % denAcc = numAcc;
    aux1 = get(getqloggerstruct(denAcc,0));
    % denAcc -= zDen[state_offset]; // Don't cast to instage format if scale value is an exact one
    aux2 = get(getqloggerstruct(denAcc,1));
    aux.Min = min([aux.Min aux1.Min aux2.Min]);
    aux.Max = max([aux.Max aux1.Max aux2.Max]);
    aux.NOverflows = aux.NOverflows + ...
        aux1.NOverflows + ...
        aux2.NOverflows;
end
daccl.Min = min(daccl.Min,aux.Min);
daccl.Max = max(daccl.Max,aux.Max);
daccl.NOverflows = daccl.NOverflows + aux.NOverflows;
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
nstl.NOperations = (numcoeffs-nsections)*ol.NOperations;
dstl.NOperations = (dencoeffs-nsections)*ol.NOperations;
multl.NOperations = nsections*ol.NOperations;

if any(issvnoteq2one),
    sectinl.NOperations = length(find(issvnoteq2one))*ol.NOperations;
    sectoutl.NOperations = length(find(issvnoteq2one))*ol.NOperations;
else
    sectinl.NOperations = 0;
    sectoutl.NOperations = 0;
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

