function mfl = set_mfl(this, mfl)
%SET_MFL   PreSet function for the 'mfl' property.

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

if strcmpi(this.FilterInternals,'FullPrecision'),
    error(siguddutils('readonlyerror', 'MultiplicandFracLength', 'FilterInternals', 'SpecifyPrecision'));
end

try
    this.privmultfl = mfl;
    this.fdfimath.SumFractionLength = mfl;
catch
    error(message('dsp:quantum:abstractfixedfarrowfdfilterq:set_mfl:MustBeInteger'));
end
mfl = [];

% [EOF]


% [EOF]
