function numfl = set_numfl(this, numfl, prop)
%SET_NUMFL   PreSet function for the coeff frac length property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if nargin < 3
    prop = 'NumFracLength';
end

if this.CoeffAutoScale
    siguddutils('readonlyerror', prop, 'CoeffAutoScale', false);
end

try
    this.privcoefffl = numfl;
    updateinternalsettings(this);
catch 
    error(message('dsp:quantum:abstractfixednonscalarfilterq:set_numfl:MustBeInteger', prop));
end

% Quantizer changed, send a quantizecoeffs event
send_quantizecoeffs(this);

% Store nothing to avoid duplication.
numfl = [];

% [EOF]
