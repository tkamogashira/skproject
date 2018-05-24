function ladfl = set_ladfl(this, ladfl)
%SET_LADFL   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if this.CoeffAutoScale
    error(siguddutils('readonlyerror', 'LadderFracLength', 'CoeffAutoScale', false));
end

try
    this.privcoefffl2 = ladfl;
    updateinternalsettings(this);
catch 
    error(message('dsp:quantum:fixedlatticearmafilterq:set_ladfl:MustBeInteger'));
end

% Quantizer changed, send a quantizecoeffs event
send_quantizecoeffs(this);

ladfl = [];

% [EOF]
