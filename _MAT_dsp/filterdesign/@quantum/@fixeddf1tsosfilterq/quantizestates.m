function S = quantizestates(q, S)
%QUANTIZESTATES   

%   Author(s): V. Pellissier
%   Copyright 1999-2005 The MathWorks, Inc.

nstWL = q.privstatewl;
nstFL = q.privnstatefl;
dstWL = q.privstatewl;
dstFL = q.privdstatefl;

F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');

if isempty(nstWL),
    S.Numerator = fi(S.Numerator);
else
    S.Numerator = fi(S.Numerator, 'Signed', true, 'WordLength', nstWL, ...
        'FractionLength', nstFL, 'fimath', F);
end

if isempty(dstWL),
    S.Denominator = fi(S.Denominator);
else
    S.Denominator = fi(S.Denominator, 'Signed', true, 'WordLength', dstWL, ...
        'FractionLength', dstFL, 'fimath', F);
end


% [EOF]
