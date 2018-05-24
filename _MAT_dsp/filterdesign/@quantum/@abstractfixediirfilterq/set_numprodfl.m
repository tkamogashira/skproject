function numprodfl = set_numprodfl(this, numprodfl)
%SET_NUMPRODFL   PreSet function for the 'NumProdFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if ~strcmpi(this.ProductMode, 'SpecifyPrecision')
    siguddutils('readonlyerror', 'NumProdFracLength', 'ProductMode', 'SpecifyPrecision');
end

try
    this.fimath.ProductFractionLength = numprodfl;
catch 
    error(message('dsp:quantum:abstractfixediirfilterq:set_numprodfl:MustBeInteger'));
end

% Update any downstream automagic.
updateinternalsettings(this);

% Store nothing here to avoid duplication.
numprodfl = [];

% [EOF]
