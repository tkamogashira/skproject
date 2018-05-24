function outwl = set_outwl(q, outwl)
%SET_OUTWL   PreSet function for the 'OutputWordLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if strcmpi(q.FilterInternals,'FullPrecision'),
    siguddutils('readonlyerror', 'OutputWordLength', 'FilterInternals', ...
        'FullPrecision', false);
end

try
    q.privoutwl = outwl;
catch
    error(message('dsp:quantum:abstractfixedmultiratefilterq:set_outwl:MustBeInteger'));
end

% Store nothing to avoid duplication.
outwl = [];

% [EOF]
