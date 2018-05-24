function [y,zf] = dffirtfilter(q,b,x,zi)

%   Author(s): R. Losada
%   Copyright 1988-2004 The MathWorks, Inc.

% Quantize input
x = quantizeinput(q,x);

% Quantize states
F = fimath('RoundMode', 'round', 'OverflowMode' , 'saturate');
zi = fi(zi, 'Signed', zi.Signed, 'WordLength', q.privstatewl, ...
    'FractionLength', q.privstatefl, 'fimath', F);

% Attach fimath to fis
x.fimath = q.fimath;
b.fimath = q.fimath;
zi.fimath = q.fimath;

% Initialize accum
accWL = q.fimath.SumWordLength;
accFL = q.fimath.SumFractionLength;
acc = fi(0, 'Signed', true, 'WordLength', accWL, ...
    'FractionLength', accFL, 'fimath', q.fimath);

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
fidffirtfilter(b,zi,acc,x,y);

zf = zi;

if strcmpi(q.OutputMode, 'BestPrecision'),
    % Trick for BestPrecision
    y = fi(y, 'Signed', true, 'WordLength', q.OutputWordLength, 'fimath', q.fimath); 
    q.privoutfl = y.FractionLength;
end
