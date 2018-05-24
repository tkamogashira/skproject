function S = quantizestates(this, S)
%QUANTIZESTATES   Quantize the states.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

% S is a double, create a FI
stWL = this.privstatewl;
if isempty(stWL),
    S = fi(S);
else
    stFL = this.privstatefl;
    F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
    S = fi(S, 'Signed', true, 'WordLength', stWL, 'FractionLength', stFL, 'fimath', F);
end

% [EOF]
