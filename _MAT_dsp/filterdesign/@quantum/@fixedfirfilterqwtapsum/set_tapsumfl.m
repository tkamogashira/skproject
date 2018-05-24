function tapsumfl = set_tapsumfl(this, tapsumfl)
%SET_TAPSUMFL   PreSet function for the 'TapSumFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if ~strcmpi(this.TapSumMode, 'SpecifyPrecision')
    siguddutils('readonlyerror', 'TapSumFracLength', 'TapSumMode', 'SpecifyPrecision');
end

try
    this.TapSumfimath.SumFractionLength = tapsumfl;
catch
    error(message('dsp:quantum:fixedfirfilterqwtapsum:set_tapsumfl:MustBeInteger'));
end

% Update downstream automagic.
updateinternalsettings(this);

% Don't store to eliminate duplication.
tapsumfl = [];

% [EOF]
