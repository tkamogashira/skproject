function accumwl = set_accumwl(q, accumwl)
%SET_ACCUMWL   PreSet function for the 'AccumWordLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if strcmpi(q.FilterInternals,'FullPrecision'),
    siguddutils('readonlyerror', 'AccumWordLength', 'FilterInternals', ...
        'FullPrecision', false);
end

try
    q.fimath.SumWordLength = accumwl;
    thisset_accumwl(q,accumwl);
catch 
    error(message('dsp:quantum:abstractfixedmultiratefilterq:set_accumwl:MustBePosInteger'));
end

% Store nothing here to avoid duplication.
accumwl = [];

% [EOF]
