function [prodlog,outlog,acclog,statelog] = getlogar(this,k,kconj,y,acc1,acc2,z1,z2,x)
%GETLOGAR   Get the log.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

[prodlog,outlog,acclog,statelog] = super_getlog(this,k,kconj,y,acc1,acc2,z1,z2,x);

% Acclog
if length(kconj)>0
    n=1;
    temp(n) = struct(getqloggerstruct(acc1,0)); n=n+1;
    temp(n) = struct(getqloggerstruct(x,1)); n=n+1;
    if isreal(kconj) && ~isreal(x)
        temp(n) = struct(getqloggerstruct(z2,3)); n=n+1;
    else
        temp(n) = struct(getqloggerstruct(kconj,3)); n=n+1;
    end
    acclog.Min = min([temp(:).Min]);
    acclog.Max = max([temp(:).Max]);
    acclog.NOverflows = sum([temp(:).NOverflows]);
end

% Number of Operations
outlog.NOperations = prod(size(y));
prodlog.NOperations = (2*length(k)-1)*outlog.NOperations;
acclog.NOperations = prodlog.NOperations;
statelog.NOperations = length(k)*outlog.NOperations;

% Complex cases
if ~isreal(y),
    outlog.NOperations = 2*outlog.NOperations;
end
if (isreal(k) && ~isreal(x)) || (isreal(x) && ~isreal(k)),
    prodlog.NOperations = 2*prodlog.NOperations;
    acclog.NOperations = 2*acclog.NOperations;
elseif ~isreal(k) && ~isreal(k),
    prodlog.NOperations = 4*prodlog.NOperations;
    acclog.NOperations = 2*acclog.NOperations + 2*prodlog.NOperations;
end

% Cap the number of overflows in acc to 100% (necessary because we don't
% count the initialization of the acc when determining the number of
% operations)
acclog.NOverflows = min(acclog.NOverflows,acclog.NOperations);

% [EOF]
