function inheritstates(q,S)
%INHERITSTATES   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% S is a FI
if ~isempty(S),
    q.privinwl = S.WordLength;
    q.privinfl = S.FractionLength;
end

% [EOF]
