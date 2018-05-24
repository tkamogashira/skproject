function fdfl = set_fdfl(this, fdfl)
%SET_FDFL   

%   Author(s): V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.

if this.FDAutoScale
    error(siguddutils('readonlyerror', 'FDFracLength', 'FDAutoScale', false));
end

try
    this.privfdfl = fdfl;
catch
    error(message('dsp:quantum:abstractfixedfarrowfdfilterq:set_fdfl:MustBeInteger'));
end

% Send a quantizefracdelay event
send(this,'quantizefracdelay');

updateinternalsettings(this);

fdfl = [];

% [EOF]
