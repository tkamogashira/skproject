function numfl = set_numfl(this, numfl)
%SET_NUMFL   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if this.CoeffAutoScale
    error(siguddutils('readonlyerror', 'NumFracLength', 'CoeffAutoScale', false));
end

try
    this.privcoefffl = numfl;
    updateinternalsettings(this);
catch 
    error(message('dsp:quantum:abstractfixedmultiratefilterq:set_numfl:MustBeInteger'));
end


% Quantizer changed, send a quantizecoeffs event
send_quantizecoeffs(this);

numfl = [];

% [EOF]
