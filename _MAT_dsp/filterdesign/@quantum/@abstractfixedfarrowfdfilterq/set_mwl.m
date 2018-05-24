function mwl = set_mwl(this, mwl)
%SET_MWL   PreSet function for the 'mwl' property.

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

if strcmpi(this.FilterInternals,'FullPrecision'),
    error(siguddutils('readonlyerror', 'MultiplicandWordLength', 'FilterInternals', 'SpecifyPrecision'));
end

try
    this.privmultwl = mwl;
    this.fdfimath.SumWordLength = mwl;
catch
    error(message('dsp:quantum:abstractfixedfarrowfdfilterq:set_mwl:MustBePosInteger'));
end
mwl = [];


% [EOF]
