function y = holdinterpfilter(q,L,x,ny,nchans)
%HOLDINTERPFILTER

%   Author(s): V. Pellissier
%   Copyright 2005-2006 The MathWorks, Inc.

% Quantize input
[x, inlog] = quantizeinput(q,x);

y = zeros(ny,nchans);
y = quantizeinput(q,y);
resetlog(y);

for i=1:nchans,
    xi = x(:,i);
    y(:,i) = reshape(xi(:,ones(L,1)).',ny,1);
end

%----------------------------------------------------------------------
% Logging: min/max, range
%----------------------------------------------------------------------
if isloggingon(q),
    f = fipref;
    outlog  = get(getqloggerstruct(y,0));
    outlog.Range = double(range(y));
    outlog.NOperations = L*inlog.NOperations;
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.holdinterpreport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.holdinterpreport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog));
    end

    % Store Report in filterquantizer
    q.loggingreport = qlog;
end


% [EOF]
