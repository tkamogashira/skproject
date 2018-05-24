function [prodlog,outlog,acclog,statelog,ladderprodlog,ladderacclog] = ...
    getlogma(this,k,kconj,y,acc1,acc2,z1,z2,ladder,ladderacc,x)
%GETLOG   Get the log.

%   Author(s): V. Pellissier
%   Copyright 2005-2006 The MathWorks, Inc.

% Lattice
[prodlog,outlog,acclog,statelog] = super_getlog(this,k,kconj,y,acc1,acc2,z1,z2,x);

% Acclog
if length(kconj)>0
    acclog1  = get(getqloggerstruct(acc1,0));
    acclog1b = get(getqloggerstruct(x,1));
    acclog2  = get(getqloggerstruct(kconj,3));
    acclog.Min = min(min(acclog1.Min,acclog1b.Min),acclog2.Min);
    acclog.Max = max(max(acclog1.Max,acclog1b.Max),acclog2.Max);
    acclog.NOverflows = acclog1.NOverflows+acclog1b.NOverflows+acclog2.NOverflows;
end

% Ladder
ladderprodlog = get(getqloggerstruct(ladder,2));
ladderprodlog.Range = double(range(quantizer(...
    [this.fimath.ProductWordLength this.fimath2.ProductFractionLength])));
ladderacclog  = get(getqloggerstruct(ladderacc,0));
ladderacclog.Range = double(range(ladderacc));

% Number of Operations
outlog.NOperations = prod(size(y));
if length(ladder)<=length(k),
    prodlog.NOperations = (2*length(k)-1)*outlog.NOperations;
else
    prodlog.NOperations = 2*length(k)*outlog.NOperations;
end
acclog.NOperations = prodlog.NOperations;
ladderprodlog.NOperations = length(ladder)*outlog.NOperations;
ladderacclog.NOperations = (length(ladder)-1)*outlog.NOperations;

% Complex cases
if ~isreal(y),
    outlog.NOperations = 2*outlog.NOperations;
    if isreal(ladder),
        ladderprodlog.NOperations = 2*ladderprodlog.NOperations;
        ladderacclog.NOperations =  2*ladderacclog.NOperations;
    else
        ladderacclog.NOperations =  2*ladderacclog.NOperations+2*ladderprodlog.NOperations;
        ladderprodlog.NOperations = 4*ladderprodlog.NOperations;
    end
end
statelog.NOperations = max(length(k),length(ladder)-1)*outlog.NOperations;

if (isreal(k) && ~isreal(x)) ,
    prodlog.NOperations = 2*prodlog.NOperations;
    acclog.NOperations = 2*acclog.NOperations;
elseif (~isreal(k) && ~isreal(k)) || (isreal(x) && ~isreal(k)),
    acclog.NOperations = 2*acclog.NOperations + 2*prodlog.NOperations;
    prodlog.NOperations = 4*prodlog.NOperations;
end

% Cap the number of overflows in acc to 100% (necessary because we don't
% count the initialization of the acc when determining the number of
% operations)
acclog.NOverflows = min(acclog.NOverflows,acclog.NOperations);
ladderacclog.NOverflows = min(ladderacclog.NOverflows,ladderacclog.NOperations);

% [EOF]
