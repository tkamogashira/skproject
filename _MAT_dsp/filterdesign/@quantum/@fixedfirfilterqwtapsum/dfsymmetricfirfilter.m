function [y,zf,tapIndex] = dfsymmetricfirfilter(q,b,x,zi,tapIndex)

%   Author(s): R. Losada
%   Copyright 1988-2004 The MathWorks, Inc.

% Quantize input
x = quantizeinput(q,x);

% Requantize states to insure same format as input
if any([x.WordLength x.FractionLength]~=[zi.WordLength zi.FractionLength]),
    F = fimath('RoundMode', 'round', 'OverflowMode' , 'saturate');
    zi = fi(zi, 'Signed', zi.Signed, 'WordLength', x.WordLength, ...
        'FractionLength', x.FractionLength, 'fimath', F);
end

% Attach fimath to fis
x.fimath = q.TapSumfimath;
zi.fimath = q.TapSumfimath;
b.fimath = q.fimath;

% State structure
sStruct.states = zi;
sStruct.tapIndex = int32(tapIndex);

% Initialize tapsum
tapsumWL = q.TapSumfimath.SumWordLength;
tapsumFL = q.TapSumfimath.SumFractionLength;
tapsum = fi(0, 'Signed', true, 'WordLength', tapsumWL, ...
    'FractionLength', tapsumFL, 'fimath', q.fimath);

% Initialize accum
accWL = q.fimath.SumWordLength;
accFL = q.fimath.SumFractionLength;
acc = fi(0, 'Signed', true, 'WordLength', accWL, ...
    'FractionLength', accFL, 'fimath', q.fimath);

mathStruct.tapSum = tapsum;
mathStruct.accumulator = acc;

% Create y
if strcmpi(q.OutputMode, 'BestPrecision'),
    % Use accum precision
    yWL = accWL;
    yFL = accFL;
elseif strcmpi(q.OutputMode, 'AvoidOverflow'),
    yWL = q.OutputWordLength;
    yFL = q.privoutfl;
else
    yWL = q.OutputWordLength;
    yFL = q.OutputFracLength;
end
y = fi(zeros(size(x)), 'Signed', true, 'WordLength', yWL, ...
    'FractionLength', yFL, 'fimath', q.fimath);
  
% Call DLL
fidfsymmetricfirfilter(b,sStruct,mathStruct,x,y);

if strcmpi(q.OutputMode, 'BestPrecision'),
    % Trick for BestPrecision
    y = fi(y, 'Signed', true, 'WordLength', q.OutputWordLength, 'fimath', q.fimath); 
    q.privoutfl = y.FractionLength;
end

zf = sStruct.states;
tapIndex = double(sStruct.tapIndex);

