function S = quantizeacc(q, S)
%QUANTIZEACC   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

WL = q.fimath.SumWordLength;
if isempty(WL),
    S = fi(S);
else
    FL = q.fimath.SumFractionLength;
    S = fi(S, 'Signed', true, 'WordLength', WL, 'FractionLength', FL, 'fimath', q.fimath);
end


% [EOF]
