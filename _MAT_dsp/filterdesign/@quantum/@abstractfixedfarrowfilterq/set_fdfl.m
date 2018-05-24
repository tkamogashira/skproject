function fdfl = set_fdfl(this, fdfl, prop)
%SET_FDFL   

%   Author(s): V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.

if nargin < 3
    prop = 'FDFracLength';
end

if this.FDAutoScale
    siguddutils('readonlyerror', prop, 'FDAutoScale', false);
end


try
    this.privfdfl = fdfl;
catch
    error(message('dsp:quantum:abstractfixedfarrowfilterq:set_fdfl:MustBeInteger'));
end

% Send a quantizefracdelay event
send(this,'quantizefracdelay');

updateinternalsettings(this);

fdfl = [];

% [EOF]
