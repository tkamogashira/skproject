function accumfl = set_accumfl(q, accumfl)
%SET_ACCUMFL   PreSet function for the 'AccumFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if strcmpi(q.FilterInternals,'FullPrecision'),
    siguddutils('readonlyerror', 'AccumFracLength', 'FilterInternals', ...
        'FullPrecision', false);
end

try
    q.fimath.SumFractionLength = accumfl;
    thisset_accumfl(q, accumfl);
catch 
    error(message('dsp:quantum:abstractfixedmultiratefilterq:set_accumfl:MustBeInteger'));
end

% Store nothing here to avoid duplication.
accumfl = [];

% [EOF]
