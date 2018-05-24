function svfl = set_svfl(this, svfl)
%SET_SVFL   PreSet function for the 'ScaleValueFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if this.CoeffAutoScale
    siguddutils('readonlyerror', 'ScaleValueFracLength', 'CoeffAutoScale', false);
end

try
    this.privcoefffl3 = svfl;
catch 
    error(message('dsp:quantum:abstractfixedsosfilterq:set_svfl:MustBeInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% quantizer changed, send a quantizecoeffs event
send_quantizecoeffs(this);

% Store nothing to avoid duplication,
svfl = [];

% [EOF]
