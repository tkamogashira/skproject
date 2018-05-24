function [y,z] = dffirtfilter(q,b,x,z)
%DFFIRTFILTER   Filtering method for DFFIRT.

%   Author(s): R. Losada
%   Copyright 1988-2005 The MathWorks, Inc.

% Re-construct FI coeff for DataTypeOverride to work all the time
b = fi(b);
resetlog(b);

% Quantize input
[x, inlog] = quantizeinput(q,x);

% Quantize states
F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
z = fi(z, 'Signed', true, 'WordLength', q.privstatewl, ...
    'FractionLength', q.privstatefl, 'fimath', F);
resetlog(z);

% Attach fimath to fis
x.fimath = q.fimath;
b.fimath = q.fimath;
z.fimath = q.fimath;

% Initialize accum
accWL = q.fimath.SumWordLength;
accFL = q.fimath.SumFractionLength;
acc = fi(0, 'Signed', true, 'WordLength', accWL, ...
    'FractionLength', accFL, 'fimath', q.fimath);
% Disable cast before sum
acc.fimath.CastBeforeSum = false;
resetlog(acc);

% Create y
yWL = q.OutputWordLength;
yFL = q.OutputFracLength;
y = fi(zeros(size(x)), 'Signed', true, 'WordLength', yWL, ...
    'FractionLength', yFL, 'fimath', q.fimath);
resetlog(y);


% Call Mex
fidffirtfilter(b,z,acc,x,y);

if isloggingon(q),
    f = fipref;
    %----------------------------------------------------------------------
    % Fixed-point logging: min/max, range
    %----------------------------------------------------------------------
    [prodlog, outlog, acclog, statelog] = getlog(q,b,y,acc,z,x,inlog);
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.dffirtreport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog), ...
            quantum.fixedlog(statelog), ...
            quantum.fixedlog(prodlog), ...
            quantum.fixedlog(acclog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.dffirtreport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog), ...
            quantum.doublelog(statelog), ...
            quantum.doublelog(prodlog), ...
            quantum.doublelog(acclog));
    end

    % Store Report in filterquantizer
    q.loggingreport = qlog;
end

