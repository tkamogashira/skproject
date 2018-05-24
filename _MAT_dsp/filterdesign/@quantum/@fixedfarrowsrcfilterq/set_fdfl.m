function fdfl = set_fdfl(this, fdfl, prop)
%SET_FDFL   

%   Author(s): V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.

if this.FDAutoScale
    error(siguddutils('readonlyerror', 'FDFracLength', 'FDAutoScale', false));
end

if nargin < 3
    prop = 'FDFracLength';
end

try
    this.privfdfl = fdfl;
catch
    error(message('dsp:quantum:fixedfarrowsrcfilterq:set_fdfl:MustBeInteger'));
end

% Don't Send a quantizefracdelay event
updateinternalsettings(this);

fdfl = [];

% [EOF]
