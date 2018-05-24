function [y,z,tapIndex] = dfantisymmetricfirfilter(q,b,x,z,tapIndex)

%   Author(s): R. Losada
%   Copyright 1988-2005 The MathWorks, Inc.

% Re-construct FI coeff for DataTypeOverride to work all the time
b = fi(b);
resetlog(b);

% Quantize input
[x, inlog] = quantizeinput(q,x);

% Requantize states to insure same format as input
if any([x.WordLength x.FractionLength]~=[z.WordLength z.FractionLength]),
    F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
    z = fi(z, 'Signed', z.Signed, 'WordLength', x.WordLength, ...
        'FractionLength', x.FractionLength, 'fimath', F);
end
resetlog(z);

% Attach fimath to fis
x.fimath = q.TapSumfimath;
z.fimath = q.TapSumfimath;
b.fimath = q.fimath;

% State structure
sStruct.states = z;
sStruct.tapIndex = int32(tapIndex);

% Initialize tapsum
tapsumWL = q.TapSumfimath.SumWordLength;
tapsumFL = q.TapSumfimath.SumFractionLength;
tapsum = fi(0, 'Signed', true, 'WordLength', tapsumWL, ...
    'FractionLength', tapsumFL, 'fimath', q.fimath);
resetlog(tapsum);

% Initialize accum
accWL = q.fimath.SumWordLength;
accFL = q.fimath.SumFractionLength;
acc = fi(0, 'Signed', true, 'WordLength', accWL, ...
    'FractionLength', accFL, 'fimath', q.fimath);
resetlog(acc);

mathStruct.tapSum = tapsum;
mathStruct.accumulator = acc;

% Create y
yWL = q.OutputWordLength;
yFL = q.OutputFracLength;
y = fi(zeros(size(x)), 'Signed', true, 'WordLength', yWL, ...
    'FractionLength', yFL, 'fimath', q.fimath);
resetlog(y);

% Call Mex
fidfantisymmetricfirfilter(b,sStruct,mathStruct,x,y);

z = sStruct.states;
tapIndex = double(sStruct.tapIndex);

if isloggingon(q),
    f = fipref;
    %----------------------------------------------------------------------
    % Fixed-point logging: min/max, range
    %----------------------------------------------------------------------
    [prodlog, outlog, acclog, tapsumlog] = getasymlog(q,b,y,acc,tapsum,x,inlog);
    %----------------------------------------------------------------------
    % Build Report
    %----------------------------------------------------------------------
    if strcmpi(f.DataTypeOverride , 'forceoff'),
        qlog = quantum.dfasymfirreport('Fixed', ...
            quantum.fixedlog(inlog), ...
            quantum.fixedlog(outlog), ...
            quantum.fixedlog(prodlog), ...
            quantum.fixedlog(acclog),...
            quantum.fixedlog(tapsumlog));
    elseif strcmpi(f.DataTypeOverride , 'ScaledDoubles')
        qlog = quantum.dfasymfirreport('Double', ...
            quantum.doublelog(inlog), ...
            quantum.doublelog(outlog), ...
            quantum.doublelog(prodlog), ...
            quantum.doublelog(acclog),...
            quantum.doublelog(tapsumlog));
    end

    % Store Report in filterquantizer
    q.loggingreport = qlog;
end

