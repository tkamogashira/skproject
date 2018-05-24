function numfl = set_numfl(this, numfl)
%SET_NUMFL   PreSet function for the 'NumFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if this.CoeffAutoScale
    siguddutils('readonlyerror', 'NumFracLength', 'CoeffAutoScale', false);
end

try
    this.privcoefffl = numfl;
catch 
    error(message('dsp:quantum:fixeddf1filterq:set_numfl:MustBeInteger'));
end

% Quantizer changed, send a quantizecoeffs event
send_quantizecoeffs(this);

% Update the downstream automagic.
updateinternalsettings(this);

% Store nothing here to avoid duplication.
numfl = [];

% [EOF]
