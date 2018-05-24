function [prodlog,outlog,acclog,statelog] = super_getlog(this,k,kconj,y,acc1,acc2,z1,z2,x)
%SUPER_GETLOG   

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

if isempty(k),
    prodlog.Min = realmax;
    prodlog.Max = realmin;
    prodlog.NOverflows = 0;
    acclog.Min = realmax;
    acclog.Max = realmin;
    acclog.NOverflows = 0;
else
    % Product logs
    prodlog1 = get(getqloggerstruct(k,2));
    prodlog2 = get(getqloggerstruct(kconj,2));
    prodlog.Min = min(prodlog1.Min,prodlog2.Min);
    prodlog.Max = max(prodlog1.Max,prodlog2.Max);
    prodlog.NOverflows = prodlog1.NOverflows+prodlog2.NOverflows;
    
    % Accumulator logs
    n=1;
    temp(n) = struct(getqloggerstruct(acc1,0)); n=n+1;
    temp(n) = struct(getqloggerstruct(acc1,1)); n=n+1;
    temp(n) = struct(getqloggerstruct(x,1)); n=n+1;
    if isreal(k) && ~isreal(x)
        temp(n) = struct(getqloggerstruct(z1,3)); n=n+1;
    else
        temp(n) = struct(getqloggerstruct(k,3)); n=n+1;
    end
    acclog.Min = min([temp(:).Min]);
    acclog.Max = max([temp(:).Max]);
    acclog.NOverflows = sum([temp(:).NOverflows]);
end
prodlog.Range = double(range(quantizer(...
    [this.fimath.ProductWordLength this.fimath.ProductFractionLength])));
acclog.Range = double(range(acc1));

outlog  = get(getqloggerstruct(y,0)); 
outlog.Range = double(range(y));
outlog.NOperations = prod(size(y));

statelog  = get(getqloggerstruct(z1,0));
statelog.Range = double(range(z1));

% [EOF]

