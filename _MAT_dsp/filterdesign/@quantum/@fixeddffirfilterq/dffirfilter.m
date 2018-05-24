function [y,z,tapidx] = dffirfilter(q,b,x,z,tapidx)
%DFFIRFILTER   Filtering method for DFFIR.

%   Author(s): R. Losada
%   Copyright 1999-2005 The MathWorks, Inc.

% Re-construct FI coeff for DataTypeOverride to work all the time
b = fi(b);
resetlog(b);

% Quantize input
[x, inlog] = quantizeinput(q,x);

% Quantize states
F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
z = fi(z, 'Signed', z.Signed, 'WordLength', q.privinwl, ...
    'FractionLength', q.privinfl, 'fimath', F);
resetlog(z);

% Attach fimath to fis
x.fimath = q.fimath;
b.fimath = q.fimath;
z.fimath = q.fimath;

% Initialize accum
accWL = q.fimath.SumWordLength;
accFL = q.fimath.SumFractionLength;
acc = fi(zeros(1,size(x,2)), 'Signed', true, 'WordLength', accWL, ...
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

% State structure
stateStruct.states = z;
stateStruct.tapIndex = int32(tapidx);

% Call Mex
fidffirfilter(b,stateStruct,acc,x,y);

% NOTE: Even though the in-place update to the structure implies that z and
% tapidx have already been updated, we need this assignment AND we need to
% return them both as a left hand side. Otherwise they are not updated
% correctly. This happens with fixed-point only, but it may be related to
% the fact that we pass in a structure...
z = stateStruct.states;
tapidx = stateStruct.tapIndex;

%----------------------------------------------------------------------
% Logging: min/max, range
%----------------------------------------------------------------------
if isloggingon(q),
    f = fipref;
    [prodlog, outlog, acclog] = getlog(q,b,y,acc,x,inlog);
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.dffirreport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog), ...
            quantum.fixedlog(prodlog), ...
            quantum.fixedlog(acclog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.dffirreport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog), ...
            quantum.doublelog(prodlog), ...
            quantum.doublelog(acclog));
    end
    
    % Store Report in filterquantizer
    q.loggingreport = qlog;
end
