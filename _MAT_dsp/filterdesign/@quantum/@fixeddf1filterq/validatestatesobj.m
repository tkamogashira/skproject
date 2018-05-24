function S = validatestatesobj(q, S)
%VALIDATESTATESOBJ   

%   Author(s): V. Pellissier
%   Copyright 1988-2004 The MathWorks, Inc.

lclvalidatestates(q,S.Numerator);
lclvalidatestates(q,S.Denominator);

if q.InheritSettings && strcmpi(class(S.Numerator), 'embedded.fi'),
    inheritstates(q,S);
else
    S = quantizestates(q,S);
end


%--------------------------------------------------------------------------
function S = lclvalidatestates(q,S);

if isempty(S),
    % Need empty fi
    S = fi([]);
end


% [EOF]
