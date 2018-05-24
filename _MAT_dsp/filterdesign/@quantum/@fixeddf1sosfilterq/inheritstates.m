function inheritstates(q,S)
%INHERITSTATES   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% S is a FILTSTATES.DFIIR containing FIs
if ~isempty(S.Numerator),
    q.privnstatewl = S.Numerator.WordLength;
    q.privnstatefl = S.Numerator.FractionLength;
end
if ~isempty(S.Denominator),
    q.privdstatewl = S.Denominator.WordLength;
    q.privdstatefl = S.Denominator.FractionLength;
end

% [EOF]
