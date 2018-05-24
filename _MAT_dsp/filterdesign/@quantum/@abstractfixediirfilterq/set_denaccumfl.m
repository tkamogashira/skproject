function denaccumfl = set_denaccumfl(this, denaccumfl)
%SET_DENACCUMFL   PreSet function for the 'DenAccumFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if ~strcmpi(this.AccumMode, 'SpecifyPrecision')
    siguddutils('readonlyerror', 'DenAccumFracLength', 'AccumMode', 'SpecifyPrecision');
end

try
    this.fimath2.SumFractionLength = denaccumfl;
catch 
    error(message('dsp:quantum:abstractfixediirfilterq:set_denaccumfl:MustBeInteger'));
end

% Update any downstream automagic.
updateinternalsettings(this);

% Save nothing to avoid duplication.
denaccumfl = [];

% [EOF]
