function outputmode = set_outputmode(this, outputmode)
%SET_OUTPUTMODE   PreSet function for the 'outputmode' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

this.privOutputMode = outputmode;

updateinternalsettings(this);

% [EOF]
