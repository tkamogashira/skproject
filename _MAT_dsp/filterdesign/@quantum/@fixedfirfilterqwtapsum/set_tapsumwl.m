function tapsumwl = set_tapsumwl(this, tapsumwl)
%SET_TAPSUMWL   PreSet function for the 'TapSumWordLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if strcmpi(this.TapSumMode, 'FullPrecision')
    siguddutils('readonlyerror', 'TapSumWordLength', 'TapSumMode', 'FullPrecision', false);
end

try
    this.TapSumfimath.SumWordLength = tapsumwl;
catch
    error(message('dsp:quantum:fixedfirfilterqwtapsum:set_tapsumwl:MustBePosInteger'));
end

% Update downstream automagic.
updateinternalsettings(this);

% Don't store to eliminate duplication.
tapsumwl = [];

% [EOF]
