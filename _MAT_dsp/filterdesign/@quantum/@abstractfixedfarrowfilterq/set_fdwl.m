function fdwl = set_fdwl(this, fdwl)
%SET_FDWL

%   Author(s): V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.

try
    this.privfdwl = fdwl;
catch
    error(message('dsp:quantum:abstractfixedfarrowfilterq:set_fdwl:MustBePosInteger'));
end

% Send a quantizefracdelay event
send(this,'quantizefracdelay');

updateinternalsettings(this);

fdwl = [];


% [EOF]
