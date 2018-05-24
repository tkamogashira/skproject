function infl = set_infl(this, infl)
%SET_INFL   

%   Author(s): M. Chugh
%   Copyright 2005 The MathWorks, Inc.

this.privinfl = infl;

% Quantizer changed, send a quantizestates event
send_quantizestates(this);

% Store nothing to avoid duplication.
infl = [];

% [EOF]
