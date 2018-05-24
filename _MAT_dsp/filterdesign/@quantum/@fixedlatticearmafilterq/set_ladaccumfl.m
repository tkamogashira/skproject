function ladaccumfl = set_ladaccumfl(this, ladaccumfl)
%SET_LADACCUMFL   PreSet function for the 'LadderAccumFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if ~strcmpi(this.AccumMode, 'SpecifyPrecision')
    siguddutils('readonlyerror', 'LadderAccumFracLength', 'AccumMode', 'SpecifyPrecision');
end

try
    this.fimath2.SumFractionLength = ladaccumfl;
catch 
    error(message('dsp:quantum:fixedlatticearmafilterq:set_ladaccumfl:MustBeInteger'));
end

% Update any downstream automagic.
updateinternalsettings(this);

% Store nothing to eliminate duplication.
ladaccumfl = [];

% [EOF]
