function outfl = set_outfl(this, outfl)
%SET_OUTFL   PreSet function for the 'OutputFracLength'.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if ~strcmpi(this.outputmode, 'specifyprecision')
    siguddutils('readonlyerror', 'OutputFracLength', 'OutputMode', 'SpecifyPrecision');
end

try
    this.privoutfl = outfl;
catch 
    error(message('dsp:quantum:abstractfixedoutfilterq:set_outfl:MustBeInteger'));
end

outfl = [];

% [EOF]
