function lataccumfl = set_lataccumfl(this, lataccumfl)
%SET_LATACCUMFL   PreSet function for the 'LatticeAccumFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if ~strcmpi(this.AccumMode, 'SpecifyPrecision')
    siguddutils('readonlyerror', 'LatticeAccumFracLength', 'AccumMode', 'SpecifyPrecision');
end

try
    this.fimath.SumFractionLength = lataccumfl;
catch 
    error(message('dsp:quantum:fixedlatticearmafilterq:set_lataccumfl:MustBeInteger'));
end

% Update any downstream automagic.
updateinternalsettings(this);

% Store nothing to eliminate duplication.
lataccumfl = [];

% [EOF]
