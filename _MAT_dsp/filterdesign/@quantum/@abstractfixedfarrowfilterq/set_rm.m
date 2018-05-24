function rm = set_rm(q,rm)

%   Author(s): R. Losada
%   Copyright 1988-2006 The MathWorks, Inc.

if strcmpi(q.FilterInternals,'FullPrecision'),
    error(siguddutils('readonlyerror', 'RoundMode', 'FilterInternals', 'SpecifyPrecision'));
end

% Set mode of fimath
q.fimath.RoundMode = rm;
q.fdfimath.RoundMode = rm;

