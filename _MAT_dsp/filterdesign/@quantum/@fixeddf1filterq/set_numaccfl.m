function accumfl = set_numaccumfl(this, accumfl)
%SET_NUMACCUMFL   PreSet function for the 'NumAccumFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if ~strcmpi(this.AccumMode, 'SpecifyPrecision')
    siguddutils('readonlyerror', 'NumAccumFracLength', 'AccumMode', 'SpecifyPrecision');
end

try
    this.fimath.SumFractionLength = accumfl;
catch
    error(message('dsp:quantum:fixeddf1filterq:set_numaccfl:MustBeInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% Store nothing here to avoid duplication.
accumfl = [];

% [EOF]
