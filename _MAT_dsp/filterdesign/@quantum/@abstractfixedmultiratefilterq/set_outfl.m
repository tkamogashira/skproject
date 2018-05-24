function outfl = set_outfl(q, outfl)
%SET_OUTFL   PreSet function for the 'OutputFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if strcmpi(q.FilterInternals,'FullPrecision'),
    siguddutils('readonlyerror', 'OutputFracLength', 'FilterInternals', ...
        'FullPrecision', false);
end

try
    q.privoutfl = outfl;
catch
    error(message('dsp:quantum:abstractfixedmultiratefilterq:set_outfl:MustBeInteger'));
end

% Store nothing to avoid duplication.
outfl = [];

% [EOF]
