function fdwl = set_fdwl(this, fdwl)
%SET_FDWL

%   Author(s): V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.

try
    this.privfdwl = fdwl;
catch
    error(message('dsp:quantum:fixedfarrowsrcfilterq:set_fdwl:MustBePosInteger'));
end

if this.FDAutoScale,
    this.privfdfl = fdwl-1;
end

% Don't send a quantizefracdelay event
updateinternalsettings(this);

fdwl = [];


% [EOF]
