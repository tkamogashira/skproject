function [coeffStruct,zi,mathStruct,x,y,inlog] = input2latticearmex(q,k,kconj,x,zi)
%INPUT2LATTICEARMEX   

%   Author(s): V. Pellissier
%   Copyright 1999-2005 The MathWorks, Inc.

% Re-construct FI coeff for DataTypeOverride to work all the time
k = fi(k);
kconj = fi(kconj);
resetlog(k);
resetlog(kconj);

% Quantize input
[x, inlog] = quantizeinput(q,x);

% Requantize states
F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
zi = fi(zi, 'Signed', zi.Signed, 'WordLength', q.StateWordLength, ...
    'FractionLength', q.StateFracLength, 'fimath', F);
resetlog(zi);

% Attach fimath to fis
x.fimath = q.fimath;
k.fimath = q.fimath;
kconj.fimath = q.fimath;
zi.fimath = q.fimath;

% Coeff structure
coeffStruct.lattice = k;   
coeffStruct.conjlattice = kconj;

% Initialize accum
accWL = q.fimath.SumWordLength;
accFL = q.fimath.SumFractionLength;
acc = fi(0, 'Signed', true, 'WordLength', accWL, ...
    'FractionLength', accFL, 'fimath', q.fimath);
resetlog(acc);

% prevacc1 is the input of a multiplier and therefore the cast to the
% state format.
prevacc1 = fi(0, 'Signed', zi.Signed, 'WordLength', q.StateWordLength, ...
    'FractionLength', q.StateFracLength, 'fimath', q.fimath);
resetlog(prevacc1);
mathStruct.prevacc1 = prevacc1;
mathStruct.prevacc2 = copy(acc);
mathStruct.acc1 = copy(acc);
mathStruct.acc2 = copy(acc);

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
resetlog(y);

% [EOF]
