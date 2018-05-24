function S = validatestates(q, S)
%VALIDATESTATES   

%   Author(s): M. Chugh
%   Copyright 2005 The MathWorks, Inc.

if isempty(S),
    % Need empty fi
    S = fi([]);
end

if q.InheritSettings && strcmpi(class(S), 'embedded.fi'),
    inheritstates(q,S);
else
    S = quantizestates(q,S);
end

% [EOF]
