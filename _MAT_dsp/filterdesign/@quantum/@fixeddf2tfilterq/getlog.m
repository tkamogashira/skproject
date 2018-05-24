function [ol,stl,npl,dpl,naccl,daccl] = getlog(this, ...
    y,states,num,den,numAcc,denAcc,x)
%GETLOG   Get the log.

%   Author(s): V. Pellissier
%   Copyright 2005-2006 The MathWorks, Inc.

ol  = get(getqloggerstruct(y,0)); 
ol.Range = double(range(y));

temp = get(getqloggerstruct(states,1));
stl  = get(getqloggerstruct(states,0)); 
stl.Min = min(temp.Min,stl.Min);
stl.Max = max(temp.Max,stl.Max);
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

% The filter that these logs refer to is in file
%
%    toolbox/filterdesign/src/filtstructs/include/df2t.h
%
% The line of C-code that justifies each call to getqloggerstruct is in a
% comment above the line where getqloggerstruct is used.
%
% 0 = Assignment, 1 = Sum, 2 = Product, 3 = Product register's Sum
%
if isreal(num) && ~isreal(x)
    % b is real and x is complex.
    % numAcc = b[0]*x[k+xIndexOffset] + z[zIndexOffset];
    naccl = get(getqloggerstruct(x,3)); 
else
    % b is real and x is real, or
    % b is complex.
    % numAcc = b[0]*x[k+xIndexOffset] + z[zIndexOffset];
    naccl = get(getqloggerstruct(num,3)); 
end
% numAcc = b[0]*x[k+xIndexOffset];
temp = get(getqloggerstruct(num,0));
naccl.Min = min(temp.Min,naccl.Min);
naccl.Max = max(temp.Max,naccl.Max);
naccl.Range = double(range(numAcc));

% denAcc = z[j+1+zIndexOffset];
daccl = get(getqloggerstruct(denAcc,0)); 
% denAcc -= a[j+1]*y[k+xIndexOffset];
temp = get(getqloggerstruct(denAcc,1)); 
daccl.Min = min(temp.Min,daccl.Min);
daccl.Max = max(temp.Max,daccl.Max);
daccl.Range = double(range(denAcc));

% Number of Operations
numcoeffs = prod(size(num));
dencoeffs = prod(size(den));

ol.NOperations = prod(size(y));
npl.NOperations = numcoeffs*ol.NOperations;
naccl.NOperations = max((numcoeffs-1),1)*ol.NOperations;
dpl.NOperations = (dencoeffs-1)*ol.NOperations;
daccl.NOperations = (dencoeffs-1)*ol.NOperations;

% Complex cases
if ~isreal(y),
    ol.NOperations = 2*ol.NOperations;
end
stl.NOperations = max((numcoeffs-1),(dencoeffs-1))*ol.NOperations;

if (isreal(num) && ~isreal(x)) || (isreal(x) && ~isreal(num)),
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
elseif ~isreal(num) && ~isreal(x),
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
