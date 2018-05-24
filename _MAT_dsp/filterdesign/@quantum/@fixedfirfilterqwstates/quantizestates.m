function S = quantizestates(q, S)
%QUANTIZESTATES   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

F = fimath('RoundMode', 'round', 'OverflowMode' , 'saturate');
stWL = q.privstatewl;
if isempty(stWL),
    S = fi(S);
elseif q.privStateAutoScale,
    S = fi(S, 'Signed', true, 'WordLength', stWL, 'fimath', F);
else
    stFL = q.privstatefl;
    S = fi(S, 'Signed', true, 'WordLength', stWL, 'FractionLength', stFL, 'fimath', F);
end


% [EOF]
