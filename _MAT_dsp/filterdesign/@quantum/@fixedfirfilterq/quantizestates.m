function S = quantizestates(q, S)
%QUANTIZESTATES   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% S is a double, create a FI
stWL = q.privinwl;
if isempty(stWL),
    S = fi(S);
else
    stFL = q.privinfl;
    F = fimath('RoundMode', 'round', 'OverflowMode' , 'saturate');
    S = fi(S, 'Signed', true, 'WordLength', stWL, 'FractionLength', stFL, 'fimath', F);
end

% [EOF]
