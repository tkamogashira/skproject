function stageinfl = set_stageinfl(this, stageinfl)
%SET_STAGEINFL   PreSet function for the 'stageinfl' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privstageinfl = stageinfl;
catch
    error(message('dsp:quantum:abstractfixedsos2filterq:set_stageinfl:MustBeInteger'));
end

% Update downstream automagic.
updateinternalsettings(this);

% Store nothing to avoid duplication.
stageinfl = [];

% [EOF]
