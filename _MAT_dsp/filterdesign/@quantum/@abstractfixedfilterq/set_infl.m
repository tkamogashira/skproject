function infl = set_infl(this, infl)
%SET_INFL   PreSet function for the 'InputFracLength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privinfl = infl;
catch
    error(message('dsp:quantum:abstractfixedfilterq:set_infl:MustBeInteger'));
end

% Update any downstream automagic.
updateinternalsettings(this);

% Store nothing here to avoid duplication.
infl = [];

% [EOF]
