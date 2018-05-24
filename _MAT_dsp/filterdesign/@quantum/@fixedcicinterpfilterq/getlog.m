function [outlog, intlog, comblog] = getlog(this,y,yIntOut,zInt,yCombOut,zComb,inlog)
%GETLOG   Get the log.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

outlog  = get(getqloggerstruct(y,0)); 
outlog.Range = double(range(y));
outlog.NOperations = prod(size(y));
if ~isreal(y),
    outlog.NOperations = 2*outlog.NOperations;
end

nchans = size(y,2);
nsec = length(zInt)/nchans;

for i=1:nsec,
    s  = get(getqloggerstruct(yIntOut{i},0));
    s.NOperations = thisintNops(this,inlog,outlog);
    s.Range = double(range(yIntOut{i}));
    intlog{i} = s;
    s  = get(getqloggerstruct(yCombOut{i},0));
    s.NOperations = thiscombNops(this,inlog,outlog);
    s.Range = double(range(yCombOut{i}));
    comblog{i} = s;
end

% Multiple channel support
for j = 2:nchans,
    offset = (j-1)*nsec;
    for i=1:nsec,
        s = intlog{i};
        aux  = get(getqloggerstruct(yIntOut{i+offset},0));
        s.Min = min(s.Min, aux.Min);
        s.Max = max(s.Max, aux.Max);
        s.NOverflows = s.NOverflows + aux.NOverflows;
        intlog{i} = s;
        
        s = comblog{i};
        aux  = get(getqloggerstruct(yCombOut{i+offset},0));
        s.Min = min(s.Min, aux.Min);
        s.Max = max(s.Max, aux.Max);
        s.NOverflows = s.NOverflows + aux.NOverflows;
        comblog{i} = s;
    end
end

% [EOF]
