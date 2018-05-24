function latfl = set_latfl(q, latfl)
%SET_LATL   PreSet function for the 'LatticeFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if this.CoeffAutoScale
    siguddutils('readonlyerror', 'LatticeFracLength', 'CoeffAutoScale', false);
end

try
    q.privcoefffl = latfl;
catch
    error(message('dsp:quantum:fixedlatticefilterq:set_latfl:MustBeInteger'));
end

% Update the downstream automagic.
updateinternalsettings(q);

% Quantizer changed, send a quantizecoeffs event
send_quantizecoeffs(q);

% Store nothing to avoid duplication.
latfl = [];

% [EOF]
