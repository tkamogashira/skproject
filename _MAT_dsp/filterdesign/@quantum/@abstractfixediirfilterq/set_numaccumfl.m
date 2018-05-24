function numaccumfl = set_numaccumfl(this, numaccumfl)
%SET_NUMACCUMFL   PreSet Function for the 'NumAccumFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if ~strcmpi(this.AccumMode, 'SpecifyPrecision')
    siguddutils('readonlyerror', 'NumAccumFracLength', 'AccumMode', 'SpecifyPrecision');
end

try
    this.fimath.SumFractionLength = numaccumfl;
catch 
    error(message('dsp:quantum:abstractfixediirfilterq:set_numaccumfl:MustBeInteger'));
end

% Update any downstream automagic.
updateinternalsettings(this);

% Store nothing to avoid duplicate storage.
numaccumfl = [];

% [EOF]
