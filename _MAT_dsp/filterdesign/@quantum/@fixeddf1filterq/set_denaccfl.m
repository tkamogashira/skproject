function accumfl = set_denaccumfl(this, accumfl)
%SET_DENACCUMFL   PreSet function for the 'DenAccumFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if ~strcmpi(this.AccumMode, 'SpecifyPrecision')
    siguddutils('readonlyerror', 'DenAccumFracLength', 'AccumMode', 'SpecifyPrecision');
end

try
    this.fimath2.SumFractionLength = accumfl;
catch
    error(message('dsp:quantum:fixeddf1filterq:set_denaccfl:MustBeInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% Don't store anything here to avoid duplication.
accumfl = [];

% [EOF]
