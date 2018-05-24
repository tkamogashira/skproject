function S = quantizestates(q, S)
%QUANTIZESTATES   

%   Author(s): V. Pellissier
%   Copyright 1999-2005 The MathWorks, Inc.

stWL = q.privstatewl;
if isempty(stWL),
    S = fi(S);
else
    stFL = q.privstatefl;
    F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
    S = fi(S, 'Signed', true, 'WordLength', stWL, ...
        'FractionLength', stFL, 'fimath', F);
end


% [EOF]
