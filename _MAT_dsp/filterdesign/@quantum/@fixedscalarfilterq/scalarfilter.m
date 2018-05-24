function [y,zf] = scalarfilter(q,b,x,zi)
% SCALARFILTER Filter for DFILT.SCALAR class in fixed-point

%   Author(s): V.Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.

% Re-construct FI coeff for DataTypeOverride to work all the time
b = fi(b);
resetlog(b);

% Quantize input
[x, inlog] = quantizeinput(q,x);

F = q.fimath;
% Full precision product
p = F.mpy(b,x);

if strcmpi(q.OutputMode, 'BestPrecision'),
    % Trick for BestPrecision
    y = fi(p.data, 'Signed', true, 'WordLength', q.OutputWordLength, 'fimath', q.fimath);
    q.privoutfl = y.FractionLength;
else
    y = fi(p.data, 'Signed', true, 'WordLength', q.OutputWordLength, ...
        'FractionLength', q.privoutfl, 'fimath', q.fimath);
end

zf = zi;

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
    outlog.NOperations = inlog.NOperations;
    if ~isreal(b),
        if isreal(x),
            outlog.NOperations = 2*outlog.NOperations;
        else
            outlog.NOperations = 3*outlog.NOperations;
        end
    end

    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.scalarreport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.scalarreport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog));
    end

    % Store Report in filterquantizer
    q.loggingreport = qlog;
end


% [EOF]
