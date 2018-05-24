function om = set_om(q,om)

%   Author(s): V. Pellissier
%   Copyright 1988-2006 The MathWorks, Inc.

if strcmpi(q.FilterInternals,'FullPrecision'),
    error(siguddutils('readonlyerror', 'OverflowMode', 'FilterInternals', 'SpecifyPrecision'));
end

% Set mode of fimath
q.fimath.OverflowMode = om;
q.fdfimath.OverflowMode = om;

