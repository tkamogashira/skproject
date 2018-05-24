function infl = set_infl(this, infl)
%SET_INFL   PreSet function for the 'InputFracLength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privinfl = infl;
catch
    error(message('dsp:quantum:fixedlatticefilterq:set_infl:MustBeInteger'));
end

% Update downstream automagic.
updateinternalsettings(this);

% Store nothing to avoid duplication.
infl = [];

% [EOF]
