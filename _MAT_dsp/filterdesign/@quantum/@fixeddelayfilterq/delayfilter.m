function [y,zf] = delayfilter(q,b,x,zi)
% DELAY Filter for DFILT.DELAY class in double single and fixed point
% precision mode

%   Author(s): M.Chugh
%   Copyright 2005-2006 The MathWorks, Inc.

% Quantize input
[x, inlog] = quantizeinput(q,x);

N = size(x,1);
if N>=b,
    y = [zi; x(1:N-b,:)];
    zf = x(N-b+1:N,:);
else
    y = zi(1:N,:);
    zf = [zi(N+1:b,:);x(1:N,:)];
end

%----------------------------------------------------------------------
% Logging: min/max, range
%----------------------------------------------------------------------
if isloggingon(q),
    f = fipref;
    %----------------------------------------------------------------------
    % Fixed-point logging: min/max, range
    %----------------------------------------------------------------------
    outlog  = get(getqloggerstruct(y,0));
    outlog.Range = double(range(y));
    if isreal(y)
        outlog.NOverflows  = length(find(y<outlog.Range(1)))+length(find(y>outlog.Range(2)));
    else
        outlog.NOverflows  = length(find(real(y)<outlog.Range(1)))+length(find(real(y)>outlog.Range(2)))+...
            length(find(imag(y)<outlog.Range(1)))+length(find(imag(y)>outlog.Range(2)));
    end
    outlog.NOperations = inlog.NOperations;
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.delayreport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.delayreport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog));
    end

    % Store Report in filterquantizer
    q.loggingreport = qlog;
end


% [EOF]
