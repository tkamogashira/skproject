function multfl = set_multfl(this, multfl)
%SET_MULTFL   PreSet function for the 'MultiplicandFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privmultfl = multfl;
catch
    error(message('dsp:quantum:fixeddf1tfilterq:set_multfl:MustBeInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% Store nothing to avoid duplication.
multifl = [];

% [EOF]
