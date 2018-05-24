function S = quantizeacc(q, S)
%QUANTIZEACC   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

WL = q.PolyAccfimath.SumWordLength;
if isempty(WL),
    S = fi(S);
else
    FL = q.PolyAccfimath.SumFractionLength;
    S = fi(S, 'Signed', true, 'WordLength', WL, 'FractionLength', FL, 'fimath', q.PolyAccfimath);
end


% [EOF]
